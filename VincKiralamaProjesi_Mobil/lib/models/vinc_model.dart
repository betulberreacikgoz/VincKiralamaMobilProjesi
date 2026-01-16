class Vinc {
  final int id;
  final String marka;
  final String model;
  final int tonaj;
  final double gunlukFiyat;

  Vinc({
    required this.id,
    required this.marka,
    required this.model,
    required this.tonaj,
    required this.gunlukFiyat,
  });

  // JSON'dan Dart objesine çeviren metod
  factory Vinc.fromJson(Map<String, dynamic> json) {
    return Vinc(
      id: json['id'],
      marka: json['marka'],
      model: json['model'],
      tonaj: json['tonaj'],
      // Sayısal değerler bazen int bazen double gelebilir, güvenli dönüşüm:
      gunlukFiyat: (json['gunlukFiyat'] as num).toDouble(),
    );
  }

  // Dart objesinden JSON'a çeviren metod (Veri gönderirken lazım olacak)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marka': marka,
      'model': model,
      'tonaj': tonaj,
      'gunlukFiyat': gunlukFiyat,
    };
  }
}