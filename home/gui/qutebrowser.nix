{ pkgs, ... }:

let
  qutebrowserConfig = # python
    ''
      config.load_autoconfig()

      # Basic Keybindings
      config.bind('j', 'scroll-px 0 100')
      config.bind('k', 'scroll-px 0 -100')
      config.bind('<Ctrl-j>', 'completion-item-focus next --history', mode='command')
      config.bind('<Ctrl-k>', 'completion-item-focus prev --history', mode='command')
      config.bind('t', 'cmd-set-text -s :open -t')
      config.bind('T', 'cmd-set-text -s :tab-select')
      config.bind('x', 'tab-close')
      config.bind('X', 'tab-only')


      # Browser settings
      c.auto_save.session = True  # Automatically save sessions
      c.session.lazy_restore = True  # Restore tabs without loading until clicked

      c.url.start_pages = 'https://www.bing.com/'
      c.url.default_page = 'https://www.bing.com/'
      """
      Others search engines
      1. DuckDuckGo: https://duckduckgo.com/?q={}
      2. Google: https://www.google.com/search?q={}
      3. Bing: https://www.bing.com/search?q={}
      """
      c.url.searchengines = {
          'DEFAULT': 'https://www.bing.com/search?q={}',
          }

      c.scrolling.smooth = True

      # Colors
      # Ref: https://github.com/KnownAsDon/QuteBrowser-Nord-Theme/blob/master/config.py
      nord = {
          'base03': '#3b4252',
          'base02': '#434c5e',
          'base01': '#e5e9f0',
          'base00': '#d8dee9',
          'base0': '#4c566a',
          'base1': '#5e81ac',
          'base2': '#eee8d5',
          'base3': '#eceff4',
          'yellow': '#ebcb8b',
          'orange': '#ebcb8b',
          'red': '#bf616a',
          'magenta': '#b48ead',
          'violet': '#8fbcbb',
          'blue': '#5e81ac',
          'cyan': '#88c0d0',
          'green': '#a3be8c'
      }

      c.colors.completion.category.bg = nord['base03']
      c.colors.completion.category.border.bottom = nord['base03']
      c.colors.completion.category.border.top = nord['base03']
      c.colors.completion.category.fg = nord['base3']
      c.colors.completion.even.bg = nord['base02']
      c.colors.completion.fg = nord['base3']
      c.colors.completion.item.selected.bg = nord['violet']
      c.colors.completion.item.selected.border.bottom = nord['violet']
      c.colors.completion.item.selected.border.top = nord['violet']
      c.colors.completion.item.selected.fg = nord['base3']
      c.colors.completion.match.fg = nord['base2']
      c.colors.completion.odd.bg = nord['base02']
      c.colors.completion.scrollbar.bg = nord['base0']
      c.colors.completion.scrollbar.fg = nord['base2']
      c.colors.downloads.bar.bg = nord['base03']
      c.colors.downloads.error.bg = nord['red']
      c.colors.downloads.error.fg = nord['base3']

      c.colors.downloads.start.bg = '#0000aa'
      c.colors.downloads.start.fg = nord['base3']
      c.colors.downloads.stop.bg = '#00aa00'
      c.colors.downloads.stop.fg = nord['base3']
      c.colors.downloads.system.bg = 'rgb'
      c.colors.downloads.system.fg = 'rgb'

      c.colors.hints.bg = nord['violet']
      c.colors.hints.fg = nord['base3']
      c.colors.hints.match.fg = nord['base2']

      c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'
      c.colors.keyhint.fg = nord['base3']
      c.colors.keyhint.suffix.fg = nord['yellow']

      c.colors.messages.error.bg = nord['red']
      c.colors.messages.error.border = nord['red']
      c.colors.messages.error.fg = nord['base3']
      c.colors.messages.info.bg = nord['base03']
      c.colors.messages.info.border = nord['base03']
      c.colors.messages.info.fg = nord['base3']
      c.colors.messages.warning.bg = nord['orange']
      c.colors.messages.warning.border = nord['orange']
      c.colors.messages.warning.fg = nord['base3']

      c.colors.prompts.bg = nord['base02']
      c.colors.prompts.border = '1px solid ' + nord['base3']
      c.colors.prompts.fg = nord['base3']
      c.colors.prompts.selected.bg = nord['base01']

      c.colors.statusbar.caret.bg = nord['blue']
      c.colors.statusbar.caret.fg = nord['base3']
      c.colors.statusbar.caret.selection.bg = nord['violet']
      c.colors.statusbar.caret.selection.fg = nord['base3']
      c.colors.statusbar.command.bg = nord['base03']
      c.colors.statusbar.command.fg = nord['base3']
      c.colors.statusbar.command.private.bg = nord['base01']
      c.colors.statusbar.command.private.fg = nord['base3']
      c.colors.statusbar.insert.bg = nord['green']
      c.colors.statusbar.insert.fg = nord['base3']
      c.colors.statusbar.normal.bg = nord['base03']
      c.colors.statusbar.normal.fg = nord['base3']
      c.colors.statusbar.passthrough.bg = nord['magenta']
      c.colors.statusbar.passthrough.fg = nord['base3']
      c.colors.statusbar.private.bg = nord['base01']
      c.colors.statusbar.private.fg = nord['base3']
      c.colors.statusbar.progress.bg = nord['base3']
      c.colors.statusbar.url.error.fg = nord['red']
      c.colors.statusbar.url.fg = nord['base3']
      c.colors.statusbar.url.hover.fg = nord['base2']
      c.colors.statusbar.url.success.http.fg = nord['base3']
      c.colors.statusbar.url.success.https.fg = nord['base3']
      c.colors.statusbar.url.warn.fg = nord['yellow']

      c.colors.tabs.bar.bg = '#555555'
      c.colors.tabs.even.bg = nord['base01']
      c.colors.tabs.even.fg = nord['base2']
      c.colors.tabs.indicator.error = nord['red']
      c.colors.tabs.indicator.start = nord['violet']
      c.colors.tabs.indicator.stop = nord['orange']
      c.colors.tabs.indicator.system = 'rgb'
      c.colors.tabs.odd.bg = nord['base01']
      c.colors.tabs.odd.fg = nord['base2']
      c.colors.tabs.selected.even.bg = nord['base03']
      c.colors.tabs.selected.even.fg = nord['base3']
      c.colors.tabs.selected.odd.bg = nord['base03']
      c.colors.tabs.selected.odd.fg = nord['base3']

    '';
in {
  home.file.".config/qutebrowser/config.py".text = qutebrowserConfig;

  home.packages = with pkgs; [ qutebrowser ];
}
