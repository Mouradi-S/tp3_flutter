import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class ApiNotesPage extends StatefulWidget {
  const ApiNotesPage({super.key});

  @override
  State<ApiNotesPage> createState() => _ApiNotesPageState();
}

class _ApiNotesPageState extends State<ApiNotesPage> {
  final ApiService api = ApiService();

  List<Note> notes = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // 🔵 LOAD NOTES
  Future<void> loadNotes() async {
    try {
      final data = await api.getAllNotes();
      setState(() {
        notes = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString(); // 👈 إظهار الخطأ الحقيقي
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ LOADING
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ ERROR
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("API Notes")),
        body: Center(child: Text(error!)),
      );
    }

    // ✅ SUCCESS
    return Scaffold(
      appBar: AppBar(title: const Text("API Notes")),

      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Dismissible(
            key: Key(note.id),

            // 🔴 DELETE
            onDismissed: (direction) async {
              try {
                await api.deleteNote(note.id);
              } catch (e) {
                // نتجاهل الخطأ لأن API fake
              }

              setState(() {
                notes.removeAt(index);
              });
            },

            child: ListTile(
              title: Text(note.titre),
              subtitle: Text(note.contenu),
            ),
          );
        },
      ),

      // ➕ ADD NOTE
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = Note(
            id: DateTime.now().toString(),
            titre: "Nouvelle note",
            contenu: "Contenu...",
            couleur: "0xFFFFFFFF",
            dateCreation: DateTime.now(),
          );

          bool success = await api.createNote(newNote);

          // ✔ نضيفها محليًا
          setState(() {
            notes.insert(0, newNote);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? "Ajout réussi" : "Ajout local (API simulée)",
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
