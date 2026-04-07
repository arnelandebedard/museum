import 'package:flutter/material.dart';

class TourMenuDrawer extends StatelessWidget {
  const TourMenuDrawer({
    super.key,
    required this.gyroscopeEnabled,
    required this.showHotspotHints,
    required this.onOpenGallery,
    required this.onShowMuseumInfo,
    required this.onToggleGyroscope,
    required this.onToggleHotspotHints,
    required this.onRestartTour,
    required this.onExitApp,
  });

  final bool gyroscopeEnabled;
  final bool showHotspotHints;
  final VoidCallback onOpenGallery;
  final VoidCallback onShowMuseumInfo;
  final ValueChanged<bool> onToggleGyroscope;
  final ValueChanged<bool> onToggleHotspotHints;
  final VoidCallback onRestartTour;
  final VoidCallback onExitApp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      key: const ValueKey<String>('tour_menu_drawer'),
      backgroundColor: const Color(0xFF101820),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: <Widget>[
            Text(
              'Museo virtual',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accesos del recorrido, configuracion rapida y datos del museo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(label: 'Exploracion'),
            ListTile(
              key: const ValueKey<String>('tour_menu_gallery'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Galeria de obras',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Abrir salas y piezas fuera del visor 360.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: onOpenGallery,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Informacion del museo',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Contexto, horarios y creditos del recorrido.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: onShowMuseumInfo,
            ),
            const SizedBox(height: 18),
            _SectionTitle(label: 'Configuracion'),
            SwitchListTile.adaptive(
              key: const ValueKey<String>('tour_menu_gyro_switch'),
              contentPadding: EdgeInsets.zero,
              activeThumbColor: const Color(0xFFF4A261),
              title: const Text(
                'Usar giroscopio',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Permite orientar la vista con el dispositivo si hay sensores.',
                style: TextStyle(color: Colors.white70),
              ),
              value: gyroscopeEnabled,
              onChanged: onToggleGyroscope,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey<String>('tour_menu_hotspot_switch'),
              contentPadding: EdgeInsets.zero,
              activeThumbColor: const Color(0xFFF4A261),
              title: const Text(
                'Mostrar etiquetas de hotspots',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Deja visible la ayuda textual sobre puntos de interes.',
                style: TextStyle(color: Colors.white70),
              ),
              value: showHotspotHints,
              onChanged: onToggleHotspotHints,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.restart_alt_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Reiniciar recorrido',
                style: TextStyle(color: Colors.white),
              ),
              onTap: onRestartTour,
            ),
            const SizedBox(height: 18),
            _SectionTitle(label: 'Salida'),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE76F51),
                foregroundColor: Colors.white,
              ),
              onPressed: onExitApp,
              icon: const Icon(Icons.close_rounded),
              label: const Text('Cerrar aplicacion'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFFF4A261),
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
