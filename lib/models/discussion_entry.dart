import 'dart:convert';

List<Discussion> discussionFromJson(String str) =>
    List<Discussion>.from(json.decode(str).map((x) => Discussion.fromJson(x)));

class Discussion {
  final int id;
  final String title;
  final String message;
  final String user;
  final String dateCreated;
  final List<Reply> replies;

  Discussion({
    required this.id,
    required this.title,
    required this.message,
    required this.user,
    required this.dateCreated,
    required this.replies,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      user: json['user'],
      dateCreated: json['date_created'],
      replies: (json['replies'] as List<dynamic>)
          .map((replyJson) => Reply.fromJson(replyJson))
          .toList(),
    );
  }
}

class Reply {
  final int id;
  final String message;
  final String user;
  final String dateCreated;

  Reply({
    required this.id,
    required this.message,
    required this.user,
    required this.dateCreated,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      message: json['message'],
      user: json['user'],
      dateCreated: json['date_created'],
    );
  }
}
