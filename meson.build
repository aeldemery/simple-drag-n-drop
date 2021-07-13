project (
  'simple-drag-n-drop',
  ['c', 'vala'],
  version: '0.1.0',
)

sources = files (
  'sources' / 'Main.vala',
  'sources' / 'MainWindow.vala',
)

dependencies = [
  dependency ('gtk4'),
  dependency ('glib-2.0'),
  dependency ('gobject-2.0'),
]

executable (
  meson.project_name(),
  sources: sources,
  dependencies: dependencies,
  install: true,
)
