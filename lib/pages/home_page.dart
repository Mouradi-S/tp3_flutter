import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/note_service.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';
import 'api_notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen((_) {
      _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = !result.contains(ConnectivityResult.none);
    });
  }

  bool isConnected() {
    return _isConnected;
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  Future<void> _ouvrirCreation(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );

    if (note != null) {
      context.read<NoteService>().addNote(note);
    }
  }

  Future<void> _ouvrirDetail(BuildContext context, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(note: note)),
    );

    if (result == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    } else if (result is Note) {
      context.read<NoteService>().updateNote(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<NoteService>();

    final notes = query.isEmpty
        ? service.notes
        : service.search(query);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
  centerTitle: true,
  backgroundColor: const Color.fromARGB(255, 21, 194, 168),

  title: const Text("Mes Notes"),

actions: [
    // 🔗 Statut de connexion
    IconButton(
      icon: Icon(_isConnected ? Icons.wifi : Icons.wifi_off),
      onPressed: () {
        if (_isConnected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ApiNotesPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hors ligne - Mode locale uniquement")),
          );
        }
      },
    ),

    // 🔢 nombre de notes
    Consumer<NoteService>(
      builder: (_, service, __) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("${service.count}"),
          ),
        );
      },
    ),

    // ☁️ زر API
    IconButton(
      icon: const Icon(Icons.cloud),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ApiNotesPage(),
          ),
        );
      },
    ),
  ],
),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher une note...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),

          /// LIST NOTES
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text("Aucune note"))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, i) {
                      final note = notes[i];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _ouvrirDetail(context, note),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: _hexToColor(note.couleur),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.titre,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    note.contenu,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "${note.dateCreation.day}/${note.dateCreation.month}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 57, 187, 135),
        onPressed: () => _ouvrirCreation(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
