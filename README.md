# Museum (Flutter + Node.js API)

Aplicacion de museo virtual en Flutter con dos modos principales:

- Recorrido 360 como pantalla inicial.
- Galeria secundaria de salas y obras cargadas desde API o repositorio demo.

## Flujo actual

1. La app abre en `VirtualTourScreen`.
2. El usuario navega entre panoramicas con:
   - Hotspots turquesa para cambiar de espacio.
   - Hotspots naranjas para abrir fichas de obra.
   - Barra inferior con `←`, `→` y `X`.
3. El menu superior izquierdo abre:
   - Galeria de obras.
   - Configuracion rapida.
   - Informacion del museo.
   - Reinicio del recorrido o cierre de la app.

## Estructura principal

- `lib/app/museum_app.dart`
  - Punto de entrada visual. Arranca en el tour 360.
- `lib/features/virtual_tour/virtual_tour_screen.dart`
  - Orquesta escena activa, drawer, modal de obra y navegacion secuencial.
- `lib/features/virtual_tour/widgets/tour_panorama_viewer.dart`
  - Visor 360 reutilizable con hotspots.
- `lib/features/virtual_tour/widgets/tour_navigation_bar.dart`
  - Barra inferior con controles del recorrido.
- `lib/features/virtual_tour/widgets/tour_menu_drawer.dart`
  - Menu lateral con accesos y configuracion.
- `lib/features/virtual_tour/widgets/tour_artwork_dialog.dart`
  - Overlay/modal con ficha detallada de obra.
- `lib/data/virtual_tour_demo.dart`
  - Datos demo del recorrido: salas, hotspots y fichas.
- `lib/features/home/home_screen.dart`
  - Galeria secundaria de salas.

## Levantar la API

```bash
cd api
npm install
npm run dev
```

La API queda por defecto en `http://localhost:4000`.

## Correr Flutter

```bash
flutter pub get
flutter run --dart-define=MUSEUM_API_BASE_URL=http://localhost:4000
```

En Android emulator normalmente conviene:

```bash
flutter run --dart-define=MUSEUM_API_BASE_URL=http://10.0.2.2:4000
```

## Como agregar un nuevo espacio 360

Edita `lib/data/virtual_tour_demo.dart` y agrega un nuevo `VirtualTourScene` dentro de `demoVirtualTourScenes`.

Ejemplo:

```dart
VirtualTourScene(
  id: 'sala-nueva',
  title: 'Sala nueva',
  caption: 'Descripcion corta del espacio.',
  assetPath: 'assets/panoramas/sala_nueva.jpg',
  initialLongitude: 24,
  initialLatitude: 8,
  hotspots: <VirtualTourHotspot>[
    VirtualTourHotspot.navigation(
      id: 'sala_nueva_a_mirador',
      label: 'Ir al mirador',
      targetSceneId: 'mirador',
      longitude: 80,
      latitude: -6,
      tint: Color(0xFF2A9D8F),
    ),
  ],
),
```

Luego agrega la imagen en `assets/panoramas/` y asegurate de que `pubspec.yaml` siga incluyendo esa carpeta.

## Como agregar un hotspot de navegacion

Usa `VirtualTourHotspot.navigation(...)` dentro de la escena:

```dart
VirtualTourHotspot.navigation(
  id: 'galeria_a_pasillo',
  label: 'Pasillo lateral',
  targetSceneId: 'pasillo',
  longitude: 110,
  latitude: -10,
  tint: Color(0xFF2A9D8F),
),
```

- `targetSceneId` debe coincidir con el `id` de otra escena.
- `longitude` y `latitude` definen la posicion del punto en la esfera.

## Como agregar un hotspot de informacion

Usa `VirtualTourHotspot.info(...)` con una ficha `VirtualTourArtwork`.

```dart
VirtualTourHotspot.info(
  id: 'pieza_central',
  label: 'Obra central',
  longitude: 12,
  latitude: 9,
  tint: Color(0xFFF4A261),
  artwork: VirtualTourArtwork(
    id: 'obra-central',
    title: 'Obra central',
    subtitle: 'Ficha de sala',
    description: 'Descripcion principal de la pieza.',
    author: 'Autor o coleccion',
    dateLabel: '1904',
    locationLabel: 'Galeria central',
    context: 'Contexto extendido para el overlay.',
    imagePath: 'assets/panoramas/galeria.jpg',
  ),
),
```

Notas:

- `imagePath` acepta asset local o URL remota si empieza con `http`.
- Los hotspots naranjas abren `TourArtworkDialog`.

## Datos de la galeria

La galeria sigue leyendo `MuseumRoom` desde:

- API real con `MuseumApiService`.
- Demo local con `DemoMuseumRepository`.

La estructura esperada por Flutter para `rooms` sigue siendo:

```json
{
  "rooms": [
    {
      "id": "sala-origen",
      "title": "Sala Origen",
      "subtitle": "Rituales, territorio y memoria",
      "accent": "#2D6A4F",
      "coverUrl": "https://...",
      "exhibits": [
        {
          "id": "origen-1",
          "title": "Vasija ceremonial",
          "subtitle": "Siglo XII",
          "description": "Texto corto",
          "accent": "#2D6A4F",
          "mediaType": "image",
          "mediaUrl": "https://...",
          "thumbnailUrl": "https://..."
        }
      ]
    }
  ]
}
```

## Verificacion

```bash
flutter analyze
flutter test
```
