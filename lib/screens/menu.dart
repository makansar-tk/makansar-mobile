import 'package:flutter/material.dart';
import 'package:makansar_mobile/screens/kategori/list_arabicfood.dart';
import 'package:makansar_mobile/screens/kategori/list_beverages.dart';
import 'package:makansar_mobile/screens/kategori/list_chinesefood.dart';
import 'package:makansar_mobile/screens/kategori/list_daging.dart';
import 'package:makansar_mobile/screens/kategori/list_dessert.dart';
import 'package:makansar_mobile/screens/kategori/list_ayam.dart';
import 'package:makansar_mobile/screens/kategori/list_makananberkuah.dart';
import 'package:makansar_mobile/screens/kategori/list_martabak.dart';
import 'package:makansar_mobile/screens/kategori/list_nasi.dart';
import 'package:makansar_mobile/screens/kategori/list_seafood.dart';
import 'package:makansar_mobile/screens/login.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2.0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Login Here',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tahoma',
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF5F3EE), // Background yang lembut
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome to MAKANSAR!',
                style: TextStyle(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AyamEntryPage()),);
                  }),
                  _buildCategoryCard('Daging', Icons.restaurant, Colors.red, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DagingEntryPage()));
                  }),
                  _buildCategoryCard('Chinese Food', Icons.ramen_dining, Colors.amber, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChineseFoodEntryPage()));
                  }),
                  _buildCategoryCard('Arabic Food', Icons.local_dining, Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ArabicFoodEntryPage()));
                  }),
                  _buildCategoryCard('Dessert', Icons.icecream, Colors.pink, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DessertEntryPage()));
                  }),
                  _buildCategoryCard('Makanan Berkuah', Icons.soup_kitchen, Colors.teal, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MakananBerkuahEntryPage()));
                  }),
                  _buildCategoryCard('Nasi', Icons.rice_bowl, Colors.brown, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NasiEntryPage()));
                  }),
                  _buildCategoryCard('Seafood', Icons.anchor, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SeaFoodEntryPage()));
                  }),
                  _buildCategoryCard('Martabak', Icons.local_pizza, Colors.deepOrange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MartabakEntryPage()));
                  }),
                  _buildCategoryCard('Beverages', Icons.local_cafe, Colors.purple, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BeveragesEntryPage()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, Color color, VoidCallback onTap) {
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
