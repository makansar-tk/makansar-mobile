import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AyamEntryPage extends StatefulWidget {
  const AyamEntryPage({super.key});

  @override
  State<AyamEntryPage> createState() => _AyamEntryPageState();
}

class _AyamEntryPageState extends State<AyamEntryPage> {
  List<FoodEntry> favoriteFoods = [];

  /// Fetch food data from the API and filter by the "Ayam" category.
  Future<List<FoodEntry>> fetchFood(CookieRequest request) async {
    try {
      final response = await request.get('http://localhost:8000/json/');
      List<FoodEntry> listAyam = [];

      for (var d in response) {
        if (d != null) {
          FoodEntry food = FoodEntry.fromJson(d);
          if (food.fields.category.trim().toLowerCase() == "ayam") {
            listAyam.add(food);
          }
        }
      }
      debugPrint('Parsed List: ${listAyam.toString()}');
      return listAyam;
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle the favorite status of a food item.
  void _toggleFavorite(FoodEntry food) {
    setState(() {
      if (favoriteFoods.contains(food)) {
        favoriteFoods.remove(food);
      } else {
        favoriteFoods.add(food);
      }
    });
  }

  /// Show detailed information about a food item in a dialog.
  void _showFoodDetails(FoodEntry food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(food.fields.foodName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Price: ${food.fields.price}'),
              Text('Location: ${food.fields.location}'),
              Text('Shop: ${food.fields.shopName}'),
              Text('Rating: ${food.fields.ratingDefault}'),
              Text('Description: ${food.fields.foodDesc}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Confirm and delete a food item from the list.
  void _deleteFood(FoodEntry food, List<FoodEntry> foodList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Food'),
          content: Text('Are you sure you want to delete ${food.fields.foodName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  foodList.remove(food);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Ayam'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Favorite Foods'),
                    content: favoriteFoods.isEmpty
                        ? const Text('No favorite foods yet.')
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: favoriteFoods.map((food) {
                              return ListTile(
                                title: Text(food.fields.foodName),
                                subtitle: Text('Price: ${food.fields.price}'),
                              );
                            }).toList(),
                          ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<FoodEntry>>(
        future: fetchFood(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Terjadi kesalahan, coba lagi nanti.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada makanan kategori Ayam yang tersedia.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FoodEntry food = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      food.fields.foodName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Price: ${food.fields.price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            favoriteFoods.contains(food)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteFoods.contains(food) ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(food),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteFood(food, snapshot.data!),
                        ),
                      ],
                    ),
                    onTap: () => _showFoodDetails(food),
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
