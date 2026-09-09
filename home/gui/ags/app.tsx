import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import {
  createBinding,
  createComputed,
  createState,
  For,
  onCleanup,
  This,
} from "ags"
import { readFileAsync } from "ags/file"
import { createSubprocess, execAsync } from "ags/process"
import { createPoll, interval } from "ags/time"
import GLib from "gi://GLib?version=2.0"
import Hyprland from "gi://AstalHyprland"
import Tray from "gi://AstalTray"
import Wp from "gi://AstalWp"
import style from "./style.scss"

const home = GLib.get_home_dir()
const configRoot = GLib.build_filenamev([home, "nixos-config"])
const script = (name: string) =>
  GLib.build_filenamev([configRoot, "scripts", name])

function run(command: string[]) {
  execAsync(command).catch((error) =>
    console.error(`command failed (${command.join(" ")}):`, error),
  )
}

function ActionButton({
  cssClass,
  icon,
  tooltip,
  command,
}: {
  cssClass: string
  icon: string
  tooltip: string
  command: string[]
}) {
  return (
    <button
      class={`module action ${cssClass}`}
      tooltipText={tooltip}
      onClicked={() => run(command)}
    >
      <label label={icon} />
    </button>
  )
}

function Workspaces() {
  const hyprland = Hyprland.get_default()
  const focused = createBinding(hyprland, "focusedWorkspace")
  const workspaces = createBinding(hyprland, "workspaces")
  const [urgentIds, setUrgentIds] = createState<number[]>([])

  const urgentSignal = hyprland.connect("urgent", (_, client) => {
    const id = client.workspace.id
    if (!urgentIds().includes(id)) setUrgentIds([...urgentIds(), id])
  })
  const focusedSignal = hyprland.connect("notify::focused-workspace", () => {
    const id = hyprland.focusedWorkspace.id
    setUrgentIds(urgentIds().filter((urgentId) => urgentId !== id))
  })

  onCleanup(() => {
    hyprland.disconnect(urgentSignal)
    hyprland.disconnect(focusedSignal)
  })

  const icons: Record<number, string> = {
    7: "󰙯",
    8: "󰒱",
    9: "󰖟",
    10: "",
  }

  return (
    <box class="workspaces">
      {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((id) => {
        const cssClass = createComputed(() => {
          if (focused().id === id) return "workspace active"
          if (urgentIds().includes(id)) return "workspace urgent"
          if (workspaces().some((workspace) => workspace.id === id))
            return "workspace occupied"
          return "workspace empty"
        })

        return (
          <button
            class={cssClass}
            tooltipText={`Workspace ${id}`}
            onClicked={() => hyprland.dispatch("workspace", id.toString())}
          >
            <label label={icons[id] ?? id.toString()} />
          </button>
        )
      })}
    </box>
  )
}

function Clock() {
  const time = createPoll("", 60_000, () =>
    GLib.DateTime.new_now_local().format("  %b %d %a  %p %I:%M")!,
  )
  const tooltip = createPoll("", 60_000, () =>
    GLib.DateTime.new_now_local().format("%Y %B %d, %A")!,
  )

  return (
    <menubutton class="module clock" tooltipText={tooltip}>
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}

type RecordingState = {
  text: string
  class: string
  tooltip: string
}

const recordingRefreshers = new Set<() => void>()

function Recording() {
  const [status, setStatus] = createState<RecordingState>({
    text: "  ",
    class: "idle",
    tooltip: "Click to start screen recording",
  })

  async function refresh() {
    try {
      const output = await execAsync([script("gsr_status.sh")])
      setStatus(JSON.parse(output) as RecordingState)
    } catch (error) {
      console.error("failed to read recording status:", error)
    }
  }

  const timer = interval(2_000, refresh)
  recordingRefreshers.add(refresh)
  onCleanup(() => {
    timer.cancel()
    recordingRefreshers.delete(refresh)
  })

  return (
    <button
      class={status((value) => `module action record ${value.class}`)}
      tooltipText={status((value) => value.tooltip)}
      onClicked={() => run([script("gsr_toggle.sh")])}
    >
      <label label={status((value) => value.text)} />
    </button>
  )
}

const meetAudioRefreshers = new Set<() => void>()

function MeetAudio() {
  const [status, setStatus] = createState<RecordingState>({
    text: "  ",
    class: "idle",
    tooltip: "System audio -> mic: OFF (click to enable)",
  })

  async function refresh() {
    try {
      const output = await execAsync([script("meet_audio_status.sh")])
      setStatus(JSON.parse(output) as RecordingState)
    } catch (error) {
      console.error("failed to read meet-audio status:", error)
    }
  }

  const timer = interval(5_000, refresh)
  meetAudioRefreshers.add(refresh)
  onCleanup(() => {
    timer.cancel()
    meetAudioRefreshers.delete(refresh)
  })

  return (
    <button
      class={status((value) => `module action meet-audio ${value.class}`)}
      tooltipText={status((value) => value.tooltip)}
      onClicked={() => run([script("meet_audio_toggle.sh")])}
    >
      <label label={status((value) => value.text)} />
    </button>
  )
}

type AiUsageWindow = {
  label: string
  remaining_percent: number
  resets_at?: string
}

type AiUsageProvider = {
  provider: string
  plan?: string
  email?: string
  error?: string
  windows?: AiUsageWindow[]
  cost?: {
    used: number
    limit?: number | null
    currency?: string
    period?: string
  }
}

type AiUsageState = {
  details: string
  status: "normal" | "mid" | "critical" | "unavailable"
}

function formatAiUsage(providers: AiUsageProvider[]): AiUsageState {
  const lines = ["AI Usage Quotas", "──────────────────────────"]
  const remaining: number[] = []
  let hasData = false

  for (const provider of providers) {
    const windows = provider.windows ?? []
    if (windows.length === 0 && !provider.cost) continue

    hasData = true
    const suffix = [
      provider.plan ? `[${provider.plan}]` : "",
      provider.email ? `(${provider.email})` : "",
    ]
      .filter(Boolean)
      .join(" ")
    lines.push(`${provider.provider}${suffix ? ` ${suffix}` : ""}`)

    for (const window of windows) {
      if (Number.isFinite(window.remaining_percent))
        remaining.push(window.remaining_percent)
      const reset = window.resets_at
        ? window.resets_at.toLowerCase().startsWith("active") ||
          window.resets_at.toLowerCase().startsWith("token") ||
          window.resets_at.toLowerCase().startsWith("resets")
          ? ` (${window.resets_at})`
          : ` (resets in ${window.resets_at})`
        : ""
      lines.push(
        `  • ${window.label}: ${window.remaining_percent.toFixed(1)}% left${reset}`,
      )
    }

    if (provider.cost) {
      const limit = provider.cost.limit
        ? ` / $${provider.cost.limit.toFixed(2)}`
        : ""
      const period = provider.cost.period ? ` (${provider.cost.period})` : ""
      lines.push(`  • Cost: $${provider.cost.used.toFixed(2)}${limit}${period}`)
    }
    lines.push("")
  }

  if (!hasData) {
    const errors = providers
      .filter((provider) => provider.error)
      .map((provider) => `  • ${provider.provider}: ${provider.error}`)
    lines.push("No active quota data found.", ...errors, "")
  }

  lines.push(
    `Updated: ${GLib.DateTime.new_now_local().format("%H:%M:%S")!}`,
  )

  const minimum = remaining.length > 0 ? Math.min(...remaining) : null
  const status =
    minimum === null
      ? "unavailable"
      : minimum <= 20
        ? "critical"
        : minimum <= 50
          ? "mid"
          : "normal"

  return { details: lines.join("\n").trim(), status }
}

function AiUsage() {
  const [state, setState] = createState<AiUsageState>({
    details: "Loading AI usage…",
    status: "unavailable",
  })
  let refreshing = false

  async function refresh() {
    if (refreshing) return
    refreshing = true
    try {
      const output = await execAsync(["ai-usage", "--json"])
      setState(formatAiUsage(JSON.parse(output) as AiUsageProvider[]))
    } catch (error) {
      console.error("failed to read AI usage:", error)
      setState({
        details: "Unable to read AI usage.\nRun `ai-usage --json` for details.",
        status: "unavailable",
      })
    } finally {
      refreshing = false
    }
  }

  void refresh()
  const timer = interval(300_000, refresh)
  onCleanup(() => timer.cancel())

  return (
    <menubutton
      class={state((value) => `module ai-usage ${value.status}`)}
      tooltipText={state((value) => value.details)}
    >
      <image iconName="ai-usage" pixelSize={18} />
      <popover>
        <box
          class="ai-usage-details"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={8}
        >
          <label
            class="ai-usage-summary"
            label={state((value) => value.details)}
            selectable
            wrap
            xalign={0}
          />
          <button onClicked={() => void refresh()}>
            <label label="  Refresh now" />
          </button>
        </box>
      </popover>
    </menubutton>
  )
}

type CpuSample = { idle: number; total: number }

function Cpu() {
  let previous: CpuSample | null = null
  const usage = createPoll(0, 2_000, async (oldValue) => {
    try {
      const line = (await readFileAsync("/proc/stat")).split("\n")[0]
      const values = line
        .trim()
        .split(/\s+/)
        .slice(1, 9)
        .map(Number)
      const sample = {
        idle: values[3] + values[4],
        total: values.reduce((sum, value) => sum + value, 0),
      }
      if (previous === null) {
        previous = sample
        return oldValue
      }

      const totalDelta = sample.total - previous.total
      const idleDelta = sample.idle - previous.idle
      previous = sample
      return totalDelta > 0
        ? Math.round(((totalDelta - idleDelta) / totalDelta) * 100)
        : oldValue
    } catch (error) {
      console.error("failed to read CPU usage:", error)
      return oldValue
    }
  })

  return (
    <label
      class={usage((value) =>
        `module cpu ${value >= 90 ? "high" : value >= 80 ? "mid" : ""}`,
      )}
      label={usage((value) => `  ${value}%`)}
      tooltipText="CPU usage"
    />
  )
}

function Memory() {
  const usage = createPoll(0, 2_000, async (oldValue) => {
    try {
      const values: Record<string, number> = {}
      for (const line of (await readFileAsync("/proc/meminfo")).split("\n")) {
        const match = line.match(/^(\w+):\s+(\d+)/)
        if (match) values[match[1]] = Number(match[2])
      }
      return Math.round(
        ((values.MemTotal - values.MemAvailable) / values.MemTotal) * 100,
      )
    } catch (error) {
      console.error("failed to read memory usage:", error)
      return oldValue
    }
  })

  return (
    <label
      class={usage((value) =>
        `module memory ${value >= 80 ? "high" : value >= 50 ? "mid" : ""}`,
      )}
      label={usage((value) => ` ${value}%`)}
      tooltipText="Memory usage"
    />
  )
}

function Disk() {
  const usage = createPoll(0, 15_000, async (oldValue) => {
    try {
      const output = await execAsync(["df", "-P", "/"])
      const lines = output.trim().split("\n")
      const fields = lines[lines.length - 1].trim().split(/\s+/)
      return Number(fields[4].replace("%", ""))
    } catch (error) {
      console.error("failed to read disk usage:", error)
      return oldValue
    }
  })

  return (
    <label
      class={usage((value) =>
        `module disk ${value >= 95 ? "high" : value >= 90 ? "mid" : ""}`,
      )}
      label={usage((value) => `󰋊 ${value}%`)}
      tooltipText="Root filesystem usage"
    />
  )
}

function Temperature() {
  const temperature = createPoll(0, 2_000, async (oldValue) => {
    try {
      const output = await execAsync([
        "bash",
        "-c",
        "for sensor in /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input; do test -r \"$sensor\" && head -n1 \"$sensor\" && break; done",
      ])
      const value = Number(output) / 1_000
      return Number.isFinite(value) ? value : oldValue
    } catch (error) {
      console.error("failed to read CPU temperature:", error)
      return oldValue
    }
  })

  return (
    <label
      class={temperature((value) =>
        `module temperature ${value >= 80 ? "critical" : ""}`,
      )}
      label={temperature((value) => `${Math.round(value)}°C `)}
      tooltipText="CPU Tctl temperature"
    />
  )
}

function Audio() {
  const wp = Wp.get_default()!
  const speaker = wp.defaultSpeaker
  const microphone = wp.defaultMicrophone
  const volume = createBinding(speaker, "volume")
  const muted = createBinding(speaker, "mute")
  const speakerName = createBinding(speaker, "name")
  const speakerDescription = createBinding(speaker, "description")
  const microphoneVolume = createBinding(microphone, "volume")
  const microphoneMuted = createBinding(microphone, "mute")

  const text = createComputed(() => {
    const value = Math.round(volume() * 100)
    if (muted()) {
      const source = microphoneMuted()
        ? ""
        : ` ${Math.round(microphoneVolume() * 100)}%`
      return `󰖁 ${source}`
    }

    const icon = value === 0 ? "" : value < 50 ? "" : ""
    const bluetooth = (speakerName() ?? "").toLowerCase().includes("bluez")
      ? " 󰂯"
      : ""
    return `${icon}  ${value}%${bluetooth}`
  })

  function scroll(_controller: Gtk.EventControllerScroll, _dx: number, dy: number) {
    if (dy === 0) return false
    speaker.set_volume(Math.min(1, Math.max(0, speaker.volume + (dy < 0 ? 0.01 : -0.01))))
    return true
  }

  return (
    <button
      class={muted((value) => `module audio ${value ? "muted" : ""}`)}
      tooltipText={speakerDescription((description) => description ?? "")}
      onClicked={() => run(["pavucontrol"])}
    >
      <Gtk.EventControllerScroll
        flags={Gtk.EventControllerScrollFlags.VERTICAL}
        onScroll={scroll}
      />
      <label label={text} />
    </button>
  )
}

function TrayItem({ item }: { item: Tray.TrayItem }) {
  function init(button: Gtk.MenuButton) {
    button.menuModel = item.menuModel
    button.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () =>
      button.insert_action_group("dbusmenu", item.actionGroup),
    )
  }

  return (
    <menubutton
      class="tray-item"
      tooltipMarkup={createBinding(item, "tooltipMarkup")}
      $={init}
    >
      <image pixelSize={18} gicon={createBinding(item, "gicon")} />
    </menubutton>
  )
}

function SystemTray() {
  const tray = Tray.get_default()
  const items = createBinding(tray, "items")

  return (
    <box class="module tray">
      <For each={items}>{(item) => <TrayItem item={item} />}</For>
    </box>
  )
}

type NotificationState = {
  text: string
  alt: string
  tooltip: string
  class: string
}

function Notifications() {
  const status = createSubprocess<NotificationState>(
    { text: "0", alt: "none", tooltip: "", class: "none" },
    ["swaync-client", "-swb"],
    (output, oldValue) => {
      try {
        return JSON.parse(output) as NotificationState
      } catch (error) {
        console.error("failed to parse SwayNC status:", error)
        return oldValue
      }
    },
  )

  const icon = status((value) => {
    switch (value.alt) {
      case "notification":
      case "inhibited-notification":
        return "<span foreground='red'><sup></sup></span>"
      case "dnd-notification":
      case "dnd-inhibited-notification":
        return "<span foreground='red'><sup></sup></span>"
      case "dnd-none":
      case "dnd-inhibited-none":
        return ""
      default:
        return ""
    }
  })

  function click(gesture: Gtk.GestureClick) {
    if (gesture.get_current_button() === Gdk.BUTTON_PRIMARY)
      run(["swaync-client", "-t", "-sw"])
    if (gesture.get_current_button() === Gdk.BUTTON_SECONDARY)
      run(["swaync-client", "-d", "-sw"])
  }

  return (
    <button
      class={status((value) => `module notification ${value.class}`)}
      tooltipText={status((value) => value.tooltip)}
    >
      <Gtk.GestureClick button={0} onReleased={click} />
      <label useMarkup label={icon} />
    </button>
  )
}

function Left() {
  return (
    <box class="panel modules-left" $type="start">
      <Workspaces />
    </box>
  )
}

function Center() {
  return (
    <box class="panel modules-center" $type="center">
      <Clock />
      <ActionButton
        cssClass="wallpaper"
        icon=" 󰸉 "
        tooltip="Change Wallpaper"
        command={[script("swww_randomize.sh")]}
      />
      <Recording />
      <MeetAudio />
      <ActionButton
        cssClass="colorpicker"
        icon=" 󰴱 "
        tooltip="Color Picker"
        command={[script("colorpicker.sh")]}
      />
      <ActionButton
        cssClass="keybindings"
        icon=" 󰍉 "
        tooltip="Hotkeys"
        command={[script("rofi_keybindings.sh")]}
      />
    </box>
  )
}

function Right() {
  return (
    <box class="panel modules-right" $type="end">
      <Cpu />
      <Temperature />
      <Memory />
      <Disk />
      <Audio />
      <AiUsage />
      <Notifications />
      <SystemTray />
      <ActionButton
        cssClass="power"
        icon=" "
        tooltip="Power menu"
        command={["wlogout"]}
      />
    </box>
  )
}

const bars = new Set<Astal.Window>()

function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let window: Astal.Window
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  onCleanup(() => {
    bars.delete(window)
    window.destroy()
  })

  return (
    <window
      $={(self) => {
        window = self
        bars.add(self)
      }}
      visible
      name={`bar-${gdkmonitor.connector}`}
      namespace="ags-bar"
      class="bar"
      application={app}
      gdkmonitor={gdkmonitor}
      layer={Astal.Layer.TOP}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      marginTop={4}
      marginLeft={10}
      marginRight={10}
      heightRequest={38}
    >
      <centerbox class="bar-layout" hexpand>
        <Left />
        <Center />
        <Right />
      </centerbox>
    </window>
  )
}

app.start({
  css: style,
  gtkTheme: "Adwaita",
  requestHandler(argv, response) {
    switch (argv[0]) {
      case "toggle-bar": {
        const hide = Array.from(bars).some((bar) => bar.visible)
        for (const bar of bars) bar.visible = !hide
        response(hide ? "hidden" : "visible")
        return
      }
      case "refresh-recording":
        for (const refresh of recordingRefreshers) refresh()
        response("ok")
        return
      case "refresh-meet-audio":
        for (const refresh of meetAudioRefreshers) refresh()
        response("ok")
        return
      default:
        response(`unknown request: ${argv.join(" ")}`)
    }
  },
  main() {
    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
