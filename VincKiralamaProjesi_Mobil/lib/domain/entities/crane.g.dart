// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Crane _$CraneFromJson(Map<String, dynamic> json) => _Crane(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      capacityTon: (json['capacityTon'] as num).toDouble(),
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      city: json['city'] as String,
      categoryName: json['categoryName'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      firmId: (json['firmId'] as num).toInt(),
      firmName: json['firmName'] as String?,
    );

Map<String, dynamic> _$CraneToJson(_Crane instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'capacityTon': instance.capacityTon,
      'dailyPrice': instance.dailyPrice,
      'city': instance.city,
      'categoryName': instance.categoryName,
      'imageUrls': instance.imageUrls,
      'firmId': instance.firmId,
      'firmName': instance.firmName,
    };
