{ config, pkgs, ... }:

let
  c = import ./colores.nix;

  pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ps.pycairo ]);

  selectorScript = pkgs.writeTextFile {
    name = "wallpaper-selector.py";
    text = ''
      import gi
      gi.require_version('Gtk', '4.0')
      gi.require_version('GdkPixbuf', '2.0')
      from gi.repository import Gtk, GdkPixbuf, Gdk, GLib
      import os, subprocess, hashlib, re

      WALLPAPER_DIR = os.path.expanduser("~/imagenes/wallpapers")
      CACHE_DIR = os.path.expanduser("~/.cache/wallpaper-selector")
      CURRENT_WP_FILE = os.path.expanduser("~/.cache/matugen/current-wallpaper")
      WAYBAR_COLORS = os.path.expanduser("~/.cache/matugen/colors-waybar.css")
      THUMB_W, THUMB_H = 280, 160
      EXTENSIONS = ('.jpg', '.jpeg', '.png', '.webp')

      def read_theme_colors():
          """Lee accent y secondary del cache de waybar."""
          accent = "${c.oro}"
          secondary = "${c.ambar}"
          try:
              with open(WAYBAR_COLORS) as f:
                  content = f.read()
              m = re.search(r'@define-color wb_oro\s+(#[0-9a-fA-F]{6})', content)
              if m:
                  accent = m.group(1)
              m = re.search(r'@define-color wb_ambar\s+(#[0-9a-fA-F]{6})', content)
              if m:
                  secondary = m.group(1)
          except FileNotFoundError:
              pass
          return accent, secondary

      def hex_to_rgb(h):
          h = h.lstrip('#')
          return f"{int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)}"

      ACCENT, SECONDARY = read_theme_colors()

      CSS = f"""
      window, .background {{
        background-color: rgba(${c.crust_rgb}, 0.95);
        border: 1px solid rgba({hex_to_rgb(ACCENT)}, 0.15);
        border-radius: 16px;
      }}

      scrolledwindow, viewport, .selector-scroll {{
        background: transparent;
      }}

      undershoot, overshoot {{
        background: none;
      }}

      scrollbar {{
        opacity: 0;
      }}

      .thumbnail-btn {{
        padding: 4px;
        border: 2px solid ${c.surface2};
        border-radius: 12px;
        background: ${c.surface0};
        transition: all 250ms ease;
      }}

      .thumbnail-btn:hover {{
        border-color: {SECONDARY};
        background: ${c.surface1};
        outline: 2px solid rgba({hex_to_rgb(SECONDARY)}, 0.2);
        outline-offset: 1px;
      }}

      .thumbnail-btn.active {{
        border-color: {ACCENT};
        border-width: 3px;
        background: ${c.surface1};
        outline: 2px solid rgba({hex_to_rgb(ACCENT)}, 0.3);
        outline-offset: 1px;
      }}

      .thumbnail-frame {{
        border: none;
        border-radius: 8px;
        background: transparent;
      }}

      .thumbnail-frame > picture {{
        border-radius: 8px;
      }}
      """

      class WallpaperSelector(Gtk.Application):
          def __init__(self):
              super().__init__(application_id="com.serpiente.wallpaper-selector")
              self.connect("activate", self.on_activate)

          def get_current_wallpaper(self):
              try:
                  with open(CURRENT_WP_FILE) as f:
                      return f.read().strip()
              except FileNotFoundError:
                  return os.path.join(WALLPAPER_DIR, "default.jpg")

          def get_thumbnail(self, path):
              os.makedirs(CACHE_DIR, exist_ok=True)
              mtime = str(os.path.getmtime(path))
              cache_name = hashlib.md5((path + mtime).encode()).hexdigest() + ".png"
              cache_path = os.path.join(CACHE_DIR, cache_name)
              if not os.path.exists(cache_path):
                  pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                      path, THUMB_W, THUMB_H, True
                  )
                  pixbuf.savev(cache_path, "png", [], [])
              return cache_path

          def on_activate(self, app):
              css_provider = Gtk.CssProvider()
              css_provider.load_from_string(CSS)
              Gtk.StyleContext.add_provider_for_display(
                  Gdk.Display.get_default(), css_provider,
                  Gtk.STYLE_PROVIDER_PRIORITY_USER
              )

              win = Gtk.ApplicationWindow(application=app)
              win.set_title("Wallpapers")
              win.set_default_size(1800, 220)
              win.set_resizable(False)
              win.set_decorated(False)

              current_wp = self.get_current_wallpaper()

              scroll = Gtk.ScrolledWindow()
              scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
              scroll.set_kinetic_scrolling(True)
              scroll.add_css_class("selector-scroll")
              scroll.set_hexpand(True)
              scroll.set_vexpand(True)

              hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
              hbox.set_margin_top(16)
              hbox.set_margin_bottom(16)
              hbox.set_margin_start(16)
              hbox.set_margin_end(16)

              if not os.path.isdir(WALLPAPER_DIR):
                  os.makedirs(WALLPAPER_DIR, exist_ok=True)

              wallpapers = sorted(
                  [f for f in os.listdir(WALLPAPER_DIR)
                   if f.lower().endswith(EXTENSIONS)],
                  key=lambda x: (0 if x == 'default.jpg' else 1, x.lower())
              )

              for filename in wallpapers:
                  full_path = os.path.join(WALLPAPER_DIR, filename)
                  thumb_path = self.get_thumbnail(full_path)

                  texture = Gdk.Texture.new_from_filename(thumb_path)
                  picture = Gtk.Picture.new_for_paintable(texture)
                  picture.set_content_fit(Gtk.ContentFit.COVER)
                  picture.set_size_request(THUMB_W, THUMB_H)

                  frame = Gtk.Frame()
                  frame.set_child(picture)
                  frame.set_size_request(THUMB_W, THUMB_H)
                  frame.add_css_class("thumbnail-frame")

                  btn = Gtk.Button()
                  btn.set_child(frame)
                  btn.add_css_class("thumbnail-btn")
                  btn.set_size_request(THUMB_W + 16, THUMB_H + 16)

                  if os.path.abspath(full_path) == os.path.abspath(current_wp):
                      btn.add_css_class("active")

                  btn.connect("clicked", self.on_wallpaper_clicked, full_path, win)
                  hbox.append(btn)

              scroll.set_child(hbox)
              win.set_child(scroll)

              # Traducir scroll vertical a horizontal
              scroll_controller = Gtk.EventControllerScroll.new(
                  Gtk.EventControllerScrollFlags.VERTICAL
              )
              scroll_controller.connect("scroll", self.on_scroll, scroll)
              win.add_controller(scroll_controller)

              # Cerrar con Escape
              key_controller = Gtk.EventControllerKey.new()
              key_controller.connect("key-pressed", self.on_key_pressed, win)
              win.add_controller(key_controller)

              win.present()

          def on_key_pressed(self, controller, keyval, keycode, state, win):
              if keyval == Gdk.KEY_Escape:
                  win.close()
                  return True
              return False

          def on_scroll(self, controller, dx, dy, scroll_widget):
              adj = scroll_widget.get_hadjustment()
              adj.set_value(adj.get_value() + dy * 60)
              return True

          def on_wallpaper_clicked(self, btn, path, win):
              win.close()

              if os.path.basename(path) == "default.jpg":
                  subprocess.run(["default-theme", path])
              else:
                  subprocess.run(["apply-theme", path])

      app = WallpaperSelector()
      app.run([])
    '';
  };

  wallpaperSelector = pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper-selector";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.wrapGAppsHook4 pkgs.gobject-introspection ];
    buildInputs = [ pkgs.gtk4 pkgs.gdk-pixbuf pythonEnv ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/wallpaper-selector <<WRAPPER
      #!/bin/sh
      exec ${pythonEnv}/bin/python3 ${selectorScript} "\$@"
      WRAPPER
      chmod +x $out/bin/wallpaper-selector
    '';
  };

in
{
  home.packages = [ wallpaperSelector ];
}
