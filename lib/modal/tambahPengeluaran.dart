import 'package:flutter/material.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/input.dart';
import 'package:inventory/helper/route.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';

class TambahPengeluaran extends StatefulWidget {
  final String id;
  final String tipe;
  final String value;
  final String barangId;
  const TambahPengeluaran({Key key, this.id, this.tipe, this.value, this.barangId}) : super(key: key);

  @override
  _TambahPengeluaranState createState() => _TambahPengeluaranState();
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  Connection db = new Connection();

  void addOffline() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    final initDB = db.initDB();

    barang.id = int.parse(widget.id);
    barang.stok = txtJumlah.text;

    try {
      initDB.then((value) {
        db.addPengeluaran(int.parse(widget.id), barang);
      });
      setState(() {
        Config.alert(1, 'Berhasil menambah pengeluaran');
        Navigator.pop(context);

        Navigator.pushNamed(context, Routes.HOME);
      });
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal menambah pengeluaran');
      });
    }
  }

  void editOffline() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    final initDB = db.initDB();

    barang.id = int.parse(widget.id);
    barang.stok = txtJumlah.text;

    try {
      initDB.then((value) {
        db.updatePengeluaran(int.parse(widget.id), barang);
      });
      setState(() {
        Config.alert(1, 'Berhasil mengubah pengeluaran');
        Navigator.pop(context);

        Navigator.pushNamed(context, Routes.HOME);
      });
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal mengubah pengeluaran');
      });
    }
  }

  void addPemasukan() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    BarangRepository barangRepository = new BarangRepository();
    barang.id = int.parse(widget.id);
    barang.stok = txtJumlah.text;

    bool respon = await barangRepository.addPengeluaran(barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HOME);
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal menambah pengeluaran');
      });
    }
  }

  void editPengeluaran() async {
    setState(() {
      Config.loading(context);
    });
    Barang barang = new Barang();
    BarangRepository barangRepository = new BarangRepository();
    barang.id = int.parse(widget.barangId);
    barang.stok = txtJumlah.text;

    bool respon = await barangRepository.editPengeluaran(widget.id, barang);
    if (respon) {
      setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.HISTORY_BARANG_KELUAR);
      });
    } else {
      setState(() {
        Navigator.pop(context);
        Config.alert(0, 'Gagal mengubah pengeluaran');
      });
    }
  }

  TextEditingController txtJumlah = new TextEditingController();

  @override
  void initState() {
    if (widget.tipe == 'Update') {
      txtJumlah.text = widget.value;
    } else {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(color: Config.background, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [Text(widget.tipe == 'Update' ? 'Edit Pengeluaran' : 'Tambah Pengeluaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              Divider(
                height: 22,
              ),
              SizedBox(height: 8),
              Text('Jumlah Pengeluaran',
                  style: TextStyle(
                    fontSize: 14,
                  )),
              formInputType(txtJumlah, 'Jumlah Pengeluaran', TextInputType.number),
              SizedBox(height: 8),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 4, top: 8),
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                        onPressed: () {
                          if (txtJumlah.text.isEmpty) {
                            Config.alert(0, 'Jumlah harus diisi');
                          } else {
                            if (widget.tipe == 'Update') {
                              // editPengeluaran();
                              editOffline();
                            } else {
                              // addPemasukan();
                              addOffline();
                            }
                          }
                        },
                        child: Text('Simpan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Config.textWhite))),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
