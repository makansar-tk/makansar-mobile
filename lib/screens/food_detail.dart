import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:makansar_mobile/screens/discussion_page.dart';
import 'package:makansar_mobile/screens/food_review.dart';
import 'package:makansar_mobile/screens/see_review.dart';

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
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodReviewFormPage(food: food),
                    ),
                  );
                  },
                  child: const Text('Add Review'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeeReviewPage(food: food),
                      ),
                    );
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
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscussionPage(
                        makananId: food.pk,
                        foodName: food.fields.foodName,
                      ),
                    ),
                  );
                },
                child: const Text('View Discussions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
