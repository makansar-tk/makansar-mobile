import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/favorite_entry.dart'; // Sesuaikan path model FavoriteEntry

class FavoriteFoodScreen extends StatefulWidget {
  const FavoriteFoodScreen({super.key});

  @override
  _FavoriteFoodScreenState createState() => _FavoriteFoodScreenState();
}

class _FavoriteFoodScreenState extends State<FavoriteFoodScreen> {
  late Future<List<FavoriteEntry>> _favoriteEntries;

  @override
  void initState() {
    super.initState();
    _favoriteEntries = fetchFavoriteEntries();
  }

  /// Fungsi untuk mengambil data dari API
  Future<List<FavoriteEntry>> fetchFavoriteEntries() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/favorite/overview/json/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return favoriteEntryFromJson(response.body);
    } else {
      throw Exception('Failed to load favorite entries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Foods'),
      ),
      body: FutureBuilder<List<FavoriteEntry>>(
        future: _favoriteEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite foods found.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      'Product ID: ${favorite.fields.product}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${favorite.fields.user}'),
                        Text(
                          'Favorite: ${favorite.fields.isFavorite ? "Yes" : "No"}',
                          style: TextStyle(
                            color: favorite.fields.isFavorite
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          'Top Three: ${favorite.fields.isTopThree ? "Yes" : "No"}',
                          style: TextStyle(
                            color: favorite.fields.isTopThree
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      favorite.fields.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorite.fields.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onTap: () {
                      // Optional: Implementasi toggle di sini jika diperlukan
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
