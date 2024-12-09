import 'package:flutter/material.dart';
import 'package:makansar_mobile/screens/kategori/list_makananberkuah.dart';
import 'package:makansar_mobile/screens/menu.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:makansar_mobile/screens/kategori/list_arabicfood.dart';
import 'package:makansar_mobile/screens/kategori/list_chinesefood.dart';
import 'package:makansar_mobile/screens/kategori/list_daging.dart';
import 'package:makansar_mobile/screens/kategori/list_dessert.dart';
import 'package:makansar_mobile/screens/kategori/list_ayam.dart';

class BuyerPage extends StatefulWidget {
  @override
  _BuyerPageState createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _logout() async {
    final request = context.read<CookieRequest>();
    final response = await request.logout("http://10.0.2.2:8000/auth/logout/");
    String message = response["message"];
    if (context.mounted) {
      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message Safe travel."),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAKANSAR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Container(
        color: const Color(0xFFF5F3EE), // Background yang lembut
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome $_username!',
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4, // Jumlah kolom
                childAspectRatio: 3 / 4, // Rasio aspek tombol
                crossAxisSpacing: 12.0, // Jarak antar kolom
                mainAxisSpacing: 12.0, // Jarak antar baris
                children: [
                  _buildCategoryCard('Ayam', Icons.fastfood, Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AyamEntryPage()),
                    );
                  }),
                  _buildCategoryCard('Daging', Icons.restaurant, Colors.red,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DagingEntryPage()));
                  }),
                  _buildCategoryCard(
                      'Chinese Food', Icons.ramen_dining, Colors.amber, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChineseFoodPage()));
                  }),
                  _buildCategoryCard(
                      'Arabic Food', Icons.local_dining, Colors.green, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ArabicFoodEntryPage()));
                  }),
                  _buildCategoryCard('Dessert', Icons.icecream, Colors.pink,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DessertEntryPage()));
                  }),
                  _buildCategoryCard(
                      'Makanan Berkuah', Icons.soup_kitchen, Colors.teal, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MakananBerkuahEntryPage()));
                  }),
                  _buildCategoryCard(
                      'Nasi', Icons.rice_bowl, Colors.brown, () {}),
                  _buildCategoryCard(
                      'Seafood', Icons.anchor, Colors.blue, () {}),
                  _buildCategoryCard(
                      'Martabak', Icons.local_pizza, Colors.deepOrange, () {}),
                  _buildCategoryCard(
                      'Beverages', Icons.local_cafe, Colors.purple, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(
                icon,
                size: 32.0,
                color: color,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
