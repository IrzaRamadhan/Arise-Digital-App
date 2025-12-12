class AssetLifecycleModel {
  final AssetDetail asset;
  final List<AssetHistory> history;

  AssetLifecycleModel({required this.asset, required this.history});

  factory AssetLifecycleModel.fromJson(Map<String, dynamic> json) {
    return AssetLifecycleModel(
      asset: AssetDetail.fromJson(json['asset']),
      history:
          (json['history'] as List)
              .map((e) => AssetHistory.fromJson(e))
              .toList(),
    );
  }
}

class AssetDetail {
  final int id;
  final String namaAsset;
  final String? kodeBmd;
  final String? nomorSeri;
  final String kategori;
  final String status;

  AssetDetail({
    required this.id,
    required this.namaAsset,
    this.kodeBmd,
    this.nomorSeri,
    required this.kategori,
    required this.status,
  });

  factory AssetDetail.fromJson(Map<String, dynamic> json) {
    return AssetDetail(
      id: json['id'],
      namaAsset: json['nama_asset'],
      kodeBmd: json['kode_bmd'],
      nomorSeri: json['nomor_seri'],
      kategori: json['kategori'],
      status: json['status'],
    );
  }
}

class AssetHistory {
  final String action;
  final String description;
  final String createdAt;
  final AssetUser? user;
  final String? oldStatus;
  final String? newStatus;
  final AssetHistoryMetadata? metadata;

  AssetHistory({
    required this.action,
    required this.description,
    required this.createdAt,
    this.user,
    this.oldStatus,
    this.newStatus,
    this.metadata,
  });

  factory AssetHistory.fromJson(Map<String, dynamic> json) {
    return AssetHistory(
      action: json['action'],
      description: json['description'],
      createdAt: json['created_at'],
      user: json['user'] != null ? AssetUser.fromJson(json['user']) : null,
      oldStatus: json['old_status'],
      newStatus: json['new_status'],
      metadata:
          json['metadata'] != null
              ? AssetHistoryMetadata.fromJson(json['metadata'])
              : null,
    );
  }
}

extension AssetHistoryLabel on AssetHistory {
  String actionLabel() {
    switch (action) {
      case "asset_created":
        return "Asset Dibuat";
      case "asset_detail_created":
        return "Asset Dibuat";
      case "disposal_proposed":
        return "Pengajuan Pembuangan";
      default:
        return action;
    }
  }
}

class AssetUser {
  final int id;
  final String name;
  final String username;
  final String email;

  AssetUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory AssetUser.fromJson(Map<String, dynamic> json) {
    return AssetUser(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}

// ========================= METADATA =========================

class AssetHistoryMetadata {
  final String? subKategori;
  final String? vendor;
  final String? nilaiPerolehan;
  final String? tanggalPerolehan;

  AssetHistoryMetadata({
    this.subKategori,
    this.vendor,
    this.nilaiPerolehan,
    this.tanggalPerolehan,
  });

  factory AssetHistoryMetadata.fromJson(Map<String, dynamic> json) {
    return AssetHistoryMetadata(
      subKategori: json['sub_kategori'],
      vendor: json['vendor'],
      nilaiPerolehan: json['nilai_perolehan'],
      tanggalPerolehan: json['tanggal_perolehan'],
    );
  }
}
