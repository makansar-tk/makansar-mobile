import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:makansar_mobile/screens/food_detail.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ChineseFoodEntryPage extends StatefulWidget {
  const ChineseFoodEntryPage({super.key});

  @override
  State<ChineseFoodEntryPage> createState() => _ChineseFoodEntryPageState();
}

class _ChineseFoodEntryPageState extends State<ChineseFoodEntryPage> {
  Future<List<FoodEntry>> fetchChineseFoodFoods(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/json/');
    List<FoodEntry> listChineseFood = [];

    for (var d in response) {
      if (d != null) {
        FoodEntry food = FoodEntry.fromJson(d);
        if (food.fields.category.toLowerCase() == "chinese food") {
          listChineseFood.add(food);
        }
      }
    }
    return listChineseFood;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Chinese Food'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<FoodEntry>>(
        future: fetchChineseFoodFoods(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada makanan kategori Chinese Food tersedia.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final food = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.fields.foodName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: Rp${food.fields.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetailPage(food: food),
                                  ),
                                );
                              },
                              child: const Text('Show Detail'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () {
                                // Logika menambahkan makanan ke favorit
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${food.fields.foodName} has been added to favorites!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
