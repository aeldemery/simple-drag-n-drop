public class SimpleDND.MainWindow : Gtk.ApplicationWindow {
    Gtk.Fixed fixed;
    Gtk.Image inc_icon;
    Gtk.Image dec_icon;
    Gtk.Label num_label;

    public MainWindow (Gtk.Application app) {
        Object (application: app);

        build_ui ();

        setup_controllers ();
    }

    void build_ui () {
        var header = new Gtk.HeaderBar ();
        this.set_titlebar (header);

        fixed = new Gtk.Fixed ();
        fixed.set_size_request(300, 200);

        inc_icon = new Gtk.Image.from_icon_name ("go-up-symbolic");
        inc_icon.name = "inc";
        dec_icon = new Gtk.Image.from_icon_name ("go-down-symbolic");
        dec_icon.name = "dec";

        inc_icon.set_icon_size (Gtk.IconSize.LARGE);
        dec_icon.set_icon_size (Gtk.IconSize.LARGE);

        var css_fragment = """
        label.number {
          color: white;
          background-color: #04AA6D;
          padding: 8px;
          font-family: Cascadia Code;
          font-size: 80px;
        }
        label.info {
          color: white;
          background-color: #2196F3;
          padding: 8px;
          font-family: Cascadia Code;
          font-size: 16px;
        }
        """;

        num_label = new Gtk.Label ("0");
        num_label.set_size_request (120, 20);
        num_label.add_css_class ("number");

        var provider = new Gtk.CssProvider ();
        provider.load_from_data (css_fragment.data);
        num_label.get_style_context ().add_provider (provider, 800);

        var info_label = new Gtk.Label ("Drag the arrows to the nummber and see!");
        info_label.add_css_class ("info");
        info_label.get_style_context ().add_provider (provider, 800);

        fixed.put (inc_icon, 100, 160);
        fixed.put (dec_icon, 500, 160);
        fixed.put (num_label, 250, 50);
        fixed.put (info_label, 150, 350);

        this.set_child (fixed);
    }

    void setup_controllers () {
        var drag_source = new Gtk.DragSource ();

        drag_source.prepare.connect ((source, x, y) => {
            var source_widget = source.get_widget ();
            var picked_img = source_widget.pick (x, y, Gtk.PickFlags.DEFAULT);
            if (picked_img.get_type () != typeof (Gtk.Image)) {
                return null;
            }
            source_widget.set_data<Gtk.Image> ("dragged-item", (Gtk.Image) picked_img);
            return new Gdk.ContentProvider.for_value (picked_img);
        });

        drag_source.drag_begin.connect ((source, drag) => {
            var source_widget = source.get_widget ();
            var picked_img = source_widget.get_data<Gtk.Image> ("dragged-item");
            var paintable = new Gtk.WidgetPaintable (picked_img);

            source.set_icon (paintable, picked_img.get_width (), picked_img.get_height ());
            picked_img.opacity = 0.3;
        });

        drag_source.drag_end.connect ((source, drag, delete_data) => {
            var source_widget = source.get_widget ();
            var picked_img = source_widget.get_data<Gtk.Image> ("dragged-item");

            picked_img.opacity = 1.0;
            source_widget.set_data ("dragged-item", null);
        });

        drag_source.drag_cancel.connect ((source, drag, reason) => {
            return false;
        });

        var drop_target = new Gtk.DropTarget (typeof (Gtk.Widget), Gdk.DragAction.COPY);

        drop_target.on_drop.connect ((target, value, x, y) => {
            var picked_img = (Gtk.Image) value;
            var target_label = (Gtk.Label) target.get_widget ();
            
            if (picked_img.name == "inc") {
              target_label.label = (int.parse (target_label.label) + 1).to_string ();
            } else if (picked_img.name == "dec") {
              target_label.label = (int.parse (target_label.label) - 1).to_string ();
            }
            
            return true;
        });

        num_label.add_controller (drop_target);
        fixed.add_controller (drag_source);
    }
}
