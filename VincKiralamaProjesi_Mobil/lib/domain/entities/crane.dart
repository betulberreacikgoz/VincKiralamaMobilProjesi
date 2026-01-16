import 'package:freezed_annotation/freezed_annotation.dart';

part 'crane.freezed.dart';
part 'crane.g.dart';

@freezed
abstract class Crane with _$Crane {
  const factory Crane({
    required int id,
    required String title,
    required String description,
    required double capacityTon,
    required double dailyPrice,
    required String city,
    required String categoryName,
    @Default([]) List<String> imageUrls,
    required int firmId,
    String? firmName,
  }) = _Crane;

  factory Crane.fromJson(Map<String, dynamic> json) => _$CraneFromJson(json);
}
