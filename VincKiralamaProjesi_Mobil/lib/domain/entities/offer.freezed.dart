// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {
  int get id;
  String get description;
  String get startDate;
  String get endDate;
  String get status;
  String get craneName;
  int get craneId;
  String get customerName;
  String get customerEmail;
  String? get customerPhone;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OfferCopyWith<Offer> get copyWith =>
      _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Offer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.craneName, craneName) ||
                other.craneName == craneName) &&
            (identical(other.craneId, craneId) || other.craneId == craneId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      startDate,
      endDate,
      status,
      craneName,
      craneId,
      customerName,
      customerEmail,
      customerPhone);

  @override
  String toString() {
    return 'Offer(id: $id, description: $description, startDate: $startDate, endDate: $endDate, status: $status, craneName: $craneName, craneId: $craneId, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone)';
  }
}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res> {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) =
      _$OfferCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String description,
      String startDate,
      String endDate,
      String status,
      String craneName,
      int craneId,
      String customerName,
      String customerEmail,
      String? customerPhone});
}

/// @nodoc
class _$OfferCopyWithImpl<$Res> implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? craneName = null,
    Object? craneId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? customerPhone = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      craneName: null == craneName
          ? _self.craneName
          : craneName // ignore: cast_nullable_to_non_nullable
              as String,
      craneId: null == craneId
          ? _self.craneId
          : craneId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: null == customerEmail
          ? _self.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
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
    TResult Function(_Offer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Offer() when $default != null:
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
    TResult Function(_Offer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Offer():
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
    TResult? Function(_Offer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Offer() when $default != null:
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
            String description,
            String startDate,
            String endDate,
            String status,
            String craneName,
            int craneId,
            String customerName,
            String customerEmail,
            String? customerPhone)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Offer() when $default != null:
        return $default(
            _that.id,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.status,
            _that.craneName,
            _that.craneId,
            _that.customerName,
            _that.customerEmail,
            _that.customerPhone);
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
            String description,
            String startDate,
            String endDate,
            String status,
            String craneName,
            int craneId,
            String customerName,
            String customerEmail,
            String? customerPhone)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Offer():
        return $default(
            _that.id,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.status,
            _that.craneName,
            _that.craneId,
            _that.customerName,
            _that.customerEmail,
            _that.customerPhone);
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
            String description,
            String startDate,
            String endDate,
            String status,
            String craneName,
            int craneId,
            String customerName,
            String customerEmail,
            String? customerPhone)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Offer() when $default != null:
        return $default(
            _that.id,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.status,
            _that.craneName,
            _that.craneId,
            _that.customerName,
            _that.customerEmail,
            _that.customerPhone);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Offer implements Offer {
  const _Offer(
      {required this.id,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.craneName,
      required this.craneId,
      required this.customerName,
      required this.customerEmail,
      this.customerPhone});
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  @override
  final int id;
  @override
  final String description;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String status;
  @override
  final String craneName;
  @override
  final int craneId;
  @override
  final String customerName;
  @override
  final String customerEmail;
  @override
  final String? customerPhone;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OfferCopyWith<_Offer> get copyWith =>
      __$OfferCopyWithImpl<_Offer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OfferToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Offer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.craneName, craneName) ||
                other.craneName == craneName) &&
            (identical(other.craneId, craneId) || other.craneId == craneId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      startDate,
      endDate,
      status,
      craneName,
      craneId,
      customerName,
      customerEmail,
      customerPhone);

  @override
  String toString() {
    return 'Offer(id: $id, description: $description, startDate: $startDate, endDate: $endDate, status: $status, craneName: $craneName, craneId: $craneId, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone)';
  }
}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) =
      __$OfferCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String description,
      String startDate,
      String endDate,
      String status,
      String craneName,
      int craneId,
      String customerName,
      String customerEmail,
      String? customerPhone});
}

/// @nodoc
class __$OfferCopyWithImpl<$Res> implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? craneName = null,
    Object? craneId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? customerPhone = freezed,
  }) {
    return _then(_Offer(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      craneName: null == craneName
          ? _self.craneName
          : craneName // ignore: cast_nullable_to_non_nullable
              as String,
      craneId: null == craneId
          ? _self.craneId
          : craneId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: null == customerEmail
          ? _self.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
