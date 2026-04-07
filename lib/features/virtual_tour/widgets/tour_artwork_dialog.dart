import 'package:flutter/material.dart';

import '../../../data/virtual_tour_demo.dart';

class TourArtworkDialog extends StatelessWidget {
  const TourArtworkDialog({super.key, required this.artwork});

  final VirtualTourArtwork artwork;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F1E7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: _ArtworkImage(imagePath: artwork.imagePath),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              artwork.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          IconButton(
                            key: const ValueKey<String>('tour_artwork_close'),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      Text(
                        artwork.subtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF7F5539),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          _MetaChip(label: 'Autor', value: artwork.author),
                          _MetaChip(label: 'Fecha', value: artwork.dateLabel),
                          _MetaChip(
                            label: 'Sala',
                            value: artwork.locationLabel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        artwork.description,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        artwork.context,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(
                            (0.74 * 255).round(),
                          ),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtworkImage extends StatelessWidget {
  const _ArtworkImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                const ColoredBox(
                  color: Color(0xFFE8DCCA),
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
      );
    }

    return Image.asset(imagePath, fit: BoxFit.cover);
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '$label: $value',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
