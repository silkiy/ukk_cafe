import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_service.dart'; // Ganti dengan path yang sesuai

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final UserService _userService = UserService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? selectedRole; // Untuk menyimpan role yang dipilih
  final List<String> roles = [
    'admin',
    'kasir',
    'manajer',
  ];

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible:
          false, // Mencegah penutupan dialog dengan mengetuk di luar
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        title: Text(
          'Buat Pengguna Baru',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        // Menggunakan Center untuk menempatkan isi di tengah
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Agar bisa scroll jika keyboard muncul
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Agar column tidak memenuhi seluruh layar
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Text(
                  'Buat Pengguna Baru',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16.0),
                // Input Nama
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background Container
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(0.4, 0.4),
                        blurRadius: 0.2,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide.none, // Menghilangkan border default
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(
                              203, 24, 28, 1), // Warna border saat fokus
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey, // Warna border saat tidak fokus
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Warna background TextFormField
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Input Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background Container
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Warna bayangan
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Posisi bayangan
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide.none, // Menghilangkan border default
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(
                              203, 24, 28, 1), // Warna border saat fokus
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey, // Warna border saat tidak fokus
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Warna background TextFormField
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Input Password
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background Container
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(0.4, 0.4),
                        blurRadius: 0.2,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide.none, // Menghilangkan border default
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(
                              203, 24, 28, 1), // Warna border saat fokus
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey, // Warna border saat tidak fokus
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Warna background TextFormField
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Dropdown untuk Role
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background Container
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(0.4, 0.4),
                        blurRadius: 0.2,
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    hint: const Text('Pilih Role'),
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Warna background Dropdown
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Tombol Buat Pengguna
                GestureDetector(
                  onTap: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    String name = nameController.text;
                    String role = selectedRole ?? '';

                    if (email.isNotEmpty &&
                        password.isNotEmpty &&
                        name.isNotEmpty &&
                        role.isNotEmpty) {
                      _showLoadingDialog(context); // Menampilkan dialog loading
                      _userService
                          .createUser(email, password, name, role)
                          .then((_) {
                        Navigator.of(context).pop(); // Menutup dialog loading
                        // Menampilkan dialog berhasil
                        _showDialog(
                          context,
                          'Berhasil',
                          'Pengguna berhasil dibuat!',
                        );
                        // Bersihkan input setelah berhasil
                        emailController.clear();
                        passwordController.clear();
                        nameController.clear();
                        setState(() {
                          selectedRole = null; // Reset role
                        });
                      }).catchError((e) {
                        Navigator.of(context).pop(); // Menutup dialog loading
                        // Menampilkan dialog gagal
                        _showDialog(
                          context,
                          'Gagal',
                          'Gagal membuat pengguna: $e',
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua field harus diisi!'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          203, 24, 28, 1), // Warna latar belakang tombol
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Buat Pengguna',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
