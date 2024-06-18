import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      judul = "EDIT PRODUK";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _kodeProdukTextboxController,
            decoration: const InputDecoration(
              labelText: 'Kode Produk',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kode produk harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _namaProdukTextboxController,
            decoration: const InputDecoration(
              labelText: 'Nama Produk',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nama produk harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _hargaProdukTextboxController,
            decoration: const InputDecoration(
              labelText: 'Harga Produk',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harga produk harus diisi';
              }
              if (int.tryParse(value) == null) {
                return 'Harga produk harus berupa angka';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          _buttonSubmit(),
        ],
      ),
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (widget.produk != null) {
            ubah();
          } else {
            simpan();
          }
        }
      },
      child: Text(tombolSubmit),
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ProdukPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });

    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });

    Produk updateProduk = Produk(id: null);
    updateProduk.id = widget.produk!.id;
    updateProduk.kodeProduk = _kodeProdukTextboxController.text;
    updateProduk.namaProduk = _namaProdukTextboxController.text;
    updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ProdukPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });

    setState(() {
      _isLoading = false;
    });
  }
}
