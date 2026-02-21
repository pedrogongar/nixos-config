{ config, pkgs, ... }:

let
  c = import ./colores.nix;
in
{
  xdg.configFile = {
    "swaync/config.json".source = ./swaync/config.json;
    "swaync/style.css".text = ''
      @define-color bg      rgba(${c.base_rgb}, 0.92);
      @define-color bg-alt  rgba(${c.mantle_rgb}, 0.98);
      @define-color border  rgba(${c.oro_rgb}, 0.18);
      @define-color text    ${c.text};
      @define-color text-dim ${c.subtext};
      @define-color accent  ${c.oro};
      @define-color urgent  ${c.rojo};

      * {
          font-family: "JetBrains Mono Nerd Font", monospace;
          font-size: 12px;
      }

      .control-center {
          background: @bg;
          border: 1px solid @border;
          border-radius: 10px;
          padding: 8px;
      }

      .notification {
          background: @bg-alt;
          border: 1px solid @border;
          border-radius: 8px;
          margin: 4px 0;
          padding: 12px;
      }

      .notification-content {
          color: @text;
      }

      .summary {
          font-weight: 600;
          font-size: 12px;
          color: @text;
      }

      .body {
          font-size: 11px;
          color: @text-dim;
      }

      .time {
          font-size: 10px;
          color: @text-dim;
      }

      .close-button {
          background: transparent;
          border: none;
          color: @text-dim;
          border-radius: 6px;
          padding: 4px;
      }

      .close-button:hover {
          background: rgba(${c.rojo_rgb}, 0.15);
          color: @urgent;
      }

      .widget-title {
          color: @text;
          font-weight: 600;
          font-size: 12px;
          padding: 8px 12px;
      }

      .widget-title button {
          background: rgba(${c.oro_rgb}, 0.08);
          border: 1px solid @border;
          border-radius: 6px;
          color: @text;
          padding: 4px 12px;
          font-size: 11px;
      }

      .widget-title button:hover {
          background: rgba(${c.oro_rgb}, 0.15);
          border-color: @accent;
      }

      .widget-dnd {
          padding: 4px 12px;
          color: @text-dim;
          font-size: 11px;
      }

      .widget-dnd > switch {
          background: @bg-alt;
          border: 1px solid @border;
          border-radius: 12px;
      }

      .widget-dnd > switch:checked {
          background: rgba(${c.oro_rgb}, 0.25);
      }

      .widget-dnd > switch slider {
          background: @accent;
          border-radius: 10px;
      }

      .notification-default-action {
          border-radius: 8px;
      }

      .notification-default-action:hover {
          background: rgba(${c.oro_rgb}, 0.05);
      }

      .critical {
          border-color: @urgent;
      }
    '';
  };
}
