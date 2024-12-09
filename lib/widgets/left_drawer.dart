import 'package:flutter/material.dart';
import 'package:makansar_mobile/screens/favorite_food.dart';
import 'package:makansar_mobile/screens/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:makansar_mobile/screens/buyer.dart';
import 'package:makansar_mobile/screens/seller.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ??
        'buyer'; // Default to 'buyer' if role is not found
  }

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
            title: const Text('Home Page',
                style: TextStyle(color: Colors.black, fontFamily: 'Tahoma')),
            // Bagian redirection ke MyHomePage
            onTap: () async {
              String role = await _getUserRole();
              if (role == 'buyer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyerPage(),
                  ),
                );
              } else if (role == 'seller') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerPage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.account_circle_outlined, color: Colors.black),
            title: const Text('Profile',
                style: TextStyle(color: Colors.black, fontFamily: 'Tahoma')),
            // Bagian redirection ke ProfilePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Favorite Foods',
                style: TextStyle(color: Colors.black, fontFamily: 'Tahoma')),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteFoodScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
