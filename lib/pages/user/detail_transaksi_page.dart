import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_notifier.dart';
import '../../models/cart_item.dart';
import '../../models/meja.dart';
import '../../models/transaction.dart';
import '../../services/meja_service.dart';
import '../../services/transaksi_service.dart';

class DetailTransaksiPage extends StatefulWidget {
  const DetailTransaksiPage({super.key});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  final MejaService _mejaService = MejaService();
  late Future<List<Meja>> _mejaFuture;
  Meja? selectedMeja;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mejaFuture = _mejaService.getMeja();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartNotifier>().cartItems;

    // Cek apakah keranjang kosong
    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(243, 244, 248, 1),
        appBar: AppBar(
          title: Text('Checkout Page'),
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
          SizedBox(height: 10),
          Text(
            'Detail Pesanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
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
          SizedBox(height: 15),
          Text(
            'Pilih Meja',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: FutureBuilder<List<Meja>>(
              future: MejaService().getMeja(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada meja yang tersedia'),
                  );
                }

                List<Meja> mejaList = snapshot.data!;
                mejaList.sort(
                  (a, b) => a.nomorMeja.compareTo(b.nomorMeja),
                );

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 kolom
                    childAspectRatio: 1.0, // Rasio aspek simetris
                  ),
                  itemCount: mejaList.length,
                  itemBuilder: (context, index) {
                    final meja = mejaList[index];
                    Color containerColor = meja.status
                        ? Colors.green.shade300 // Tersedia
                        : Colors.red.shade300; // Tidak tersedia

                    return GestureDetector(
                      onTap: () {
                        if (meja.status) {
                          setState(() {
                            selectedMeja = meja; // Simpan meja yang dipilih
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Meja ini tidak tersedia.'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: MediaQuery.of(context).size.width * 0.15,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: selectedMeja == meja
                              ? Colors.blue // Sorot meja yang dipilih
                              : containerColor, // Gunakan warna status
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            meja.nomorMeja.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: selectedMeja == meja
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
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
                      'Total Harga',
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Meja yang di pilih',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedMeja != null
                          ? "Meja  ${selectedMeja!.nomorMeja}"
                          : 'Belum memilih meja',
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

                        if (selectedMeja == null) {
                          // Jika meja belum dipilih, tampilkan pesan kesalahan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Silakan pilih meja terlebih dahulu'),
                            ),
                          );
                          return; // Hentikan eksekusi lebih lanjut
                        }

                        // Contoh data transaksi
                        Transaksi transaksi = Transaksi(
                          idTransaksi:
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          tglTransaksi: Timestamp.now(),
                          idUser: '',
                          idMeja: selectedMeja!.idMeja,
                          namaPelanggan: 'Pelanggan 1',
                          status: 'belum bayar',
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

                        await MejaService().updateMejaStatus(
                          selectedMeja!.idMeja,
                          false,
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
                ),
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