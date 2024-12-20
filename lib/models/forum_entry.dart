import 'dart:convert';

List<ForumEntry> forumEntryFromJson(String str) =>
    List<ForumEntry>.from(json.decode(str).map((x) => ForumEntry.fromJson(x)));

String forumEntryToJson(List<ForumEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumEntry {
  final int id;
  final String title;
  final String message;
  final String user; // Ensure this field exists in the model
  final List<Reply> replies;

  ForumEntry({
    required this.id,
    required this.title,
    required this.message,
    required this.user, // Add this field
    required this.replies,
  });

  factory ForumEntry.fromJson(Map<String, dynamic> json) => ForumEntry(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        user: json["user"], // Ensure this is parsed from JSON
        replies: List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "user": user, // Ensure this is converted to JSON
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Reply {
  final int id;
  final String user;
  final String message;

  Reply({
    required this.id,
    required this.user,
    required this.message,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        user: json["user"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "message": message,
      };
}
