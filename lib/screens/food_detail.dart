import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:makansar_mobile/screens/create_review.dart';
import 'package:makansar_mobile/screens/see_review.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodEntry food;
  const FoodDetailPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.fields.foodName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.fields.foodName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Harga: ${food.fields.price}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Lokasi: ${food.fields.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Rating: ${food.fields.newRating}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Deskripsi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              food.fields.foodDesc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeeReviewPage(food: food),
                      ),
                    );
                  },
                  child: const Text('Lihat Review'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateReviewPage(food: food),
                      ),
                    );
                  },
                  child: const Text('Buat Review'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}