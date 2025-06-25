class BankSampah {
  final String id;
  final String name;

  BankSampah({required this.id, required this.name});

  factory BankSampah.fromJson(Map<String, dynamic> json) {
    return BankSampah(
      id: json['id_bank_sampah'],
      name: json['nama_bank_sampah'],
    );
  }
}