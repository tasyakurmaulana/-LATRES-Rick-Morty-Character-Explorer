import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  // Ambil list karakter dengan filter status dan/atau nama (search)
  static Future<List<Character>> getCharacters({
    String? status,
    String? name,
  }) async {
    final Map<String, String> queryParams = {};
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      queryParams['status'] = status.toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    final uri = Uri.parse('$baseUrl/character').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? [];
        return results.map((item) => Character.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // Karakter tidak ditemukan untuk filter/pencarian ini
        return [];
      } else {
        throw Exception('Gagal memuat data karakter (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // Detail karakter
  static Future<Character> getCharacterDetail(int id) async {
    final uri = Uri.parse('$baseUrl/character/$id');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Character.fromJson(data);
      } else {
        throw Exception('Karakter tidak ditemukan (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal memuat detail karakter: $e');
    }
  }

  // Ambil list episode
  static Future<List<Episode>> getEpisodes() async {
    final uri = Uri.parse('$baseUrl/episode');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? [];
        return results.map((item) => Episode.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat daftar episode (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
