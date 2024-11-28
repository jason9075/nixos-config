local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("nix", {
  s(
    { trig = "flake", descr = "flake.nix template" },
    fmta(
      [[
{
  description = "<desc>";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = inputs@{ ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-unstable = import inputs."nixpkgs-unstable" {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "<proj_name>";
        nativeBuildInputs = with pkgs; [ entr ];

        shellHook = ''
          echo "<hook_msg>";
        '';
      };
    };
}
            ]],
      {
        desc = i(1, "Development environment for projects"),
        proj_name = i(2, "project-name"),
        hook_msg = i(3, "project environment activated."),
      }
    )
  ),
})