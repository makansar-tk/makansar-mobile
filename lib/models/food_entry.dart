// To parse this JSON data, do
//
//     final foodEntry = foodEntryFromJson(jsonString);

import 'dart:convert';

List<FoodEntry> foodEntryFromJson(String str) => List<FoodEntry>.from(json.decode(str).map((x) => FoodEntry.fromJson(x)));

String foodEntryToJson(List<FoodEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodEntry {
    Model model;
    int pk;
    Fields fields;

    FoodEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String category;
    String foodName;
    String location;
    String shopName;
    String price;
    String ratingDefault;
    double newRating;
    String foodDesc;
    int jumlahReview;

    Fields({
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

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        category: json["category"],
        foodName: json["food_name"],
        location: json["location"],
        shopName: json["shop_name"],
        price: json["price"].toString(),
        ratingDefault: json["rating_default"],
        newRating: json["new_rating"]?.toInt() ?? 0,
        foodDesc: json["food_desc"] ?? "",
        jumlahReview: json["jumlah_review"] ?? 0,
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

enum Model {
    MAIN_MAKANAN
}

final modelValues = EnumValues({
    "main.makanan": Model.MAIN_MAKANAN
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
