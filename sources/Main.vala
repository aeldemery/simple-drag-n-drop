int main (string[] args) {
    // Create a new application
    var app = new Gtk.Application ("com.example.SimpleDND",
                                   GLib.ApplicationFlags.FLAGS_NONE);

    app.activate.connect (() => {
        // Create a new window
        var window = app.active_window;

        if (window == null) {
            window = new SimpleDND.MainWindow (app);
        }

        window.present ();
    });

    return app.run (args);
}
