import 'package:http/http.dart' as http;

void deleteProduk(String kodeProduk) async {
  final response = await http.delete(Uri.parse('http://localhost:8080/produk/$kodeProduk'));

  if (response.statusCode == 200) {
    // Produk berhasil dihapus, lakukan penanganan sesuai kebutuhan aplikasi Anda
    // Misalnya, mungkin Anda ingin menampilkan pesan bahwa produk telah dihapus
    print('Produk berhasil dihapus');
  } else {
    // Terjadi kesalahan saat menghapus produk, tangani sesuai kebutuhan aplikasi Anda
    print('Gagal menghapus produk');
  }
}
