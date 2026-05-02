import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailPage extends StatelessWidget {
  final Note note;

  const DetailPage({super.key, required this.note});

  Future<void> _edit(BuildContext context) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => CreateNotePage(note: note)),
    );

    if (updated != null && context.mounted) {
      Navigator.pop(context, updated);
    }
  }

  void _delete(BuildContext context) {
    Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.titre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(note.titre, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(note.contenu),
          ],
        ),
      ),
    );
  }
}
