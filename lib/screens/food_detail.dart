import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodEntry food;

  const FoodDetailPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.fields.foodName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.fields.foodName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Description: ${food.fields.foodDesc}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${food.fields.price}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${food.fields.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating: ${food.fields.ratingDefault}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic untuk menambahkan ulasan
                  },
                  child: const Text('Add Review'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic untuk melihat semua ulasan
                  },
                  child: const Text('See All Reviews'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic untuk menambahkan ke favorit
                  },
                  child: const Text('Add Favorite'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
