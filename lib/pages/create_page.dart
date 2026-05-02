import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? note;

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titreController;
  late TextEditingController _contenuController;

  String _couleur = "#FFE082";

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.note?.titre ?? "");
    _contenuController = TextEditingController(
      text: widget.note?.contenu ?? "",
    );
    _couleur = widget.note?.couleur ?? "#FFE082";
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  void _save() {
    if (_titreController.text.trim().isEmpty) return;

    final note = widget.note == null
        ? Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            titre: _titreController.text,
            contenu: _contenuController.text,
            couleur: _couleur,
            dateCreation: DateTime.now(),
          )
        : widget.note!.copyWith(
            titre: _titreController.text,
            contenu: _contenuController.text,
            couleur: _couleur,
            dateModification: DateTime.now(),
          );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _hexToColor(_couleur),

      appBar: AppBar(
        title: Text(widget.note == null ? "Nouvelle Note" : "Modifier"),
        backgroundColor: _hexToColor(_couleur),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: InputDecoration(
                labelText: "Titre",
                hintText: "Entrer le titre",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            TextField(
              controller: _contenuController,
              decoration: InputDecoration(
                labelText: "Contenu",
                hintText: "Entrer le contenu",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  [
                    "#FFE082",
                    "#FFAB91",
                    "#A5D6A7",
                    "#90CAF9",
                    "#CE93D8",
                    "#80CBC4",
                  ].map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _couleur = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _hexToColor(color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _couleur == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: _save, child: const Text("Sauvegarder")),
          ],
        ),
      ),
    );
  }
}
