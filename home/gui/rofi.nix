{ pkgs, ... }:

let
  rofiConfig = ''
  /* Key Bindings */
  configuration {
      kb-select-1: "Ctrl+1";
      kb-select-2: "Ctrl+2";
      kb-select-3: "Ctrl+3";
      kb-select-4: "Ctrl+4";
      kb-select-5: "Ctrl+5";
      kb-select-6: "Ctrl+6";
      kb-select-7: "Ctrl+7";
      kb-select-8: "Ctrl+8";
      kb-select-9: "Ctrl+9";
      kb-select-10: "Ctrl+0";
      kb-accept-entry: "Return,KP_Enter";
      kb-remove-to-eol: "";
      kb-row-down: "Ctrl+j,Ctrl+n,Down";
      kb-row-up: "Ctrl+k,Ctrl+p,Up";
      kb-cancel: "Escape,Ctrl+g,Ctrl+bracketleft";
      
      modes: [window,drun,run,ssh,emoji,calc];
  }
  /*******************************************************************************
  * ROUNDED THEME FOR ROFI 
  * User                 : LR-Tech               
  * Theme Repo           : https://github.com/lr-tech/rofi-themes-collection
  *******************************************************************************/
 
  * {
      bg0:    #2E3440F2;
      bg1:    #3B4252;
      bg2:    #4C566A80;
      bg3:    #88C0D0F2;
      fg0:    #D8DEE9;
      fg1:    #ECEFF4;
      fg2:    #D8DEE9;
      fg3:    #4C566A;
  }

  * {
    background-color:   transparent;
    text-color:         @fg0;

    margin:     0px;
    padding:    0px;
    spacing:    0px;
  }

  window {
    location:       center;
    width:          640;
    border-radius:  24px;
    background-color:   @bg0;
  }

  mainbox {
    padding:    12px;
  }

  inputbar {
    background-color:   @bg1;
    border-color:       @bg3;

    border:         2px;
    border-radius:  16px;

    padding:    8px 16px;
    spacing:    8px;
    children:   [ prompt, entry ];
  }

  prompt {
    text-color: @fg2;
  }

  entry {
      placeholder:        "...";
      placeholder-color:  @fg3;
  }

  message {
      margin:             12px 0 0;
      border-radius:      16px;
      border-color:       @bg2;
      background-color:   @bg2;
  }

  textbox {
      padding:    8px 24px;
  }

  listview {
      background-color:   transparent;
  
      margin:     12px 0 0;
      lines:      10;
      columns:    1;
  
      fixed-height: false;
  }
  
  element {
      padding:        8px 16px;
      spacing:        8px;
      border-radius:  16px;
  }
  
  element normal active {
      text-color: @bg3;
  }
  
  element selected normal, element selected active {
      background-color:   @bg3;
  }
  
  element-icon {
      size:           1em;
      vertical-align: 0.5;
  }
  
  element-text {
      text-color: inherit;
  }
  
  element selected {
      text-color: @bg1;
  }
  '';
in {
  home.file.".config/rofi/nord.rasi".text = rofiConfig;

  programs.rofi = {
    enable = true;
    theme = "nord.rasi";
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-calc
    ];
  };
}
