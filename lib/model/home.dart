import 'dart:io';

class Barang {
  Barang({
    this.id,
    this.namaBarang,
    this.foto,
    this.stok,
    this.jumlahMasuk,
    this.tanggalMasuk,
    this.jumlahKeluar,
    this.tanggalKeluar,
    this.image,
    this.status,
  });

  int id;
  String namaBarang;
  String foto;
  String stok;
  String status;
  String jumlahMasuk;
  String tanggalMasuk;
  String jumlahKeluar;
  String tanggalKeluar;
  File image;

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"] == null ? null : json["id"],
        namaBarang: json["nama_barang"] == null ? null : json["nama_barang"],
        foto: json["foto"] == null ? null : json["foto"],
        stok: json["stok"] == null ? null : json["stok"],
        jumlahMasuk: json["jumlah_masuk"] == null ? null : json["jumlah_masuk"],
        tanggalMasuk: json["tanggal_masuk"] == null ? null : json["tanggal_masuk"],
        jumlahKeluar: json["jumlah_keluar"] == null ? null : json["jumlah_keluar"],
        tanggalKeluar: json["tanggal_keluar"] == null ? null : json["tanggal_keluar"],
      );

  Map<String, dynamic> toJson() => {"nama_barang": namaBarang == null ? null : namaBarang, "stok": stok == null ? null : stok, "status": status == null ? null : status};

  Map<String, dynamic> addInventori() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
  Map<String, dynamic> updatePemasukan() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
  Map<String, dynamic> updarePengeluaran() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
}
