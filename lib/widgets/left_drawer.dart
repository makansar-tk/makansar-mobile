import 'package:flutter/material.dart';
import 'package:makansar_mobile/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF5F3EE),
      child: ListView(
        children: [
          DrawerHeader(
            // Bagian drawer header
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'MAKANSAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Cari makanan mudah hanya di MAKANSAR!",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Bagian routing
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.black),
            title: const Text(
              'Home Page', 
              style: TextStyle(color: Colors.black, fontFamily: 'Tahoma')
            ),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}