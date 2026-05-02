import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";
  // 🔵 GET
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) {
        return Note(
          id: e['id'].toString(),
          titre: e['title'] ?? '',
          contenu: e['body'] ?? '',
          couleur: "0xFFFFFFFF",
          dateCreation: DateTime.now(),
        );
      }).toList();
    } else {
      print("Eror fetching notes: ${response.statusCode}");
      print(response.body); // 👈 طباعة الجسم الكامل للرد
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  // 🟢 POST
  Future<bool> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        'Accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.5',
      },
      body: jsonEncode({'title': note.titre, 'body': note.contenu}),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // 🔴 DELETE
  Future<bool> deleteNote(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
