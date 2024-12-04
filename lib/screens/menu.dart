import 'package:flutter/material.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

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
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2.0,
      ),
      drawer: const LeftDrawer(),
      body: Container(
        color: const Color(0xFFF7F7F9), // Background yang lembut
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
                  _buildCategoryCard('Ayam', Icons.fastfood, Colors.orange),
                  _buildCategoryCard('Daging', Icons.restaurant, Colors.red),
                  _buildCategoryCard('Chinese Food', Icons.ramen_dining, Colors.amber),
                  _buildCategoryCard('Arabic Food', Icons.local_dining, Colors.green),
                  _buildCategoryCard('Dessert', Icons.icecream, Colors.pink),
                  _buildCategoryCard('Makanan Berkuah', Icons.soup_kitchen, Colors.teal),
                  _buildCategoryCard('Nasi', Icons.rice_bowl, Colors.brown),
                  _buildCategoryCard('Seafood', Icons.anchor, Colors.blue),
                  _buildCategoryCard('Martabak', Icons.local_pizza, Colors.deepOrange),
                  _buildCategoryCard('Beverages', Icons.local_cafe, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, Color color) {
    return Container(
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
    );
  }
}