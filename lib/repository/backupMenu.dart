import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventory/layout/sidemenu.dart';
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

                Directory copyTo = Directory("storage/emulated/0/SqliteBackup");
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

                String newPath = "${copyTo.path}/inventory.db";
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
          ],
        ),
      ),
    );
  }
}
