// To parse this JSON data, do
//
//     final detail = detailFromJson(jsonString);

import 'dart:convert';

Detail detailFromJson(String str) => Detail.fromJson(json.decode(str));

String detailToJson(Detail data) => json.encode(data.toJson());

class Detail {
  Detail({
    this.statusCode,
    this.data,
  });

  int statusCode;
  Data data;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.detail,
    this.pemasukan,
    this.pengeluaran,
  });

  DetailClass detail;
  List<Pemasukan> pemasukan;
  List<Pengeluaran> pengeluaran;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        detail: json["detail"] == null ? null : DetailClass.fromJson(json["detail"]),
        pemasukan: json["pemasukan"] == null ? null : List<Pemasukan>.from(json["pemasukan"].map((x) => Pemasukan.fromJson(x))),
        pengeluaran: json["pengeluaran"] == null ? null : List<Pengeluaran>.from(json["pengeluaran"].map((x) => Pengeluaran.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail == null ? null : detail.toJson(),
        "pemasukan": pemasukan == null ? null : List<dynamic>.from(pemasukan.map((x) => x.toJson())),
        "pengeluaran": pengeluaran == null ? null : List<dynamic>.from(pengeluaran.map((x) => x.toJson())),
      };
}

class DetailClass {
  DetailClass({
    this.id,
    this.namaBarang,
    this.foto,
    this.stok,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String namaBarang;
  String foto;
  String stok;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory DetailClass.fromJson(Map<String, dynamic> json) => DetailClass(
        id: json["id"] == null ? null : json["id"],
        namaBarang: json["nama_barang"] == null ? null : json["nama_barang"],
        foto: json["foto"] == null ? null : json["foto"],
        stok: json["stok"] == null ? null : json["stok"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nama_barang": namaBarang == null ? null : namaBarang,
        "foto": foto == null ? null : foto,
        "stok": stok == null ? null : stok,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Pemasukan {
  Pemasukan({
    this.id,
    this.barangId,
    this.jumlah,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String barangId;
  String jumlah;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pemasukan.fromJson(Map<String, dynamic> json) => Pemasukan(
        id: json["id"] == null ? null : json["id"],
        barangId: json["barang_id"] == null ? null : json["barang_id"],
        jumlah: json["jumlah"] == null ? null : json["jumlah"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "barang_id": barangId == null ? null : barangId,
        "jumlah": jumlah == null ? null : jumlah,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Pengeluaran {
  Pengeluaran({
    this.id,
    this.barangId,
    this.jumlah,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String barangId;
  String jumlah;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pengeluaran.fromJson(Map<String, dynamic> json) => Pengeluaran(
        id: json["id"] == null ? null : json["id"],
        barangId: json["barang_id"] == null ? null : json["barang_id"],
        jumlah: json["jumlah"] == null ? null : json["jumlah"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "barang_id": barangId == null ? null : barangId,
        "jumlah": jumlah == null ? null : jumlah,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
