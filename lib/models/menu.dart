class Menu {
  final String id;
  final String name;
  final String jenis;
  final String deskripsi;
  final int harga;
  final String img;

  Menu({
    required this.id,
    required this.name,
    required this.jenis,
    required this.deskripsi,
    required this.harga,
    required this.img,
  });

  // Fungsi untuk membuat instance Menu dari Firestore DocumentSnapshot
  factory Menu.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Menu(
      id: documentId,
      name: data['name'] ?? '',
      jenis: data['jenis'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      harga: data['harga'] ?? int,
      img: data['img'] ?? '',
    );
  }
}
