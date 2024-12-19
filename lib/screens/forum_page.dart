import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:makansar_mobile/models/forum_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  final int makananId;

  const ForumPage({super.key, required this.makananId});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _message = "";

  Future<List<ForumEntry>> fetchForums(CookieRequest request) async {
  try {
    final response = await request.get(
        'http://localhost:8000/forum/discussions-flutter/${widget.makananId}/');
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch forums');
    }
    
    return forumEntryFromJson(response.body);
  } catch (e) {
    print("Error fetching forums: $e");
    return [];
  }
}


 Future<void> _addForum(CookieRequest request) async {
  if (_formKey.currentState!.validate()) {
    try {
      final response = await request.postJson(
        'http://localhost:8000/forum/add-discussion-flutter/${widget.makananId}/',
        {"title": _title, "message": _message},
      );

      if (response['status'] == "success") {
        setState(() {});
      } else {
        print("Error: ${response['message']}");
      }
    } catch (e) {
      print("Error posting discussion: $e");
    }
  }
}



  void _showAddForumDialog(CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Diskusi"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Judul Diskusi",
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Pesan Diskusi",
                  labelText: "Pesan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Pesan tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _addForum(request);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum Diskusi"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ForumEntry>>(
        future: fetchForums(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat data. Periksa koneksi Anda.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada diskusi. Tambahkan diskusi pertama Anda!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          final forums = snapshot.data!;
          return ListView.builder(
            itemCount: forums.length,
            itemBuilder: (context, index) {
              final forum = forums[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forum.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        forum.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Divider(height: 20, color: Colors.grey),
                      if (forum.replies.isNotEmpty)
                        const Text(
                          "Balasan:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: forum.replies.length,
                        itemBuilder: (context, replyIndex) {
                          final reply = forum.replies[replyIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "- ${reply.message}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddForumDialog(request);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
