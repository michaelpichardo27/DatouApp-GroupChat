// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Job _$JobFromJson(Map<String, dynamic> json) {
  return _Job.fromJson(json);
}

/// @nodoc
mixin _$Job {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get budgetMin => throw _privateConstructorUsedError;
  int get budgetMax => throw _privateConstructorUsedError;
  Currency get currency => throw _privateConstructorUsedError;
  bool get isFixedPrice => throw _privateConstructorUsedError;
  DateTime get timelineStart => throw _privateConstructorUsedError;
  DateTime get timelineEnd => throw _privateConstructorUsedError;
  LocationType get locationType => throw _privateConstructorUsedError;
  String? get locationCity => throw _privateConstructorUsedError;
  String? get locationRegion => throw _privateConstructorUsedError;
  String? get locationCountry => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  Map<String, dynamic> get requirements => throw _privateConstructorUsedError;
  JobStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Profile? get client => throw _privateConstructorUsedError;

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res, Job>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String title,
    String description,
    int budgetMin,
    int budgetMax,
    Currency currency,
    bool isFixedPrice,
    DateTime timelineStart,
    DateTime timelineEnd,
    LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    Map<String, dynamic> requirements,
    JobStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    Profile? client,
  });

  $ProfileCopyWith<$Res>? get client;
}

/// @nodoc
class _$JobCopyWithImpl<$Res, $Val extends Job> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? title = null,
    Object? description = null,
    Object? budgetMin = null,
    Object? budgetMax = null,
    Object? currency = null,
    Object? isFixedPrice = null,
    Object? timelineStart = null,
    Object? timelineEnd = null,
    Object? locationType = null,
    Object? locationCity = freezed,
    Object? locationRegion = freezed,
    Object? locationCountry = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? requirements = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? client = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            budgetMin: null == budgetMin
                ? _value.budgetMin
                : budgetMin // ignore: cast_nullable_to_non_nullable
                      as int,
            budgetMax: null == budgetMax
                ? _value.budgetMax
                : budgetMax // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as Currency,
            isFixedPrice: null == isFixedPrice
                ? _value.isFixedPrice
                : isFixedPrice // ignore: cast_nullable_to_non_nullable
                      as bool,
            timelineStart: null == timelineStart
                ? _value.timelineStart
                : timelineStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timelineEnd: null == timelineEnd
                ? _value.timelineEnd
                : timelineEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            locationType: null == locationType
                ? _value.locationType
                : locationType // ignore: cast_nullable_to_non_nullable
                      as LocationType,
            locationCity: freezed == locationCity
                ? _value.locationCity
                : locationCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationRegion: freezed == locationRegion
                ? _value.locationRegion
                : locationRegion // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationCountry: freezed == locationCountry
                ? _value.locationCountry
                : locationCountry // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            requirements: null == requirements
                ? _value.requirements
                : requirements // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as JobStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            client: freezed == client
                ? _value.client
                : client // ignore: cast_nullable_to_non_nullable
                      as Profile?,
          )
          as $Val,
    );
  }

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobImplCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$JobImplCopyWith(_$JobImpl value, $Res Function(_$JobImpl) then) =
      __$$JobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String title,
    String description,
    int budgetMin,
    int budgetMax,
    Currency currency,
    bool isFixedPrice,
    DateTime timelineStart,
    DateTime timelineEnd,
    LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    Map<String, dynamic> requirements,
    JobStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    Profile? client,
  });

  @override
  $ProfileCopyWith<$Res>? get client;
}

/// @nodoc
class __$$JobImplCopyWithImpl<$Res> extends _$JobCopyWithImpl<$Res, _$JobImpl>
    implements _$$JobImplCopyWith<$Res> {
  __$$JobImplCopyWithImpl(_$JobImpl _value, $Res Function(_$JobImpl) _then)
    : super(_value, _then);

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? title = null,
    Object? description = null,
    Object? budgetMin = null,
    Object? budgetMax = null,
    Object? currency = null,
    Object? isFixedPrice = null,
    Object? timelineStart = null,
    Object? timelineEnd = null,
    Object? locationType = null,
    Object? locationCity = freezed,
    Object? locationRegion = freezed,
    Object? locationCountry = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? requirements = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? client = freezed,
  }) {
    return _then(
      _$JobImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetMin: null == budgetMin
            ? _value.budgetMin
            : budgetMin // ignore: cast_nullable_to_non_nullable
                  as int,
        budgetMax: null == budgetMax
            ? _value.budgetMax
            : budgetMax // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as Currency,
        isFixedPrice: null == isFixedPrice
            ? _value.isFixedPrice
            : isFixedPrice // ignore: cast_nullable_to_non_nullable
                  as bool,
        timelineStart: null == timelineStart
            ? _value.timelineStart
            : timelineStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timelineEnd: null == timelineEnd
            ? _value.timelineEnd
            : timelineEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        locationType: null == locationType
            ? _value.locationType
            : locationType // ignore: cast_nullable_to_non_nullable
                  as LocationType,
        locationCity: freezed == locationCity
            ? _value.locationCity
            : locationCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationRegion: freezed == locationRegion
            ? _value.locationRegion
            : locationRegion // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationCountry: freezed == locationCountry
            ? _value.locationCountry
            : locationCountry // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        requirements: null == requirements
            ? _value._requirements
            : requirements // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as JobStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        client: freezed == client
            ? _value.client
            : client // ignore: cast_nullable_to_non_nullable
                  as Profile?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobImpl extends _Job {
  const _$JobImpl({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.budgetMin,
    required this.budgetMax,
    required this.currency,
    required this.isFixedPrice,
    required this.timelineStart,
    required this.timelineEnd,
    required this.locationType,
    this.locationCity,
    this.locationRegion,
    this.locationCountry,
    this.latitude,
    this.longitude,
    required final Map<String, dynamic> requirements,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.client,
  }) : _requirements = requirements,
       super._();

  factory _$JobImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String title;
  @override
  final String description;
  @override
  final int budgetMin;
  @override
  final int budgetMax;
  @override
  final Currency currency;
  @override
  final bool isFixedPrice;
  @override
  final DateTime timelineStart;
  @override
  final DateTime timelineEnd;
  @override
  final LocationType locationType;
  @override
  final String? locationCity;
  @override
  final String? locationRegion;
  @override
  final String? locationCountry;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final Map<String, dynamic> _requirements;
  @override
  Map<String, dynamic> get requirements {
    if (_requirements is EqualUnmodifiableMapView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requirements);
  }

  @override
  final JobStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final Profile? client;

  @override
  String toString() {
    return 'Job(id: $id, clientId: $clientId, title: $title, description: $description, budgetMin: $budgetMin, budgetMax: $budgetMax, currency: $currency, isFixedPrice: $isFixedPrice, timelineStart: $timelineStart, timelineEnd: $timelineEnd, locationType: $locationType, locationCity: $locationCity, locationRegion: $locationRegion, locationCountry: $locationCountry, latitude: $latitude, longitude: $longitude, requirements: $requirements, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, client: $client)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.budgetMin, budgetMin) ||
                other.budgetMin == budgetMin) &&
            (identical(other.budgetMax, budgetMax) ||
                other.budgetMax == budgetMax) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isFixedPrice, isFixedPrice) ||
                other.isFixedPrice == isFixedPrice) &&
            (identical(other.timelineStart, timelineStart) ||
                other.timelineStart == timelineStart) &&
            (identical(other.timelineEnd, timelineEnd) ||
                other.timelineEnd == timelineEnd) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.locationCity, locationCity) ||
                other.locationCity == locationCity) &&
            (identical(other.locationRegion, locationRegion) ||
                other.locationRegion == locationRegion) &&
            (identical(other.locationCountry, locationCountry) ||
                other.locationCountry == locationCountry) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._requirements,
              _requirements,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.client, client) || other.client == client));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    clientId,
    title,
    description,
    budgetMin,
    budgetMax,
    currency,
    isFixedPrice,
    timelineStart,
    timelineEnd,
    locationType,
    locationCity,
    locationRegion,
    locationCountry,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_requirements),
    status,
    createdAt,
    updatedAt,
    client,
  ]);

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      __$$JobImplCopyWithImpl<_$JobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobImplToJson(this);
  }
}

abstract class _Job extends Job {
  const factory _Job({
    required final String id,
    required final String clientId,
    required final String title,
    required final String description,
    required final int budgetMin,
    required final int budgetMax,
    required final Currency currency,
    required final bool isFixedPrice,
    required final DateTime timelineStart,
    required final DateTime timelineEnd,
    required final LocationType locationType,
    final String? locationCity,
    final String? locationRegion,
    final String? locationCountry,
    final double? latitude,
    final double? longitude,
    required final Map<String, dynamic> requirements,
    required final JobStatus status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final Profile? client,
  }) = _$JobImpl;
  const _Job._() : super._();

  factory _Job.fromJson(Map<String, dynamic> json) = _$JobImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get budgetMin;
  @override
  int get budgetMax;
  @override
  Currency get currency;
  @override
  bool get isFixedPrice;
  @override
  DateTime get timelineStart;
  @override
  DateTime get timelineEnd;
  @override
  LocationType get locationType;
  @override
  String? get locationCity;
  @override
  String? get locationRegion;
  @override
  String? get locationCountry;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  Map<String, dynamic> get requirements;
  @override
  JobStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Profile? get client;

  /// Create a copy of Job
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Application _$ApplicationFromJson(Map<String, dynamic> json) {
  return _Application.fromJson(json);
}

/// @nodoc
mixin _$Application {
  String get id => throw _privateConstructorUsedError;
  String get jobId => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String get coverLetter => throw _privateConstructorUsedError;
  int get proposedAmount => throw _privateConstructorUsedError;
  String? get proposedTerms => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Profile? get creator => throw _privateConstructorUsedError;

  /// Serializes this Application to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationCopyWith<Application> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationCopyWith<$Res> {
  factory $ApplicationCopyWith(
    Application value,
    $Res Function(Application) then,
  ) = _$ApplicationCopyWithImpl<$Res, Application>;
  @useResult
  $Res call({
    String id,
    String jobId,
    String creatorId,
    String coverLetter,
    int proposedAmount,
    String? proposedTerms,
    ApplicationStatus status,
    DateTime createdAt,
    Profile? creator,
  });

  $ProfileCopyWith<$Res>? get creator;
}

/// @nodoc
class _$ApplicationCopyWithImpl<$Res, $Val extends Application>
    implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? creatorId = null,
    Object? coverLetter = null,
    Object? proposedAmount = null,
    Object? proposedTerms = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? creator = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorId: null == creatorId
                ? _value.creatorId
                : creatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            coverLetter: null == coverLetter
                ? _value.coverLetter
                : coverLetter // ignore: cast_nullable_to_non_nullable
                      as String,
            proposedAmount: null == proposedAmount
                ? _value.proposedAmount
                : proposedAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            proposedTerms: freezed == proposedTerms
                ? _value.proposedTerms
                : proposedTerms // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ApplicationStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            creator: freezed == creator
                ? _value.creator
                : creator // ignore: cast_nullable_to_non_nullable
                      as Profile?,
          )
          as $Val,
    );
  }

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get creator {
    if (_value.creator == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.creator!, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApplicationImplCopyWith<$Res>
    implements $ApplicationCopyWith<$Res> {
  factory _$$ApplicationImplCopyWith(
    _$ApplicationImpl value,
    $Res Function(_$ApplicationImpl) then,
  ) = __$$ApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String jobId,
    String creatorId,
    String coverLetter,
    int proposedAmount,
    String? proposedTerms,
    ApplicationStatus status,
    DateTime createdAt,
    Profile? creator,
  });

  @override
  $ProfileCopyWith<$Res>? get creator;
}

/// @nodoc
class __$$ApplicationImplCopyWithImpl<$Res>
    extends _$ApplicationCopyWithImpl<$Res, _$ApplicationImpl>
    implements _$$ApplicationImplCopyWith<$Res> {
  __$$ApplicationImplCopyWithImpl(
    _$ApplicationImpl _value,
    $Res Function(_$ApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? creatorId = null,
    Object? coverLetter = null,
    Object? proposedAmount = null,
    Object? proposedTerms = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? creator = freezed,
  }) {
    return _then(
      _$ApplicationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        coverLetter: null == coverLetter
            ? _value.coverLetter
            : coverLetter // ignore: cast_nullable_to_non_nullable
                  as String,
        proposedAmount: null == proposedAmount
            ? _value.proposedAmount
            : proposedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        proposedTerms: freezed == proposedTerms
            ? _value.proposedTerms
            : proposedTerms // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ApplicationStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        creator: freezed == creator
            ? _value.creator
            : creator // ignore: cast_nullable_to_non_nullable
                  as Profile?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationImpl extends _Application {
  const _$ApplicationImpl({
    required this.id,
    required this.jobId,
    required this.creatorId,
    required this.coverLetter,
    required this.proposedAmount,
    this.proposedTerms,
    required this.status,
    required this.createdAt,
    this.creator,
  }) : super._();

  factory _$ApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String jobId;
  @override
  final String creatorId;
  @override
  final String coverLetter;
  @override
  final int proposedAmount;
  @override
  final String? proposedTerms;
  @override
  final ApplicationStatus status;
  @override
  final DateTime createdAt;
  @override
  final Profile? creator;

  @override
  String toString() {
    return 'Application(id: $id, jobId: $jobId, creatorId: $creatorId, coverLetter: $coverLetter, proposedAmount: $proposedAmount, proposedTerms: $proposedTerms, status: $status, createdAt: $createdAt, creator: $creator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.coverLetter, coverLetter) ||
                other.coverLetter == coverLetter) &&
            (identical(other.proposedAmount, proposedAmount) ||
                other.proposedAmount == proposedAmount) &&
            (identical(other.proposedTerms, proposedTerms) ||
                other.proposedTerms == proposedTerms) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.creator, creator) || other.creator == creator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobId,
    creatorId,
    coverLetter,
    proposedAmount,
    proposedTerms,
    status,
    createdAt,
    creator,
  );

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      __$$ApplicationImplCopyWithImpl<_$ApplicationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationImplToJson(this);
  }
}

abstract class _Application extends Application {
  const factory _Application({
    required final String id,
    required final String jobId,
    required final String creatorId,
    required final String coverLetter,
    required final int proposedAmount,
    final String? proposedTerms,
    required final ApplicationStatus status,
    required final DateTime createdAt,
    final Profile? creator,
  }) = _$ApplicationImpl;
  const _Application._() : super._();

  factory _Application.fromJson(Map<String, dynamic> json) =
      _$ApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get jobId;
  @override
  String get creatorId;
  @override
  String get coverLetter;
  @override
  int get proposedAmount;
  @override
  String? get proposedTerms;
  @override
  ApplicationStatus get status;
  @override
  DateTime get createdAt;
  @override
  Profile? get creator;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Hire _$HireFromJson(Map<String, dynamic> json) {
  return _Hire.fromJson(json);
}

/// @nodoc
mixin _$Hire {
  String get id => throw _privateConstructorUsedError;
  String get jobId => throw _privateConstructorUsedError;
  String get applicationId => throw _privateConstructorUsedError;
  int get agreedAmount => throw _privateConstructorUsedError;
  String get agreedTerms => throw _privateConstructorUsedError;
  DateTime get hiredAt => throw _privateConstructorUsedError;
  Application? get application => throw _privateConstructorUsedError;

  /// Serializes this Hire to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HireCopyWith<Hire> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HireCopyWith<$Res> {
  factory $HireCopyWith(Hire value, $Res Function(Hire) then) =
      _$HireCopyWithImpl<$Res, Hire>;
  @useResult
  $Res call({
    String id,
    String jobId,
    String applicationId,
    int agreedAmount,
    String agreedTerms,
    DateTime hiredAt,
    Application? application,
  });

  $ApplicationCopyWith<$Res>? get application;
}

/// @nodoc
class _$HireCopyWithImpl<$Res, $Val extends Hire>
    implements $HireCopyWith<$Res> {
  _$HireCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? applicationId = null,
    Object? agreedAmount = null,
    Object? agreedTerms = null,
    Object? hiredAt = null,
    Object? application = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            applicationId: null == applicationId
                ? _value.applicationId
                : applicationId // ignore: cast_nullable_to_non_nullable
                      as String,
            agreedAmount: null == agreedAmount
                ? _value.agreedAmount
                : agreedAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            agreedTerms: null == agreedTerms
                ? _value.agreedTerms
                : agreedTerms // ignore: cast_nullable_to_non_nullable
                      as String,
            hiredAt: null == hiredAt
                ? _value.hiredAt
                : hiredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            application: freezed == application
                ? _value.application
                : application // ignore: cast_nullable_to_non_nullable
                      as Application?,
          )
          as $Val,
    );
  }

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApplicationCopyWith<$Res>? get application {
    if (_value.application == null) {
      return null;
    }

    return $ApplicationCopyWith<$Res>(_value.application!, (value) {
      return _then(_value.copyWith(application: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HireImplCopyWith<$Res> implements $HireCopyWith<$Res> {
  factory _$$HireImplCopyWith(
    _$HireImpl value,
    $Res Function(_$HireImpl) then,
  ) = __$$HireImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String jobId,
    String applicationId,
    int agreedAmount,
    String agreedTerms,
    DateTime hiredAt,
    Application? application,
  });

  @override
  $ApplicationCopyWith<$Res>? get application;
}

/// @nodoc
class __$$HireImplCopyWithImpl<$Res>
    extends _$HireCopyWithImpl<$Res, _$HireImpl>
    implements _$$HireImplCopyWith<$Res> {
  __$$HireImplCopyWithImpl(_$HireImpl _value, $Res Function(_$HireImpl) _then)
    : super(_value, _then);

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? applicationId = null,
    Object? agreedAmount = null,
    Object? agreedTerms = null,
    Object? hiredAt = null,
    Object? application = freezed,
  }) {
    return _then(
      _$HireImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        applicationId: null == applicationId
            ? _value.applicationId
            : applicationId // ignore: cast_nullable_to_non_nullable
                  as String,
        agreedAmount: null == agreedAmount
            ? _value.agreedAmount
            : agreedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        agreedTerms: null == agreedTerms
            ? _value.agreedTerms
            : agreedTerms // ignore: cast_nullable_to_non_nullable
                  as String,
        hiredAt: null == hiredAt
            ? _value.hiredAt
            : hiredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        application: freezed == application
            ? _value.application
            : application // ignore: cast_nullable_to_non_nullable
                  as Application?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HireImpl implements _Hire {
  const _$HireImpl({
    required this.id,
    required this.jobId,
    required this.applicationId,
    required this.agreedAmount,
    required this.agreedTerms,
    required this.hiredAt,
    this.application,
  });

  factory _$HireImpl.fromJson(Map<String, dynamic> json) =>
      _$$HireImplFromJson(json);

  @override
  final String id;
  @override
  final String jobId;
  @override
  final String applicationId;
  @override
  final int agreedAmount;
  @override
  final String agreedTerms;
  @override
  final DateTime hiredAt;
  @override
  final Application? application;

  @override
  String toString() {
    return 'Hire(id: $id, jobId: $jobId, applicationId: $applicationId, agreedAmount: $agreedAmount, agreedTerms: $agreedTerms, hiredAt: $hiredAt, application: $application)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HireImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.agreedAmount, agreedAmount) ||
                other.agreedAmount == agreedAmount) &&
            (identical(other.agreedTerms, agreedTerms) ||
                other.agreedTerms == agreedTerms) &&
            (identical(other.hiredAt, hiredAt) || other.hiredAt == hiredAt) &&
            (identical(other.application, application) ||
                other.application == application));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobId,
    applicationId,
    agreedAmount,
    agreedTerms,
    hiredAt,
    application,
  );

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HireImplCopyWith<_$HireImpl> get copyWith =>
      __$$HireImplCopyWithImpl<_$HireImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HireImplToJson(this);
  }
}

abstract class _Hire implements Hire {
  const factory _Hire({
    required final String id,
    required final String jobId,
    required final String applicationId,
    required final int agreedAmount,
    required final String agreedTerms,
    required final DateTime hiredAt,
    final Application? application,
  }) = _$HireImpl;

  factory _Hire.fromJson(Map<String, dynamic> json) = _$HireImpl.fromJson;

  @override
  String get id;
  @override
  String get jobId;
  @override
  String get applicationId;
  @override
  int get agreedAmount;
  @override
  String get agreedTerms;
  @override
  DateTime get hiredAt;
  @override
  Application? get application;

  /// Create a copy of Hire
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HireImplCopyWith<_$HireImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobDraft _$JobDraftFromJson(Map<String, dynamic> json) {
  return _JobDraft.fromJson(json);
}

/// @nodoc
mixin _$JobDraft {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get budgetMin => throw _privateConstructorUsedError;
  int get budgetMax => throw _privateConstructorUsedError;
  Currency get currency => throw _privateConstructorUsedError;
  bool get isFixedPrice => throw _privateConstructorUsedError;
  DateTime get timelineStart => throw _privateConstructorUsedError;
  DateTime get timelineEnd => throw _privateConstructorUsedError;
  LocationType get locationType => throw _privateConstructorUsedError;
  String? get locationCity => throw _privateConstructorUsedError;
  String? get locationRegion => throw _privateConstructorUsedError;
  String? get locationCountry => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  Map<String, dynamic> get requirements => throw _privateConstructorUsedError;

  /// Serializes this JobDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobDraftCopyWith<JobDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobDraftCopyWith<$Res> {
  factory $JobDraftCopyWith(JobDraft value, $Res Function(JobDraft) then) =
      _$JobDraftCopyWithImpl<$Res, JobDraft>;
  @useResult
  $Res call({
    String title,
    String description,
    int budgetMin,
    int budgetMax,
    Currency currency,
    bool isFixedPrice,
    DateTime timelineStart,
    DateTime timelineEnd,
    LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    Map<String, dynamic> requirements,
  });
}

/// @nodoc
class _$JobDraftCopyWithImpl<$Res, $Val extends JobDraft>
    implements $JobDraftCopyWith<$Res> {
  _$JobDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? budgetMin = null,
    Object? budgetMax = null,
    Object? currency = null,
    Object? isFixedPrice = null,
    Object? timelineStart = null,
    Object? timelineEnd = null,
    Object? locationType = null,
    Object? locationCity = freezed,
    Object? locationRegion = freezed,
    Object? locationCountry = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? requirements = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            budgetMin: null == budgetMin
                ? _value.budgetMin
                : budgetMin // ignore: cast_nullable_to_non_nullable
                      as int,
            budgetMax: null == budgetMax
                ? _value.budgetMax
                : budgetMax // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as Currency,
            isFixedPrice: null == isFixedPrice
                ? _value.isFixedPrice
                : isFixedPrice // ignore: cast_nullable_to_non_nullable
                      as bool,
            timelineStart: null == timelineStart
                ? _value.timelineStart
                : timelineStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timelineEnd: null == timelineEnd
                ? _value.timelineEnd
                : timelineEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            locationType: null == locationType
                ? _value.locationType
                : locationType // ignore: cast_nullable_to_non_nullable
                      as LocationType,
            locationCity: freezed == locationCity
                ? _value.locationCity
                : locationCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationRegion: freezed == locationRegion
                ? _value.locationRegion
                : locationRegion // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationCountry: freezed == locationCountry
                ? _value.locationCountry
                : locationCountry // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            requirements: null == requirements
                ? _value.requirements
                : requirements // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobDraftImplCopyWith<$Res>
    implements $JobDraftCopyWith<$Res> {
  factory _$$JobDraftImplCopyWith(
    _$JobDraftImpl value,
    $Res Function(_$JobDraftImpl) then,
  ) = __$$JobDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    int budgetMin,
    int budgetMax,
    Currency currency,
    bool isFixedPrice,
    DateTime timelineStart,
    DateTime timelineEnd,
    LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    Map<String, dynamic> requirements,
  });
}

/// @nodoc
class __$$JobDraftImplCopyWithImpl<$Res>
    extends _$JobDraftCopyWithImpl<$Res, _$JobDraftImpl>
    implements _$$JobDraftImplCopyWith<$Res> {
  __$$JobDraftImplCopyWithImpl(
    _$JobDraftImpl _value,
    $Res Function(_$JobDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? budgetMin = null,
    Object? budgetMax = null,
    Object? currency = null,
    Object? isFixedPrice = null,
    Object? timelineStart = null,
    Object? timelineEnd = null,
    Object? locationType = null,
    Object? locationCity = freezed,
    Object? locationRegion = freezed,
    Object? locationCountry = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? requirements = null,
  }) {
    return _then(
      _$JobDraftImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetMin: null == budgetMin
            ? _value.budgetMin
            : budgetMin // ignore: cast_nullable_to_non_nullable
                  as int,
        budgetMax: null == budgetMax
            ? _value.budgetMax
            : budgetMax // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as Currency,
        isFixedPrice: null == isFixedPrice
            ? _value.isFixedPrice
            : isFixedPrice // ignore: cast_nullable_to_non_nullable
                  as bool,
        timelineStart: null == timelineStart
            ? _value.timelineStart
            : timelineStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timelineEnd: null == timelineEnd
            ? _value.timelineEnd
            : timelineEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        locationType: null == locationType
            ? _value.locationType
            : locationType // ignore: cast_nullable_to_non_nullable
                  as LocationType,
        locationCity: freezed == locationCity
            ? _value.locationCity
            : locationCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationRegion: freezed == locationRegion
            ? _value.locationRegion
            : locationRegion // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationCountry: freezed == locationCountry
            ? _value.locationCountry
            : locationCountry // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        requirements: null == requirements
            ? _value._requirements
            : requirements // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobDraftImpl extends _JobDraft {
  const _$JobDraftImpl({
    required this.title,
    required this.description,
    required this.budgetMin,
    required this.budgetMax,
    required this.currency,
    required this.isFixedPrice,
    required this.timelineStart,
    required this.timelineEnd,
    required this.locationType,
    this.locationCity,
    this.locationRegion,
    this.locationCountry,
    this.latitude,
    this.longitude,
    required final Map<String, dynamic> requirements,
  }) : _requirements = requirements,
       super._();

  factory _$JobDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobDraftImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final int budgetMin;
  @override
  final int budgetMax;
  @override
  final Currency currency;
  @override
  final bool isFixedPrice;
  @override
  final DateTime timelineStart;
  @override
  final DateTime timelineEnd;
  @override
  final LocationType locationType;
  @override
  final String? locationCity;
  @override
  final String? locationRegion;
  @override
  final String? locationCountry;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final Map<String, dynamic> _requirements;
  @override
  Map<String, dynamic> get requirements {
    if (_requirements is EqualUnmodifiableMapView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requirements);
  }

  @override
  String toString() {
    return 'JobDraft(title: $title, description: $description, budgetMin: $budgetMin, budgetMax: $budgetMax, currency: $currency, isFixedPrice: $isFixedPrice, timelineStart: $timelineStart, timelineEnd: $timelineEnd, locationType: $locationType, locationCity: $locationCity, locationRegion: $locationRegion, locationCountry: $locationCountry, latitude: $latitude, longitude: $longitude, requirements: $requirements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobDraftImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.budgetMin, budgetMin) ||
                other.budgetMin == budgetMin) &&
            (identical(other.budgetMax, budgetMax) ||
                other.budgetMax == budgetMax) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isFixedPrice, isFixedPrice) ||
                other.isFixedPrice == isFixedPrice) &&
            (identical(other.timelineStart, timelineStart) ||
                other.timelineStart == timelineStart) &&
            (identical(other.timelineEnd, timelineEnd) ||
                other.timelineEnd == timelineEnd) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.locationCity, locationCity) ||
                other.locationCity == locationCity) &&
            (identical(other.locationRegion, locationRegion) ||
                other.locationRegion == locationRegion) &&
            (identical(other.locationCountry, locationCountry) ||
                other.locationCountry == locationCountry) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._requirements,
              _requirements,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    budgetMin,
    budgetMax,
    currency,
    isFixedPrice,
    timelineStart,
    timelineEnd,
    locationType,
    locationCity,
    locationRegion,
    locationCountry,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_requirements),
  );

  /// Create a copy of JobDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobDraftImplCopyWith<_$JobDraftImpl> get copyWith =>
      __$$JobDraftImplCopyWithImpl<_$JobDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobDraftImplToJson(this);
  }
}

abstract class _JobDraft extends JobDraft {
  const factory _JobDraft({
    required final String title,
    required final String description,
    required final int budgetMin,
    required final int budgetMax,
    required final Currency currency,
    required final bool isFixedPrice,
    required final DateTime timelineStart,
    required final DateTime timelineEnd,
    required final LocationType locationType,
    final String? locationCity,
    final String? locationRegion,
    final String? locationCountry,
    final double? latitude,
    final double? longitude,
    required final Map<String, dynamic> requirements,
  }) = _$JobDraftImpl;
  const _JobDraft._() : super._();

  factory _JobDraft.fromJson(Map<String, dynamic> json) =
      _$JobDraftImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  int get budgetMin;
  @override
  int get budgetMax;
  @override
  Currency get currency;
  @override
  bool get isFixedPrice;
  @override
  DateTime get timelineStart;
  @override
  DateTime get timelineEnd;
  @override
  LocationType get locationType;
  @override
  String? get locationCity;
  @override
  String? get locationRegion;
  @override
  String? get locationCountry;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  Map<String, dynamic> get requirements;

  /// Create a copy of JobDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobDraftImplCopyWith<_$JobDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApplicationInput _$ApplicationInputFromJson(Map<String, dynamic> json) {
  return _ApplicationInput.fromJson(json);
}

/// @nodoc
mixin _$ApplicationInput {
  String get jobId => throw _privateConstructorUsedError;
  String get coverLetter => throw _privateConstructorUsedError;
  int get proposedAmount => throw _privateConstructorUsedError;
  String? get proposedTerms => throw _privateConstructorUsedError;

  /// Serializes this ApplicationInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationInputCopyWith<ApplicationInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationInputCopyWith<$Res> {
  factory $ApplicationInputCopyWith(
    ApplicationInput value,
    $Res Function(ApplicationInput) then,
  ) = _$ApplicationInputCopyWithImpl<$Res, ApplicationInput>;
  @useResult
  $Res call({
    String jobId,
    String coverLetter,
    int proposedAmount,
    String? proposedTerms,
  });
}

/// @nodoc
class _$ApplicationInputCopyWithImpl<$Res, $Val extends ApplicationInput>
    implements $ApplicationInputCopyWith<$Res> {
  _$ApplicationInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? coverLetter = null,
    Object? proposedAmount = null,
    Object? proposedTerms = freezed,
  }) {
    return _then(
      _value.copyWith(
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            coverLetter: null == coverLetter
                ? _value.coverLetter
                : coverLetter // ignore: cast_nullable_to_non_nullable
                      as String,
            proposedAmount: null == proposedAmount
                ? _value.proposedAmount
                : proposedAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            proposedTerms: freezed == proposedTerms
                ? _value.proposedTerms
                : proposedTerms // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationInputImplCopyWith<$Res>
    implements $ApplicationInputCopyWith<$Res> {
  factory _$$ApplicationInputImplCopyWith(
    _$ApplicationInputImpl value,
    $Res Function(_$ApplicationInputImpl) then,
  ) = __$$ApplicationInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String jobId,
    String coverLetter,
    int proposedAmount,
    String? proposedTerms,
  });
}

/// @nodoc
class __$$ApplicationInputImplCopyWithImpl<$Res>
    extends _$ApplicationInputCopyWithImpl<$Res, _$ApplicationInputImpl>
    implements _$$ApplicationInputImplCopyWith<$Res> {
  __$$ApplicationInputImplCopyWithImpl(
    _$ApplicationInputImpl _value,
    $Res Function(_$ApplicationInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? coverLetter = null,
    Object? proposedAmount = null,
    Object? proposedTerms = freezed,
  }) {
    return _then(
      _$ApplicationInputImpl(
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        coverLetter: null == coverLetter
            ? _value.coverLetter
            : coverLetter // ignore: cast_nullable_to_non_nullable
                  as String,
        proposedAmount: null == proposedAmount
            ? _value.proposedAmount
            : proposedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        proposedTerms: freezed == proposedTerms
            ? _value.proposedTerms
            : proposedTerms // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationInputImpl extends _ApplicationInput {
  const _$ApplicationInputImpl({
    required this.jobId,
    required this.coverLetter,
    required this.proposedAmount,
    this.proposedTerms,
  }) : super._();

  factory _$ApplicationInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationInputImplFromJson(json);

  @override
  final String jobId;
  @override
  final String coverLetter;
  @override
  final int proposedAmount;
  @override
  final String? proposedTerms;

  @override
  String toString() {
    return 'ApplicationInput(jobId: $jobId, coverLetter: $coverLetter, proposedAmount: $proposedAmount, proposedTerms: $proposedTerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationInputImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.coverLetter, coverLetter) ||
                other.coverLetter == coverLetter) &&
            (identical(other.proposedAmount, proposedAmount) ||
                other.proposedAmount == proposedAmount) &&
            (identical(other.proposedTerms, proposedTerms) ||
                other.proposedTerms == proposedTerms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jobId,
    coverLetter,
    proposedAmount,
    proposedTerms,
  );

  /// Create a copy of ApplicationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationInputImplCopyWith<_$ApplicationInputImpl> get copyWith =>
      __$$ApplicationInputImplCopyWithImpl<_$ApplicationInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationInputImplToJson(this);
  }
}

abstract class _ApplicationInput extends ApplicationInput {
  const factory _ApplicationInput({
    required final String jobId,
    required final String coverLetter,
    required final int proposedAmount,
    final String? proposedTerms,
  }) = _$ApplicationInputImpl;
  const _ApplicationInput._() : super._();

  factory _ApplicationInput.fromJson(Map<String, dynamic> json) =
      _$ApplicationInputImpl.fromJson;

  @override
  String get jobId;
  @override
  String get coverLetter;
  @override
  int get proposedAmount;
  @override
  String? get proposedTerms;

  /// Create a copy of ApplicationInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationInputImplCopyWith<_$ApplicationInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
