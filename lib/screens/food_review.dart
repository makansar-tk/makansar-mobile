import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/data_profile.dart';
import 'package:makansar_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makansar_mobile/screens/menu.dart';

class FoodReviewFormPage extends StatefulWidget {
  final FoodEntry food;
  const FoodReviewFormPage({super.key, required this.food}); 

  @override
  State<FoodReviewFormPage> createState() => _FoodReviewFormPageState();
}

class _FoodReviewFormPageState extends State<FoodReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _comment = ""; // comment text
  int? _rating; // rating dari 1 dan 5

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Review Makanan',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Komentar",
                    labelText: "Komentar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _comment = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Komentar tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    hintText: "Pilih Rating",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _rating,
                  items: List.generate(5, (index) => index + 1)
                      .map((rating) => DropdownMenuItem(
                            value: rating,
                            child: Text(rating.toString()),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  validator: (int? value) {
                    if (value == null) {
                      return "Rating harus dipilih!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "http://localhost:8000/review/makanan/${widget.food.pk}/create-review-flutter/",
                            jsonEncode(<String, String>{
                              // 'buyer': widget.product.username,
                              'food_item' : widget.food.pk.toString(),
                              'comment': _comment,
                              'rating': _rating.toString(),
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Review baru berhasil disimpan!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Terdapat kesalahan, silakan coba lagi."),
                            ));
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
