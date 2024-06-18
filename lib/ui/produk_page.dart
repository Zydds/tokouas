import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tokokita/model/produk.dart';
//import 'package:tokokita/model/login.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
//import 'package:tokokita/bloc/login_bloc.dart';


class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> futureProduk;

  @override
  void initState() {
    super.initState();
    futureProduk = fetchProduk();
  }

  Future<List<Produk>> fetchProduk() async {
    final response = await http.get(Uri.parse('http://localhost:8080/produk'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response JSON: $jsonResponse');

      if (jsonResponse is List) {
        return jsonResponse.map((data) => Produk.fromJson(data)).toList();
      } else if (jsonResponse is Map && jsonResponse.containsKey('data')) {
        final data = jsonResponse['data'];
        if (data is List) {
          return data.map((data) => Produk.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukForm()));
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage()))
          });
        },
      )
    ],
  ),
),
      body: FutureBuilder<List<Produk>>(
        future: futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No products found');
            return Center(child: Text('No products found'));
          } else {
            List<Produk> produkList = snapshot.data!;
            return ListView.builder(
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                return ItemProduk(produk: produkList[index]);
              },
            );
          }
        },
      ),
    );
  }
}


class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Produk: ${produk.namaProduk}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Harga: ${produk.hargaProduk}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


