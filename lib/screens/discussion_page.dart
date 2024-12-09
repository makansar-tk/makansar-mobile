import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/discussion_entry.dart';
import 'reply_page.dart';

class DiscussionPage extends StatefulWidget {
  final int makananId;
  final String foodName;

  const DiscussionPage({
    Key? key,
    required this.makananId,
    required this.foodName,
  }) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Future<List<Discussion>> fetchDiscussions(CookieRequest request) async {
    final response = await request.get(
        'http://localhost:8000/fetch-discussions/${widget.makananId}/');
    return discussionFromJson(response);
  }

  void _addDiscussion(CookieRequest request) async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Discussion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await request.post(
                  'http://localhost:8000/create-discussion/${widget.makananId}/',
                  {
                    'title': titleController.text,
                    'message': messageController.text,
                  },
                );

                if (response['status'] == 'success') {
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Discussion added!')),
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
      appBar: AppBar(title: Text('Discussions on ${widget.foodName}')),
      body: FutureBuilder<List<Discussion>>(
        future: fetchDiscussions(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('No discussions available.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No discussions available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final discussion = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(discussion.title),
                    subtitle: Text(discussion.message),
                    trailing: Text('By: ${discussion.user}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReplyPage(discussionId: discussion.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDiscussion(request),
        child: const Icon(Icons.add),
      ),
    );
  }
}
