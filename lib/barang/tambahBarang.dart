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

  File tmpFile;

  Future<File> file;

  String fileName = '';

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
                    print(fileName);
                  }
                });
              })
        ],
      ),
    );
  }

  void getData() async {
    txtJumlah.text = widget.data.stok;
    txtNama.text = widget.data.namaBarang;
  }

  void addBarang() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    BarangRepository barangRepository = new BarangRepository();
    barang.namaBarang = txtNama.text;
    barang.stok = txtJumlah.text;
    barang.status = 'Tersedia';

    bool respon = await barangRepository.store(tmpFile, barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HOME);
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
    BarangRepository barangRepository = new BarangRepository();
    barang.namaBarang = txtNama.text;
    barang.stok = txtJumlah.text;
    barang.status = 'Tersedia';
    barang.id = widget.data.id;

    bool respon = await barangRepository.update(tmpFile, barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HOME);
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
                  ))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (widget.data != null) ...{
                Image.network(EndPoint.server + widget.data.foto)
              } else if (fileName.isEmpty) ...{
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.image,
                    size: 50,
                  ),
                )
              } else ...{
                Image.file(tmpFile)
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
