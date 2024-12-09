// To parse this JSON data, do
//
//     final favoriteEntry = favoriteEntryFromJson(jsonString);

import 'dart:convert';

List<FavoriteEntry> favoriteEntryFromJson(String str) => List<FavoriteEntry>.from(json.decode(str).map((x) => FavoriteEntry.fromJson(x)));

String favoriteEntryToJson(List<FavoriteEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavoriteEntry {
    String model;
    int pk;
    Fields fields;

    FavoriteEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FavoriteEntry.fromJson(Map<String, dynamic> json) => FavoriteEntry(
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
    int user;
    int product;
    bool isTopThree;
    bool isFavorite;

    Fields({
        required this.user,
        required this.product,
        required this.isTopThree,
        required this.isFavorite,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        isTopThree: json["is_top_three"],
        isFavorite: json["is_favorite"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "is_top_three": isTopThree,
        "is_favorite": isFavorite,
    };
}
