import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final SharedPreferences prefs;

  List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);
  int get count => _notes.length;

  // 🔴 CONSTRUCTOR
  NoteService(this.prefs) {
    _loadNotes(); // تحميل البيانات عند البداية
  }

  // 🟢 ADD
  void addNote(Note note) {
    _notes.insert(0, note);
    _saveNotes();
    notifyListeners();
  }

  // 🟡 UPDATE
  void updateNote(Note note) {
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      _saveNotes();
      notifyListeners();
    }
  }

  // 🔴 DELETE
  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveNotes();
    notifyListeners();
  }

  // 🔍 SEARCH
  List<Note> search(String query) {
    return _notes.where((note) {
      return note.titre.toLowerCase().contains(query.toLowerCase()) ||
          note.contenu.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // 💾 SAVE (SharedPreferences)
  Future<void> _saveNotes() async {
    final List<String> data =
        _notes.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList('notes', data);
  }

  // 📥 LOAD (SharedPreferences)
  Future<void> _loadNotes() async {
    final List<String>? data = prefs.getStringList('notes');

    if (data != null) {
      _notes = data
          .map((e) => Note.fromJson(jsonDecode(e)))
          .toList();
      notifyListeners();
    }
  }
}