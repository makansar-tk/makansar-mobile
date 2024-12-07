import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DagingEntryPage extends StatefulWidget {
  const DagingEntryPage({super.key});

  @override
  State<DagingEntryPage> createState() => _DagingEntryPageState();
}

class _DagingEntryPageState extends State<DagingEntryPage> {
  List<FoodEntry> favoriteFoods = [];

  Future<List<FoodEntry>> fetchFood(CookieRequest request, {String category = 'Daging'}) async { 
    final response = await request.get('http://localhost:8000/json/');
    
    List<FoodEntry> listDaging = [];
    for (var d in response) {
      if (d != null) {
        listDaging.add(FoodEntry.fromJson(d));
      }
    }
    return listDaging;
  }

  void _toggleFavorite(FoodEntry food) {
    setState(() {
      if (favoriteFoods.contains(food)) {
        favoriteFoods.remove(food);
      } else {
        favoriteFoods.add(food);
      }
    });
  }

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
              // Add more details from your FoodEntry model
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
        title: const Text('Kategori Daging'),
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
                            children: favoriteFoods
                                .map((food) => ListTile(
                                      title: Text(food.fields.foodName),
                                      subtitle: Text(food.fields.price as String),
                                    ))
                                .toList(),
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
      body: FutureBuilder(
        future: fetchFood(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada makanan yang tersedia.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
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
                      subtitle: Text(food.fields.price as String),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              favoriteFoods.contains(food) 
                                ? Icons.favorite 
                                : Icons.favorite_border,
                              color: favoriteFoods.contains(food) 
                                ? Colors.red 
                                : null,
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
          }
        },
      ),
    );
  }
}

