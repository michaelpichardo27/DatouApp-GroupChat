// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobImpl _$$JobImplFromJson(Map<String, dynamic> json) => _$JobImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  budgetMin: (json['budgetMin'] as num).toInt(),
  budgetMax: (json['budgetMax'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  isFixedPrice: json['isFixedPrice'] as bool,
  timelineStart: DateTime.parse(json['timelineStart'] as String),
  timelineEnd: DateTime.parse(json['timelineEnd'] as String),
  locationType: $enumDecode(_$LocationTypeEnumMap, json['locationType']),
  locationCity: json['locationCity'] as String?,
  locationRegion: json['locationRegion'] as String?,
  locationCountry: json['locationCountry'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  requirements: json['requirements'] as Map<String, dynamic>,
  status: $enumDecode(_$JobStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  client: json['client'] == null
      ? null
      : Profile.fromJson(json['client'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$JobImplToJson(_$JobImpl instance) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'title': instance.title,
  'description': instance.description,
  'budgetMin': instance.budgetMin,
  'budgetMax': instance.budgetMax,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'isFixedPrice': instance.isFixedPrice,
  'timelineStart': instance.timelineStart.toIso8601String(),
  'timelineEnd': instance.timelineEnd.toIso8601String(),
  'locationType': _$LocationTypeEnumMap[instance.locationType]!,
  'locationCity': instance.locationCity,
  'locationRegion': instance.locationRegion,
  'locationCountry': instance.locationCountry,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'requirements': instance.requirements,
  'status': _$JobStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'client': instance.client,
};

const _$CurrencyEnumMap = {
  Currency.USD: 'USD',
  Currency.EUR: 'EUR',
  Currency.GBP: 'GBP',
  Currency.CAD: 'CAD',
  Currency.AUD: 'AUD',
};

const _$LocationTypeEnumMap = {
  LocationType.remote: 'remote',
  LocationType.onsite: 'onsite',
  LocationType.hybrid: 'hybrid',
};

const _$JobStatusEnumMap = {
  JobStatus.open: 'open',
  JobStatus.hiring: 'hiring',
  JobStatus.closed: 'closed',
};

_$ApplicationImpl _$$ApplicationImplFromJson(Map<String, dynamic> json) =>
    _$ApplicationImpl(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      creatorId: json['creatorId'] as String,
      coverLetter: json['coverLetter'] as String,
      proposedAmount: (json['proposedAmount'] as num).toInt(),
      proposedTerms: json['proposedTerms'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      creator: json['creator'] == null
          ? null
          : Profile.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApplicationImplToJson(_$ApplicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'creatorId': instance.creatorId,
      'coverLetter': instance.coverLetter,
      'proposedAmount': instance.proposedAmount,
      'proposedTerms': instance.proposedTerms,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'creator': instance.creator,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.submitted: 'submitted',
  ApplicationStatus.shortlisted: 'shortlisted',
  ApplicationStatus.declined: 'declined',
  ApplicationStatus.hired: 'hired',
};

_$HireImpl _$$HireImplFromJson(Map<String, dynamic> json) => _$HireImpl(
  id: json['id'] as String,
  jobId: json['jobId'] as String,
  applicationId: json['applicationId'] as String,
  agreedAmount: (json['agreedAmount'] as num).toInt(),
  agreedTerms: json['agreedTerms'] as String,
  hiredAt: DateTime.parse(json['hiredAt'] as String),
  application: json['application'] == null
      ? null
      : Application.fromJson(json['application'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$HireImplToJson(_$HireImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'applicationId': instance.applicationId,
      'agreedAmount': instance.agreedAmount,
      'agreedTerms': instance.agreedTerms,
      'hiredAt': instance.hiredAt.toIso8601String(),
      'application': instance.application,
    };

_$JobDraftImpl _$$JobDraftImplFromJson(Map<String, dynamic> json) =>
    _$JobDraftImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      budgetMin: (json['budgetMin'] as num).toInt(),
      budgetMax: (json['budgetMax'] as num).toInt(),
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      isFixedPrice: json['isFixedPrice'] as bool,
      timelineStart: DateTime.parse(json['timelineStart'] as String),
      timelineEnd: DateTime.parse(json['timelineEnd'] as String),
      locationType: $enumDecode(_$LocationTypeEnumMap, json['locationType']),
      locationCity: json['locationCity'] as String?,
      locationRegion: json['locationRegion'] as String?,
      locationCountry: json['locationCountry'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      requirements: json['requirements'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$JobDraftImplToJson(_$JobDraftImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'budgetMin': instance.budgetMin,
      'budgetMax': instance.budgetMax,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'isFixedPrice': instance.isFixedPrice,
      'timelineStart': instance.timelineStart.toIso8601String(),
      'timelineEnd': instance.timelineEnd.toIso8601String(),
      'locationType': _$LocationTypeEnumMap[instance.locationType]!,
      'locationCity': instance.locationCity,
      'locationRegion': instance.locationRegion,
      'locationCountry': instance.locationCountry,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'requirements': instance.requirements,
    };

_$ApplicationInputImpl _$$ApplicationInputImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationInputImpl(
  jobId: json['jobId'] as String,
  coverLetter: json['coverLetter'] as String,
  proposedAmount: (json['proposedAmount'] as num).toInt(),
  proposedTerms: json['proposedTerms'] as String?,
);

Map<String, dynamic> _$$ApplicationInputImplToJson(
  _$ApplicationInputImpl instance,
) => <String, dynamic>{
  'jobId': instance.jobId,
  'coverLetter': instance.coverLetter,
  'proposedAmount': instance.proposedAmount,
  'proposedTerms': instance.proposedTerms,
};
