// To parse this JSON data, do
//
//     final reviewEntry = reviewEntryFromJson(jsonString);

import 'dart:convert';

List<ReviewEntry> reviewEntryFromJson(String str) => List<ReviewEntry>.from(json.decode(str).map((x) => ReviewEntry.fromJson(x)));

String reviewEntryToJson(List<ReviewEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewEntry {
    String model;
    int pk;
    Fields fields;

    ReviewEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ReviewEntry.fromJson(Map<String, dynamic> json) => ReviewEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int buyer;
    int foodItem;
    int rating;
    String comment;
    DateTime dateCreated;

    Fields({
        required this.buyer,
        required this.foodItem,
        required this.rating,
        required this.comment,
        required this.dateCreated,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        buyer: json["buyer"],
        foodItem: json["food_item"],
        rating: json["rating"],
        comment: json["comment"],
        dateCreated: DateTime.parse(json["date_created"]),
    );

    Map<String, dynamic> toJson() => {
        "buyer": buyer,
        "food_item": foodItem,
        "rating": rating,
        "comment": comment,
        "date_created": dateCreated.toIso8601String(),
    };
}
