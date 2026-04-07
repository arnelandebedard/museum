import 'package:flutter/material.dart';

class TourNavigationBar extends StatelessWidget {
  const TourNavigationBar({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
    required this.onClose,
  });

  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.62 * 255).round()),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withAlpha((0.12 * 255).round())),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha((0.28 * 255).round()),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _NavButton(
              key: const ValueKey<String>('tour_nav_back'),
              icon: Icons.arrow_back_rounded,
              tooltip: 'Espacio anterior',
              enabled: canGoBack,
              onPressed: onBack,
            ),
            const SizedBox(width: 12),
            _NavButton(
              key: const ValueKey<String>('tour_nav_forward'),
              icon: Icons.arrow_forward_rounded,
              tooltip: 'Espacio siguiente',
              enabled: canGoForward,
              onPressed: onForward,
            ),
            const SizedBox(width: 8),
            _NavButton(
              key: const ValueKey<String>('tour_nav_close'),
              icon: Icons.close_rounded,
              tooltip: 'Cerrar recorrido',
              enabled: true,
              onPressed: onClose,
              tint: const Color(0xFFE76F51),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onPressed,
    this.tint = const Color(0xFF264653),
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onPressed;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tint.withAlpha((0.88 * 255).round()),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: enabled ? onPressed : null,
          icon: Icon(
            icon,
            color: enabled
                ? Colors.white
                : Colors.white.withAlpha((0.42 * 255).round()),
          ),
        ),
      ),
    );
  }
}
