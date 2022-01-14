import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/input.dart';
import 'package:inventory/helper/network.dart';
import 'package:inventory/helper/route.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';

class TambahDataBarang extends StatefulWidget {
  final Barang data;
  final String tipe;
  const TambahDataBarang({Key key, this.data, this.tipe}) : super(key: key);

  @override
  _TambahDataBarangState createState() => _TambahDataBarangState();
}

class _TambahDataBarangState extends State<TambahDataBarang> {
  TextEditingController txtNama = new TextEditingController();
  TextEditingController txtJumlah = new TextEditingController();
  TextEditingController txtKeterangan = new TextEditingController();
  TextEditingController txtHarga = new TextEditingController();
  TextEditingController txtOngkos = new TextEditingController();

  File tmpFile;

  Future<File> file;

  String fileName = '', tmpKeterangan = '';

  Future _getImage() async {
    final picker = ImagePicker();
    PickedFile pickedFile;
    final imgSrc = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar"),
        actions: <Widget>[
          MaterialButton(
            child: Text("Kamera"),
            onPressed: () async {
              Navigator.pop(context, ImageSource.camera);

              pickedFile = await picker.getImage(source: ImageSource.camera);

              setState(() {
                if (pickedFile?.path == null) {
                  fileName = '';
                } else {
                  fileName = pickedFile.path.toString();
                  tmpFile = File(pickedFile.path);
                  print(fileName);
                }
              });
            },
          ),
          MaterialButton(
              child: Text("Galeri"),
              onPressed: () async {
                Navigator.pop(context, ImageSource.gallery);
                pickedFile = await picker.getImage(source: ImageSource.gallery);
                setState(() {
                  if (pickedFile?.path == null) {
                    fileName = '';
                  } else {
                    fileName = pickedFile.path.toString();
                    tmpFile = File(pickedFile.path);
                  }
                });
              })
        ],
      ),
    );
  }

  void getData() async {
    print(widget.data.hargaBarang);
    print(widget.data.ongkosPembuatan);
    txtJumlah.text = widget.data.stok;
    txtNama.text = widget.data.namaBarang;
    txtKeterangan.text = widget.data.keterangan;
    txtHarga.text = widget.data.hargaBarang.toString();
    txtOngkos.text = widget.data.ongkosPembuatan.toString();
  }

  void addBarang() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    BarangRepository barangRepository = new BarangRepository();
    barang.namaBarang = txtNama.text;
    barang.stok = txtJumlah.text;
    barang.ongkosPembuatan = txtOngkos.text.isEmpty ? '0' : txtOngkos.text;
    barang.hargaBarang = txtHarga.text.isEmpty ? '0' : txtHarga.text;
    barang.keterangan = txtKeterangan.text.isEmpty ? '-' : txtKeterangan.text;
    barang.status = 'Tersedia';

    bool respon = await barangRepository.store(tmpFile, barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HOME);
        Config.alert(1, 'Berhasil menambah barang');
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal menambah barang');
      });
    }
  }

  void editBarang() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    tmpKeterangan = txtKeterangan.text.isEmpty ? '-' : txtKeterangan.text;
    BarangRepository barangRepository = new BarangRepository();
    barang.namaBarang = txtNama.text;
    barang.stok = txtJumlah.text;
    barang.keterangan = tmpKeterangan;
    barang.ongkosPembuatan = txtOngkos.text.isEmpty ? '0' : txtOngkos.text;
    barang.hargaBarang = txtHarga.text.isEmpty ? '0' : txtHarga.text;
    barang.status = 'Tersedia';
    barang.id = widget.data.id;

    bool respon = await barangRepository.update(tmpFile, barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HOME);
        Config.alert(1, 'Berhasil mengubah barang');
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal mengubah barang');
      });
    }
  }

  @override
  void initState() {
    if (widget.data != null) {
      getData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null ? 'Tambah Data Barang' : 'Edit Data Barang'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Nama Barang'), formInput(txtNama, 'Nama Barang')],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Jumlah Barang'), formInputType(txtJumlah, 'Jumlah Barang', TextInputType.number)],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Keterangan'), formInputType(txtKeterangan, 'Keterangan', TextInputType.text)],
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Harga Barang'), formInputType(txtHarga, 'Harga Barang', TextInputType.number)],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Ongkos Pembuatan'), formInputType(txtOngkos, 'Ongkos Pembuatan', TextInputType.number)],
                    ),
                  )),
                  Expanded(child: Container())
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (fileName.isEmpty && widget.tipe == 'tambah') ...{
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.image,
                    size: 50,
                  ),
                )
              } else if ((widget.tipe == 'edit' && fileName.isNotEmpty) || (widget.tipe == 'tambah' && fileName.isNotEmpty)) ...{
                Image.file(tmpFile)
              } else if (widget.data != null) ...{
                Image.network(EndPoint.server + widget.data.foto),
              },
              SizedBox(
                height: 30,
              ),
              Container(
                width: 200,
                child: OutlinedButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, color: Config.textBlack),
                      Text(
                        'Upload Image',
                        style: TextStyle(color: Config.textBlack),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _getImage();
                  },
                ),
              ),
              Container(
                width: 500,
                child: RaisedButton(
                  color: Colors.blue[400],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Simpan',
                        style: TextStyle(color: Config.textWhite),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (txtNama.text.isEmpty) {
                      Config.alert(0, 'Nama tidak boleh kosong');
                    } else if (txtJumlah.text.isEmpty) {
                      Config.alert(0, 'Jumlah tidak boleh kosong');
                    } else if (widget.data == null && tmpFile.path.toString().isEmpty) {
                      Config.alert(0, 'Foto tidak boleh kosong');
                    } else {
                      if (widget.data == null) {
                        addBarang();
                      } else {
                        editBarang();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
