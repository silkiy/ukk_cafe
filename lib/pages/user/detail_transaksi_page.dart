import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_notifier.dart';
import '../../models/cart_item.dart';
import '../../models/transaction.dart';
import '../../services/transaksi_service.dart';

class DetailTransaksiPage extends StatefulWidget {
  const DetailTransaksiPage({super.key});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartNotifier>().cartItems;

    // Cek apakah keranjang kosong
    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(243, 244, 248, 1),
        appBar: AppBar(
          title: Text('Detail Transaksi'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'Keranjang kosong!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final totalHarga = cartItems.fold(
      0,
      (total, item) => total + (item.harga * item.quantity),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        title: Text('Detail Transaksi'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(
                      item.name,
                    ),
                    subtitle: Text(
                      "Rp ${item.harga}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 1) {
                              item.quantity--;
                              context.read<CartNotifier>().updateQuantity(
                                    index,
                                    item.quantity,
                                  );
                            }
                          },
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            item.quantity.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            item.quantity++;
                            context.read<CartNotifier>().updateQuantity(
                                  index,
                                  item.quantity,
                                );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Harga:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp $totalHarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        // Ambil cartItems dari CartNotifier
                        final cartItems =
                            context.read<CartNotifier>().cartItems;

                        // Pastikan cartItems tidak kosong
                        if (cartItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Keranjang kosong!',
                              ),
                            ),
                          );
                          return;
                        }

                        // Contoh data transaksi
                        Transaksi transaksi = Transaksi(
                          idTransaksi: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(), // Convert to String
                          tglTransaksi: Timestamp.now(),
                          idUser: '', // Kosongkan atau ganti sesuai kebutuhan
                          idMeja: 'meja 1', // Ganti dengan ID meja yang sesuai
                          namaPelanggan:
                              'Pelanggan 1', // Ganti dengan nama pelanggan
                          status: 'belum bayar', // Atur status sesuai kebutuhan
                        );

                        // Tampilkan loading indicator
                        setState(() {
                          _isLoading = true;
                        });

                        // Panggil fungsi untuk menambahkan transaksi
                        await TransaksiService.tambahTransaksi(
                          context,
                          transaksi,
                          cartItems,
                        );

                        // Tutup loading indicator
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.14,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator
                                  .adaptive() // Tampilkan loading
                              : Text(
                                  "Checkout",
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// belum bisa memasukkan 
// Text(
//   "Subtotal: Rp ${item.harga * item.quantity}",
//   style: TextStyle(
//     fontSize: 14,
//   ),
// ),