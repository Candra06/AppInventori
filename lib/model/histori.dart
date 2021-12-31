class Histori {
  Histori({
    this.namaBarang,
    this.id,
    this.barangId,
    this.jumlah,
    this.createdAt,
    this.updatedAt,
  });

  String namaBarang;
  int id;
  String barangId;
  String jumlah;
  String createdAt;
  String updatedAt;

  factory Histori.fromJson(Map<String, dynamic> json) => Histori(
        namaBarang: json["nama_barang"] == null ? null : json["nama_barang"],
        id: json["id"] == null ? null : json["id"],
        barangId: json["barang_id"] == null ? null : json["barang_id"],
        jumlah: json["jumlah"] == null ? null : json["jumlah"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "nama_barang": namaBarang == null ? null : namaBarang,
        "id": id == null ? null : id,
        "barang_id": barangId == null ? null : barangId,
        "jumlah": jumlah == null ? null : jumlah,
      };
}
