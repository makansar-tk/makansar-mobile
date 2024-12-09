import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makansar_mobile/models/data_profile.dart';
import 'package:makansar_mobile/screens/view_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late Future<ProfileEntry> futureProfile;
  late TextEditingController _namaController;
  late TextEditingController _noTelpController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  File? _image;
  String? _jenisKelamin;
  bool? _isMale;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
    _namaController = TextEditingController();
    _noTelpController = TextEditingController();
    _isMale = true;
    _jenisKelamin = "Laki-Laki";
    _emailController = TextEditingController();
    _alamatController = TextEditingController();

    futureProfile.then((profile) {
      setState(() {
        _imageURL = profile.profileImage ?? '';
        _namaController.text = profile.nama;
        _noTelpController.text = profile.noTelp;
        _jenisKelamin = profile.jenisKelamin;
        _emailController.text = profile.email ?? '';
        _alamatController.text = profile.alamat ?? '';
      });
    });
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> saveProfile() async {
    final request = context.read<CookieRequest>();

    final body = {
      'nama': _namaController.text,
      'no_telp': _noTelpController.text,
      'jenis_kelamin': _jenisKelamin,
      'email': _emailController.text,
      'alamat': _alamatController.text,
    };

    // If an image is picked, upload it
    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);
      body['profile_image'] = base64Image;
    }

    final response = await request.postJson(
        'http://10.0.2.2:8000/profile/edit-profile/', jsonEncode(body));

    if (response['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewProfilePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ViewProfilePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<ProfileEntry>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      'Foto Profil:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Upload'),
                    ),
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 150,
                      ),
                    TextFormField(
                      controller: _namaController,
                      decoration:
                          const InputDecoration(labelText: 'Nama Lengkap:'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _noTelpController,
                      decoration: const InputDecoration(labelText: 'Nomor HP:'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Jenis Kelamin:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Laki-Laki'),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: _isMale,
                            onChanged: (bool? value) {
                              setState(() {
                                _isMale = value;
                                _jenisKelamin = "Laki-Laki";
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Perempuan'),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: _isMale,
                            onChanged: (bool? value) {
                              setState(() {
                                _isMale = value;
                                _jenisKelamin = "Perempuan";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email:'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(labelText: 'Alamat:'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveProfile();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
