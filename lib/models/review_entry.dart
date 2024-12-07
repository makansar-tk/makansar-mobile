import 'dart:convert';

List<ReviewEntry> reviewEntryFromJson(String str) => List<ReviewEntry>.from(json.decode(str).map((x) => ReviewEntry.fromJson(x)));

String reviewEntryToJson(List<ReviewEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewEntry {
  int buyer;
  FoodItem foodItem;
  int rating;
  String comment;
  DateTime dateCreated;

  ReviewEntry({
    required this.buyer,
    required this.foodItem,
    required this.rating,
    required this.comment,
    required this.dateCreated,
  });

  factory ReviewEntry.fromJson(Map<String, dynamic> json) => ReviewEntry(
        buyer: json["buyer"],
        foodItem: FoodItem.fromJson(json["food_item"]),
        rating: json["rating"],
        comment: json["comment"],
        dateCreated: DateTime.parse(json["date_created"]),
      );

  Map<String, dynamic> toJson() => {
        "buyer": buyer,
        "food_item": foodItem.toJson(),
        "rating": rating,
        "comment": comment,
        "date_created": dateCreated.toIso8601String(),
      };
}

class FoodItem {
  String category;
  String foodName;
  String location;
  String shopName;
  String price;
  String ratingDefault;
  double newRating;
  String foodDesc;
  int jumlahReview;

  FoodItem({
    required this.category,
    required this.foodName,
    required this.location,
    required this.shopName,
    required this.price,
    required this.ratingDefault,
    required this.newRating,
    required this.foodDesc,
    required this.jumlahReview,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        category: json["category"],
        foodName: json["food_name"],
        location: json["location"],
        shopName: json["shop_name"],
        price: json["price"],
        ratingDefault: json["rating_default"],
        newRating: json["new_rating"]?.toDouble(),
        foodDesc: json["food_desc"],
        jumlahReview: json["jumlah_review"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "food_name": foodName,
        "location": location,
        "shop_name": shopName,
        "price": price,
        "rating_default": ratingDefault,
        "new_rating": newRating,
        "food_desc": foodDesc,
        "jumlah_review": jumlahReview,
      };
}
