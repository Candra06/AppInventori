import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/layout/sidemenu.dart';
import 'package:inventory/model/home.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class BackupData extends StatefulWidget {
  const BackupData({Key key}) : super(key: key);

  @override
  State<BackupData> createState() => _BackupDataState();
}

class _BackupDataState extends State<BackupData> {
  String message = '';
  bool load = true;
  //import data
  void importVoca() async {
    setState(() {
      // Config.loading(context);
    });
    Connection db = new Connection();
    final initDB = db.initDB();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String path = result.files.first.path;
    final csvFile = new File(path).openRead();

    final fields = await csvFile.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    List<Map> mylist = [];
    for (var i = 0; i < fields.length; i++) {
      Map barang = {};
      barang['nama_barang'] = fields[i][0];
      barang['stok'] = fields[i][1].toString();
      barang['foto'] = fields[i][6];
      barang['ongkos_pembuatan'] = fields[i][3].toString();
      barang['harga_barang'] = fields[i][2].toString();
      barang['keterangan'] = fields[i][5];
      barang['status'] = fields[i][4];
      mylist.add(barang);
    }
    // print(mylist);
    initDB.then((value) {
      db.inputBarangMultiple(mylist);
    });

    setState(() {
      // Navigator.pop(context);
      // Navigator.pushNamed(context, Routes.HOME);
      Config.alert(1, 'Berhasil menambah barang');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Barang'),
        actions: [
          IconButton(
              onPressed: () {
                // getData();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      drawer: SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            ElevatedButton(
              onPressed: () async {
                final dbFolder = await getDatabasesPath();
                File source1 = File('$dbFolder/inventory.db');

                Directory copyTo = Directory("storage/emulated/0/Inventori/database");
                if ((await copyTo.exists())) {
                  // print("Path exist");
                  var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                } else {
                  print("not exist");
                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    await copyTo.create();
                  } else {
                    print('Please give permission');
                  }
                }

                DateTime now = DateTime.now();
                String createdAt = DateFormat('yyyyMMddkkmm').format(now).toString();
                String newPath = "${copyTo.path}/inventory$createdAt.db";
                await source1.copy(newPath);

                setState(() {
                  message = 'Successfully Copied DB';
                });
              },
              child: const Text('Copy DB'),
            ),
            ElevatedButton(
              onPressed: () async {
                var databasesPath = await getDatabasesPath();
                var dbPath = join(databasesPath, 'inventory.db');
                await deleteDatabase(dbPath);
                setState(() {
                  message = 'Successfully deleted DB';
                });
              },
              child: const Text('Delete DB'),
            ),
            ElevatedButton(
              onPressed: () async {
                var databasesPath = await getDatabasesPath();
                var dbPath = join(databasesPath, 'inventory.db');

                FilePickerResult result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  File source = File(result.files.single.path);
                  await source.copy(dbPath);
                  setState(() {
                    message = 'Successfully Restored DB';
                  });
                } else {
                  // User canceled the picker

                }
              },
              child: const Text('Restore DB'),
            ),
            ElevatedButton(
              onPressed: () async {
                importVoca();

                // _openFileExplorer();
              },
              child: const Text('Import Data'),
            ),
          ],
        ),
      ),
    );
  }
}
