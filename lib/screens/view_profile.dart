import 'package:flutter/material.dart';
import 'package:makansar_mobile/models/data_profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  late Future<ProductEntry> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  Future<ProductEntry> fetchProfile() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/profile/json/');

    if (response.containsKey('username')) {
      return ProductEntry.fromJson(response);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: FutureBuilder<ProductEntry>(
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
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final ProductEntry profile;

  ProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Username: ${profile.username}'),
        Text('Nama: ${profile.nama}'),
        Text('No Telp: ${profile.noTelp}'),
        Text('Tanggal Lahir: ${profile.tanggalLahir.toLocal()}'.split(' ')[0]),
        Text('Buyer: ${profile.buyer}'),
        Text('Seller: ${profile.seller}'),
        Text('Profile Image: ${profile.profileImage}'),
        Text('Jenis Kelamin: ${profile.jenisKelamin}'),
        Text('Email: ${profile.email}'),
        Text('Alamat: ${profile.alamat}'),
      ],
    );
  }
}
