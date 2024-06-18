class Produk {
  int? id; // Tambahkan ID produk
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    // Menggunakan int.tryParse() untuk mencoba mengonversi nilai hargaProduk menjadi integer
    int? hargaProduk;
    int? idProduk; // Tambahkan idProduk

    try {
      hargaProduk = int.tryParse(obj['harga']);
      idProduk = int.tryParse(obj['id']); // Mengonversi ID produk menjadi integer
    } catch (e) {
      // Penanganan kesalahan jika konversi gagal
      print('Error parsing hargaProduk: $e');
    }

    return Produk(
      id: idProduk, // Set nilai ID produk
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: hargaProduk, // Menggunakan nilai hasil konversi, atau null jika konversi gagal
    );
  }
}
