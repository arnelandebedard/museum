import 'package:flutter/material.dart';

import '../../models/museum_models.dart';
import '../../services/museum_repository.dart';
import '../room/room_screen.dart';
import '../virtual_tour/virtual_tour_screen.dart';
import 'widgets/room_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  static const String routeName = '/gallery';

  final MuseumRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _controller;
  late Future<List<MuseumRoom>> _roomsFuture;
  List<MuseumRoom> _rooms = const <MuseumRoom>[];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.82);
    _controller.addListener(_onScroll);
    _roomsFuture = _loadRooms();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_rooms.isEmpty) return;

    final double? page = _controller.page;
    if (page == null) return;
    final int next = page.round().clamp(0, _rooms.length - 1);
    if (next != _index) {
      setState(() => _index = next);
    }
  }

  void _openRoom(MuseumRoom room) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => RoomScreen(room: room)));
  }

  Future<void> _returnToTour() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => VirtualTourScreen(repository: widget.repository),
      ),
    );
  }

  void _retry() {
    setState(() {
      _index = 0;
      _rooms = const <MuseumRoom>[];
      _roomsFuture = _loadRooms();
    });
  }

  Future<List<MuseumRoom>> _loadRooms() async {
    final List<MuseumRoom> rooms = await widget.repository.fetchRooms();
    _rooms = rooms;
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.sizeOf(context);
    final double sidebarWidth = (size.width * 0.30).clamp(280.0, 380.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de obras'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _returnToTour,
              icon: const Icon(Icons.panorama_photosphere_select_rounded),
              label: const Text('Volver al recorrido'),
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF6F1E7),
              Color(0xFFF0E7DB),
              Color(0xFFF7F3EC),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: FutureBuilder<List<MuseumRoom>>(
            future: _roomsFuture,
            builder: (BuildContext context, AsyncSnapshot<List<MuseumRoom>> snapshot) {
              final List<MuseumRoom> rooms = snapshot.data ?? _rooms;
              final MuseumRoom? selectedRoom = rooms.isEmpty
                  ? null
                  : rooms[_index];

              return Row(
                children: <Widget>[
                  SizedBox(
                    width: sidebarWidth,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Coleccion permanente',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Explora las salas disponibles y abre fichas de obra completas fuera del modo panoramico.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 22),
                          if (selectedRoom != null)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  (0.78 * 255).round(),
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      selectedRoom.title,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      selectedRoom.subtitle,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(
                                                  (0.72 * 255).round(),
                                                ),
                                          ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      '${selectedRoom.exhibits.length} piezas disponibles',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: selectedRoom.accent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.icon(
                                        onPressed: () =>
                                            _openRoom(selectedRoom),
                                        icon: const Icon(
                                          Icons.open_in_new_rounded,
                                        ),
                                        label: const Text('Abrir sala'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 22),
                          _Dots(current: _index, total: rooms.length),
                          const SizedBox(height: 22),
                          Text(
                            'La galeria sigue consumiendo datos de la API o del repositorio demo. El recorrido 360 se abre como pantalla inicial y esta vista queda como acceso secundario.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.72 * 255).round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (BuildContext context) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return _ErrorState(
                            message: snapshot.error.toString(),
                            onRetry: _retry,
                          );
                        }

                        if (rooms.isEmpty) {
                          return const Center(
                            child: Text('La API no devolvio salas todavia.'),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: rooms.length,
                            itemBuilder: (BuildContext context, int index) {
                              final MuseumRoom room = rooms[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 10,
                                ),
                                child: RoomCard(
                                  key: ValueKey<String>('room_card_${room.id}'),
                                  room: room,
                                  onTap: () => _openRoom(room),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final Color ink = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: List<Widget>.generate(total, (int i) {
        final bool active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.only(right: 8),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: ink.withAlpha(((active ? 0.70 : 0.16) * 255).round()),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: theme.colorScheme.onSurface.withAlpha(
                (0.54 * 255).round(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No fue posible cargar la galeria',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
