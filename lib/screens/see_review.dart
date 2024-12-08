import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/food_entry.dart'; // Model untuk FoodEntry
import 'package:makansar_mobile/models/review_entry.dart'; // Model untuk ReviewEntry
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class SeeReviewPage extends StatelessWidget {
  final FoodEntry food;

  const SeeReviewPage({super.key, required this.food});

  Future<List<ReviewEntry>> fetchReviews(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/reviews/json/');
    List<ReviewEntry> reviews = [];
    for (var d in response) {
      if (d['fields']['food_item'] == food.pk) { // Gunakan 'pk' untuk filter review
        reviews.add(ReviewEntry.fromJson(d));
      }
    }
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for ${food.fields.foodName}'),
      ),
      body: FutureBuilder(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load reviews.'));
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(child: Text('No reviews available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final review = snapshot.data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Rating: ${review.fields.rating}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comment: ${review.fields.comment}'),
                        Text('Buyer: ${review.fields.buyerName}'),
                        Text(
                          'Date: ${review.fields.dateCreated}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
