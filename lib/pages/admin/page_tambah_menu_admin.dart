import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukk_cafe/components/admin/form_tambah_menu_admin.dart';

import '../../services/menu_service.dart';

class PageTambahMenuAdmin extends StatefulWidget {
  PageTambahMenuAdmin({super.key});

  @override
  State<PageTambahMenuAdmin> createState() => _PageTambahMenuAdminState();
}

class _PageTambahMenuAdminState extends State<PageTambahMenuAdmin> {
  final _formKey = GlobalKey<FormState>();
  final MenuService _menuService = MenuService();
  bool _isImagePicked = false;

  File? _image;
  String? fileName;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  String? _namaMenu;
  final String _idMenu = 'menu_${DateTime.now().millisecondsSinceEpoch}';
  String? _jenisMenu;
  String? _hargaMenu;
  String? _deskripsiMenu;

  Future<String> _uploadMenuImage(XFile? image) async {
    if (image == null) {
      return '';
    }

    // Nama file unik
    String fileName = 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref =
        FirebaseStorage.instance.ref().child('menu').child(fileName);

    // Mengunggah gambar
    UploadTask uploadTask = ref.putData(
      await image.readAsBytes(),
    );

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
        _isImagePicked = true;
      });
    } else {
      print('No image selected');
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        String uploadUrl = await _uploadMenuImage(
          XFile(_image!.path),
        );
        setState(() {
          _imageUrl = uploadUrl; // Simpan URL gambar yang diupload
        });
        print("Image uploaded successfully: $_imageUrl");

        // Show success dialog
        _showSuccessDialog('Image uploaded successfully');
      } catch (e) {
        print("Failed to upload image: $e");
        // Optionally show an error dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload image: $e"),
          ),
        );
      }
    }
  }

  Future<void> _submitMenu() async {
    // Log nilai variabel sebelum validasi
    print('Logging form input values:');
    print('Nama Menu: $_namaMenu');
    print('Jenis Menu: $_jenisMenu');
    print('Harga Menu: $_hargaMenu');
    print('Deskripsi Menu: $_deskripsiMenu');
    print('Image URL: $_imageUrl');
    print('ID Menu: $_idMenu');

    // Cek apakah ada nilai yang null
    if (_namaMenu == null || _namaMenu!.isEmpty) {
      print('Error: Nama Menu is null or empty');
    }
    if (_jenisMenu == null || _jenisMenu!.isEmpty) {
      print('Error: Jenis Menu is null or empty');
    }
    if (_hargaMenu == null || _hargaMenu!.isEmpty) {
      print('Error: Harga Menu is null or empty');
    }
    if (_deskripsiMenu == null || _deskripsiMenu!.isEmpty) {
      print('Error: Deskripsi Menu is null or empty');
    }
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      print('Error: Image URL is null or empty');
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Log ketika proses penambahan menu dimulai
        print('Adding menu to Firebase...');

        // Call the addMenu function
        await _menuService.addMenu(
          id: _idMenu,
          imageUrl: _imageUrl!,
          nama: _namaMenu!,
          jenis: _jenisMenu!,
          hargaMenu: _hargaMenu!,
          deskripsi: _deskripsiMenu!,
        );

        // Log keberhasilan
        print('Menu added successfully!');

        _formKey.currentState!.reset();

        // Show success dialog
        _showSuccessDialog(
          'Menu added successfully!',
          navigateToHome: true,
        );

        // Reset the form after successful submission
      } catch (e) {
        // Log error jika ada masalah saat menambahkan menu
        print('Failed to add menu: $e');

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add menu: $e'),
          ),
        );
      }
    } else {
      // Log jika form tidak valid
      print('Form is not valid!');
    }
  }

  void _showSuccessDialog(String message, {bool navigateToHome = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (navigateToHome) {
                  // Only navigate to the home page if specified
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tambah Data Menu",
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        _image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                ),
                                child: Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Icon(Icons.photo), // placeholder
                                ),
                              ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color.fromRGBO(203, 24, 28, 1),
                              ),
                              onPressed: _isImagePicked ? _uploadImage : null,
                              child: Text(
                                "Unggah Foto",
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color.fromRGBO(203, 24, 28, 1),
                              ),
                              onPressed: _pickAndUploadImage,
                              child: Text(
                                "upload/ganti Foto",
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: Color.fromRGBO(210, 210, 210, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              FormTambahMenuAdmin(
                onNamaMenuChanged: (namaMenu) {
                  _namaMenu = namaMenu;
                },
                onjenisMenuChanged: (jenisMenu) {
                  _jenisMenu = jenisMenu;
                },
                onHargaMenuChanged: (hargaMenu) {
                  _hargaMenu = hargaMenu;
                },
                onDeskripsiMenuChanged: (deskripsiMenu) {
                  _deskripsiMenu = deskripsiMenu;
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromRGBO(203, 24, 28, 1),
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: _submitMenu,
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "Tambahkan Data Menu",
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ],
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
