import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/discussion_entry.dart';

class ReplyPage extends StatefulWidget {
  final int discussionId;

  const ReplyPage({Key? key, required this.discussionId}) : super(key: key);

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  Future<List<Reply>> fetchReplies(CookieRequest request) async {
    final response = await request.get(
        'http://localhost:8000/fetch-replies/${widget.discussionId}/');
    final discussion = Discussion.fromJson(response);
    return discussion.replies;
  }

  void _addReply(CookieRequest request) async {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Reply'),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await request.post(
                  'http://localhost:8000/add-reply/${widget.discussionId}/',
                  {'message': replyController.text},
                );

                if (response['status'] == 'success') {
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply added!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Replies')),
      body: FutureBuilder<List<Reply>>(
        future: fetchReplies(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No replies available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reply = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(reply.message),
                    subtitle: Text('By: ${reply.user}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addReply(request),
        child: const Icon(Icons.add),
      ),
    );
  }
}
