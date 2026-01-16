// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crane.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Crane {
  int get id;
  String get title;
  String get description;
  double get capacityTon;
  double get dailyPrice;
  String get city;
  String get categoryName;
  List<String> get imageUrls;
  int get firmId;
  String? get firmName;

  /// Create a copy of Crane
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CraneCopyWith<Crane> get copyWith =>
      _$CraneCopyWithImpl<Crane>(this as Crane, _$identity);

  /// Serializes this Crane to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Crane &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.capacityTon, capacityTon) ||
                other.capacityTon == capacityTon) &&
            (identical(other.dailyPrice, dailyPrice) ||
                other.dailyPrice == dailyPrice) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            (identical(other.firmId, firmId) || other.firmId == firmId) &&
            (identical(other.firmName, firmName) ||
                other.firmName == firmName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      capacityTon,
      dailyPrice,
      city,
      categoryName,
      const DeepCollectionEquality().hash(imageUrls),
      firmId,
      firmName);

  @override
  String toString() {
    return 'Crane(id: $id, title: $title, description: $description, capacityTon: $capacityTon, dailyPrice: $dailyPrice, city: $city, categoryName: $categoryName, imageUrls: $imageUrls, firmId: $firmId, firmName: $firmName)';
  }
}

/// @nodoc
abstract mixin class $CraneCopyWith<$Res> {
  factory $CraneCopyWith(Crane value, $Res Function(Crane) _then) =
      _$CraneCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      double capacityTon,
      double dailyPrice,
      String city,
      String categoryName,
      List<String> imageUrls,
      int firmId,
      String? firmName});
}

/// @nodoc
class _$CraneCopyWithImpl<$Res> implements $CraneCopyWith<$Res> {
  _$CraneCopyWithImpl(this._self, this._then);

  final Crane _self;
  final $Res Function(Crane) _then;

  /// Create a copy of Crane
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? capacityTon = null,
    Object? dailyPrice = null,
    Object? city = null,
    Object? categoryName = null,
    Object? imageUrls = null,
    Object? firmId = null,
    Object? firmName = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      capacityTon: null == capacityTon
          ? _self.capacityTon
          : capacityTon // ignore: cast_nullable_to_non_nullable
              as double,
      dailyPrice: null == dailyPrice
          ? _self.dailyPrice
          : dailyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firmId: null == firmId
          ? _self.firmId
          : firmId // ignore: cast_nullable_to_non_nullable
              as int,
      firmName: freezed == firmName
          ? _self.firmName
          : firmName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Crane].
extension CranePatterns on Crane {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Crane value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Crane() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Crane value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Crane():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Crane value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Crane() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String title,
            String description,
            double capacityTon,
            double dailyPrice,
            String city,
            String categoryName,
            List<String> imageUrls,
            int firmId,
            String? firmName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Crane() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.capacityTon,
            _that.dailyPrice,
            _that.city,
            _that.categoryName,
            _that.imageUrls,
            _that.firmId,
            _that.firmName);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String title,
            String description,
            double capacityTon,
            double dailyPrice,
            String city,
            String categoryName,
            List<String> imageUrls,
            int firmId,
            String? firmName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Crane():
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.capacityTon,
            _that.dailyPrice,
            _that.city,
            _that.categoryName,
            _that.imageUrls,
            _that.firmId,
            _that.firmName);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String title,
            String description,
            double capacityTon,
            double dailyPrice,
            String city,
            String categoryName,
            List<String> imageUrls,
            int firmId,
            String? firmName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Crane() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.capacityTon,
            _that.dailyPrice,
            _that.city,
            _that.categoryName,
            _that.imageUrls,
            _that.firmId,
            _that.firmName);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Crane implements Crane {
  const _Crane(
      {required this.id,
      required this.title,
      required this.description,
      required this.capacityTon,
      required this.dailyPrice,
      required this.city,
      required this.categoryName,
      final List<String> imageUrls = const [],
      required this.firmId,
      this.firmName})
      : _imageUrls = imageUrls;
  factory _Crane.fromJson(Map<String, dynamic> json) => _$CraneFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double capacityTon;
  @override
  final double dailyPrice;
  @override
  final String city;
  @override
  final String categoryName;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final int firmId;
  @override
  final String? firmName;

  /// Create a copy of Crane
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CraneCopyWith<_Crane> get copyWith =>
      __$CraneCopyWithImpl<_Crane>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CraneToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Crane &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.capacityTon, capacityTon) ||
                other.capacityTon == capacityTon) &&
            (identical(other.dailyPrice, dailyPrice) ||
                other.dailyPrice == dailyPrice) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.firmId, firmId) || other.firmId == firmId) &&
            (identical(other.firmName, firmName) ||
                other.firmName == firmName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      capacityTon,
      dailyPrice,
      city,
      categoryName,
      const DeepCollectionEquality().hash(_imageUrls),
      firmId,
      firmName);

  @override
  String toString() {
    return 'Crane(id: $id, title: $title, description: $description, capacityTon: $capacityTon, dailyPrice: $dailyPrice, city: $city, categoryName: $categoryName, imageUrls: $imageUrls, firmId: $firmId, firmName: $firmName)';
  }
}

/// @nodoc
abstract mixin class _$CraneCopyWith<$Res> implements $CraneCopyWith<$Res> {
  factory _$CraneCopyWith(_Crane value, $Res Function(_Crane) _then) =
      __$CraneCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      double capacityTon,
      double dailyPrice,
      String city,
      String categoryName,
      List<String> imageUrls,
      int firmId,
      String? firmName});
}

/// @nodoc
class __$CraneCopyWithImpl<$Res> implements _$CraneCopyWith<$Res> {
  __$CraneCopyWithImpl(this._self, this._then);

  final _Crane _self;
  final $Res Function(_Crane) _then;

  /// Create a copy of Crane
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? capacityTon = null,
    Object? dailyPrice = null,
    Object? city = null,
    Object? categoryName = null,
    Object? imageUrls = null,
    Object? firmId = null,
    Object? firmName = freezed,
  }) {
    return _then(_Crane(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      capacityTon: null == capacityTon
          ? _self.capacityTon
          : capacityTon // ignore: cast_nullable_to_non_nullable
              as double,
      dailyPrice: null == dailyPrice
          ? _self.dailyPrice
          : dailyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firmId: null == firmId
          ? _self.firmId
          : firmId // ignore: cast_nullable_to_non_nullable
              as int,
      firmName: freezed == firmName
          ? _self.firmName
          : firmName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
