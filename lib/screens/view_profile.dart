import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/data_profile.dart';
import 'package:makansar_mobile/screens/menu.dart';
import 'package:makansar_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makansar_mobile/screens/edit_profile.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  late Future<ProfileEntry> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  Future<ProfileEntry> fetchProfile() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://10.0.2.2:8000/profile/json/');

    if (response.containsKey('username')) {
      return ProfileEntry.fromJson(response);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> deleteAccount() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.postJson('http://10.0.2.2:8000/delete-account/', {});

    if (response['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context);
              deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<ProfileEntry>(
              future: futureProfile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ProfileView(profile: snapshot.data!);
                } else {
                  return const Text('No data');
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              child: const Text('Edit Profile'),
            ),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final ProfileEntry profile;

  ProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Profile Image: ${profile.profileImage}'),
        Text('Nama: ${profile.nama}'),
        Text('No Telp: ${profile.noTelp}'),
        Text('Jenis Kelamin: ${profile.jenisKelamin}'),
        Text('Email: ${profile.email}'),
        Text('Alamat: ${profile.alamat}'),
      ],
    );
  }
}
