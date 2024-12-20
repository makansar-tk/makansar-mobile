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
  String _replyMessage = "";

  Future<Map<String, dynamic>> fetchForums(CookieRequest request) async {
  try {
    final response = await request.get(
        'http://127.0.0.1:8000/forum/discussions-flutter/${widget.makananId}/');

    if (response is Map) {
      final currentUser = response['current_user'];
      final forums = forumEntryFromJson(jsonEncode(response['discussions'])); // Konversi daftar diskusi
      return {
        "current_user": currentUser,
        "forums": forums,
      };
    } else {
      throw Exception('Unexpected response format');
    }
  } catch (e) {
    print("Error fetching forums: $e");
    return {"current_user": "", "forums": []};
  }
}



 Future<void> _addForum(CookieRequest request) async {
  if (_formKey.currentState!.validate()) {
    try {
      final payload = {
        "title": _title,
        "message": _message,
        "user": request.cookies['user'], // Tambahkan username
      };

      final response = await request.post(
        'http://127.0.0.1:8000/forum/add-discussion-flutter/${widget.makananId}/',
        jsonEncode(payload),
      );

      if (response['status'] == "success") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diskusi berhasil ditambahkan!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error posting discussion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error posting discussion: $e")),
      );
    }
  }
}

Future<void> _editDiscussion(CookieRequest request, int discussionId) async {
  if (_formKey.currentState!.validate()) {
    try {
      final payload = {
        "title": _title,
        "message": _message,
      };

      // Debugging payload
      print("Payload being sent: ${jsonEncode(payload)}");

      final response = await request.post(
        'http://127.0.0.1:8000/forum/update-discussion-flutter/$discussionId/',
        jsonEncode(payload),
      );

      if (response['status'] == "success") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diskusi berhasil diperbarui!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error editing discussion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error editing discussion: $e")),
      );
    }
  }
}

void _showEditDiscussionDialog(CookieRequest request, int discussionId, String currentTitle, String currentMessage) {
  setState(() {
    _title = currentTitle;
    _message = currentMessage;
  });

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit Diskusi"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: currentTitle,
              decoration: const InputDecoration(
                labelText: "Judul",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _title = value,
              validator: (value) {
                if (value == null || value.isEmpty) return "Judul tidak boleh kosong!";
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: currentMessage,
              decoration: const InputDecoration(
                labelText: "Pesan",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => _message = value,
              validator: (value) {
                if (value == null || value.isEmpty) return "Pesan tidak boleh kosong!";
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
            await _editDiscussion(request, discussionId);
            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    ),
  );
}

Future<void> _deleteDiscussion(CookieRequest request, int discussionId) async {
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/forum/delete-discussion-flutter/$discussionId/',
      jsonEncode({}), // Body kosong
    );

    if (response['status'] == "success") {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diskusi berhasil dihapus!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['message']}")),
      );
    }
  } catch (e) {
    print("Error deleting discussion: $e");
  }
}



  Future<void> _addReply(CookieRequest request, int discussionId) async {
  if (_replyMessage.isNotEmpty) {
    try {
      final payload = {
        "message": _replyMessage,
        "user": request.cookies['user'], // Tambahkan username
      };

      final response = await request.post(
        'http://127.0.0.1:8000/forum/add-reply-flutter/$discussionId/',
        jsonEncode(payload),
      );

      if (response['status'] == "success") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Balasan berhasil ditambahkan!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error posting reply: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error posting reply: $e")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pesan balasan tidak boleh kosong!")),
    );
  }
}


Future<void> _editReply(CookieRequest request, int replyId) async {
  if (_replyMessage.isNotEmpty) {
    try {
      final payload = {
        "message": _replyMessage,
      };

      print("Payload being sent: ${jsonEncode(payload)}");

      final response = await request.post(
        'http://127.0.0.1:8000/forum/update-reply-flutter/$replyId/',
        jsonEncode(payload),
      );

      if (response['status'] == "success") {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Balasan berhasil diperbarui!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error editing reply: $e");
    }
  }
}

void _showEditReplyDialog(
    CookieRequest request, int replyId, String currentMessage) {
  setState(() {
    _replyMessage = currentMessage;
  });

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit Balasan"),
      content: TextFormField(
        initialValue: currentMessage,
        decoration: const InputDecoration(
          labelText: "Pesan Balasan",
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        onChanged: (value) => _replyMessage = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _editReply(request, replyId);
            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    ),
  );
}


  Future<void> _deleteReply(CookieRequest request, int replyId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/forum/delete-reply-flutter/${replyId}/',
        {},
      );

      if (response['status'] == "success") {
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error deleting reply: $e");
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

  void _showAddReplyDialog(CookieRequest request, int discussionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Balasan"),
        content: TextFormField(
          decoration: const InputDecoration(
            hintText: "Tulis balasan Anda",
            labelText: "Balasan",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _replyMessage = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _addReply(request, discussionId);
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
    body: FutureBuilder<Map<String, dynamic>>(
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
        } else if (!snapshot.hasData || snapshot.data!['forums'].isEmpty) {
          return const Center(
            child: Text(
              'Belum ada diskusi. Tambahkan diskusi pertama Anda!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        final currentUser = snapshot.data!['current_user'];
        final forums = snapshot.data!['forums'];

        return ListView.builder(
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi pengguna dan tanggal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          forum.user,
                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        Text(
                          '20 Dec 2024, 15:07', // Ubah ke tanggal sebenarnya jika ada
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Judul dan isi diskusi
                    Text(
                      forum.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      forum.message,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(height: 20, color: Colors.grey),
                    // Tombol Edit dan Delete
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (forum.user == currentUser)
                          TextButton(
                            onPressed: () {
                              _showEditDiscussionDialog(
                                  request, forum.id, forum.title, forum.message);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            child: const Text("Edit"),
                          ),
                        if (forum.user == currentUser)
                          TextButton(
                            onPressed: () async {
                              await _deleteDiscussion(request, forum.id);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Delete"),
                          ),
                      ],
                    ),
                    // Balasan
                    if (forum.replies.isNotEmpty)
                      const Text(
                        "Replies:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: forum.replies.length,
                      itemBuilder: (context, replyIndex) {
                        final reply = forum.replies[replyIndex];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${reply.user}:",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(reply.message),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (reply.user == currentUser)
                                      TextButton(
                                        onPressed: () {
                                          _showEditReplyDialog(
                                              request, reply.id, reply.message);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                        ),
                                        child: const Text("Edit"),
                                      ),
                                    if (reply.user == currentUser)
                                      TextButton(
                                        onPressed: () async {
                                          await _deleteReply(request, reply.id);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text("Delete"),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        _showAddReplyDialog(request, forum.id);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text("Reply to this discussion"),
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
