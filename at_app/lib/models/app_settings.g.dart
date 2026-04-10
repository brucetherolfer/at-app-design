// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsCollection on Isar {
  IsarCollection<AppSettings> get appSettings => this.collection();
}

const AppSettingsSchema = CollectionSchema(
  name: r'AppSettings',
  id: -5633561779022347008,
  properties: {
    r'activeSequenceUid': PropertySchema(
      id: 0,
      name: r'activeSequenceUid',
      type: IsarType.string,
    ),
    r'alternateLibraryUid': PropertySchema(
      id: 1,
      name: r'alternateLibraryUid',
      type: IsarType.string,
    ),
    r'audioMode': PropertySchema(
      id: 2,
      name: r'audioMode',
      type: IsarType.byte,
      enumMap: _AppSettingsaudioModeEnumValueMap,
    ),
    r'deliveryMode': PropertySchema(
      id: 3,
      name: r'deliveryMode',
      type: IsarType.byte,
      enumMap: _AppSettingsdeliveryModeEnumValueMap,
    ),
    r'fixedIntervalSeconds': PropertySchema(
      id: 4,
      name: r'fixedIntervalSeconds',
      type: IsarType.long,
    ),
    r'intervalType': PropertySchema(
      id: 5,
      name: r'intervalType',
      type: IsarType.byte,
      enumMap: _AppSettingsintervalTypeEnumValueMap,
    ),
    r'isPaused': PropertySchema(
      id: 6,
      name: r'isPaused',
      type: IsarType.bool,
    ),
    r'isRunning': PropertySchema(
      id: 7,
      name: r'isRunning',
      type: IsarType.bool,
    ),
    r'lastFiredAltSequentialIndex': PropertySchema(
      id: 8,
      name: r'lastFiredAltSequentialIndex',
      type: IsarType.long,
    ),
    r'lastFiredFrom': PropertySchema(
      id: 9,
      name: r'lastFiredFrom',
      type: IsarType.byte,
      enumMap: _AppSettingslastFiredFromEnumValueMap,
    ),
    r'lastFiredSequentialIndex': PropertySchema(
      id: 10,
      name: r'lastFiredSequentialIndex',
      type: IsarType.long,
    ),
    r'maxIntervalMinutes': PropertySchema(
      id: 11,
      name: r'maxIntervalMinutes',
      type: IsarType.long,
    ),
    r'minIntervalMinutes': PropertySchema(
      id: 12,
      name: r'minIntervalMinutes',
      type: IsarType.long,
    ),
    r'primaryLibraryUid': PropertySchema(
      id: 13,
      name: r'primaryLibraryUid',
      type: IsarType.string,
    ),
    r'promptOrder': PropertySchema(
      id: 14,
      name: r'promptOrder',
      type: IsarType.byte,
      enumMap: _AppSettingspromptOrderEnumValueMap,
    ),
    r'selectedChime': PropertySchema(
      id: 15,
      name: r'selectedChime',
      type: IsarType.string,
    ),
    r'selectedVoiceName': PropertySchema(
      id: 16,
      name: r'selectedVoiceName',
      type: IsarType.string,
    ),
    r'sequenceGapSeconds': PropertySchema(
      id: 17,
      name: r'sequenceGapSeconds',
      type: IsarType.long,
    ),
    r'sequenceTimerMinutes': PropertySchema(
      id: 18,
      name: r'sequenceTimerMinutes',
      type: IsarType.long,
    ),
    r'sequenceTrigger': PropertySchema(
      id: 19,
      name: r'sequenceTrigger',
      type: IsarType.byte,
      enumMap: _AppSettingssequenceTriggerEnumValueMap,
    ),
    r'speechPitch': PropertySchema(
      id: 20,
      name: r'speechPitch',
      type: IsarType.double,
    ),
    r'speechRate': PropertySchema(
      id: 21,
      name: r'speechRate',
      type: IsarType.double,
    ),
    r'visualMode': PropertySchema(
      id: 22,
      name: r'visualMode',
      type: IsarType.byte,
      enumMap: _AppSettingsvisualModeEnumValueMap,
    )
  },
  estimateSize: _appSettingsEstimateSize,
  serialize: _appSettingsSerialize,
  deserialize: _appSettingsDeserialize,
  deserializeProp: _appSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsGetId,
  getLinks: _appSettingsGetLinks,
  attach: _appSettingsAttach,
  version: '3.1.0+1',
);

int _appSettingsEstimateSize(
  AppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeSequenceUid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.alternateLibraryUid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.primaryLibraryUid.length * 3;
  bytesCount += 3 + object.selectedChime.length * 3;
  bytesCount += 3 + object.selectedVoiceName.length * 3;
  return bytesCount;
}

void _appSettingsSerialize(
  AppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeSequenceUid);
  writer.writeString(offsets[1], object.alternateLibraryUid);
  writer.writeByte(offsets[2], object.audioMode.index);
  writer.writeByte(offsets[3], object.deliveryMode.index);
  writer.writeLong(offsets[4], object.fixedIntervalSeconds);
  writer.writeByte(offsets[5], object.intervalType.index);
  writer.writeBool(offsets[6], object.isPaused);
  writer.writeBool(offsets[7], object.isRunning);
  writer.writeLong(offsets[8], object.lastFiredAltSequentialIndex);
  writer.writeByte(offsets[9], object.lastFiredFrom.index);
  writer.writeLong(offsets[10], object.lastFiredSequentialIndex);
  writer.writeLong(offsets[11], object.maxIntervalMinutes);
  writer.writeLong(offsets[12], object.minIntervalMinutes);
  writer.writeString(offsets[13], object.primaryLibraryUid);
  writer.writeByte(offsets[14], object.promptOrder.index);
  writer.writeString(offsets[15], object.selectedChime);
  writer.writeString(offsets[16], object.selectedVoiceName);
  writer.writeLong(offsets[17], object.sequenceGapSeconds);
  writer.writeLong(offsets[18], object.sequenceTimerMinutes);
  writer.writeByte(offsets[19], object.sequenceTrigger.index);
  writer.writeDouble(offsets[20], object.speechPitch);
  writer.writeDouble(offsets[21], object.speechRate);
  writer.writeByte(offsets[22], object.visualMode.index);
}

AppSettings _appSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettings();
  object.activeSequenceUid = reader.readStringOrNull(offsets[0]);
  object.alternateLibraryUid = reader.readStringOrNull(offsets[1]);
  object.audioMode =
      _AppSettingsaudioModeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          AudioMode.silent;
  object.deliveryMode =
      _AppSettingsdeliveryModeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
          DeliveryMode.free;
  object.fixedIntervalSeconds = reader.readLong(offsets[4]);
  object.id = id;
  object.intervalType =
      _AppSettingsintervalTypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          IntervalType.fixed;
  object.isPaused = reader.readBool(offsets[6]);
  object.isRunning = reader.readBool(offsets[7]);
  object.lastFiredAltSequentialIndex = reader.readLong(offsets[8]);
  object.lastFiredFrom = _AppSettingslastFiredFromValueEnumMap[
          reader.readByteOrNull(offsets[9])] ??
      LibrarySlot.primary;
  object.lastFiredSequentialIndex = reader.readLong(offsets[10]);
  object.maxIntervalMinutes = reader.readLong(offsets[11]);
  object.minIntervalMinutes = reader.readLong(offsets[12]);
  object.primaryLibraryUid = reader.readString(offsets[13]);
  object.promptOrder =
      _AppSettingspromptOrderValueEnumMap[reader.readByteOrNull(offsets[14])] ??
          PromptOrder.random;
  object.selectedChime = reader.readString(offsets[15]);
  object.selectedVoiceName = reader.readString(offsets[16]);
  object.sequenceGapSeconds = reader.readLong(offsets[17]);
  object.sequenceTimerMinutes = reader.readLong(offsets[18]);
  object.sequenceTrigger = _AppSettingssequenceTriggerValueEnumMap[
          reader.readByteOrNull(offsets[19])] ??
      SequenceTrigger.onDemand;
  object.speechPitch = reader.readDouble(offsets[20]);
  object.speechRate = reader.readDouble(offsets[21]);
  object.visualMode =
      _AppSettingsvisualModeValueEnumMap[reader.readByteOrNull(offsets[22])] ??
          VisualMode.day;
  return object;
}

P _appSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (_AppSettingsaudioModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AudioMode.silent) as P;
    case 3:
      return (_AppSettingsdeliveryModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DeliveryMode.free) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_AppSettingsintervalTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          IntervalType.fixed) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (_AppSettingslastFiredFromValueEnumMap[
              reader.readByteOrNull(offset)] ??
          LibrarySlot.primary) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (_AppSettingspromptOrderValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PromptOrder.random) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (_AppSettingssequenceTriggerValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SequenceTrigger.onDemand) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (_AppSettingsvisualModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          VisualMode.day) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppSettingsaudioModeEnumValueMap = {
  'silent': 0,
  'tone': 1,
  'voice': 2,
  'toneAndVoice': 3,
};
const _AppSettingsaudioModeValueEnumMap = {
  0: AudioMode.silent,
  1: AudioMode.tone,
  2: AudioMode.voice,
  3: AudioMode.toneAndVoice,
};
const _AppSettingsdeliveryModeEnumValueMap = {
  'free': 0,
  'sequence': 1,
};
const _AppSettingsdeliveryModeValueEnumMap = {
  0: DeliveryMode.free,
  1: DeliveryMode.sequence,
};
const _AppSettingsintervalTypeEnumValueMap = {
  'fixed': 0,
  'random': 1,
};
const _AppSettingsintervalTypeValueEnumMap = {
  0: IntervalType.fixed,
  1: IntervalType.random,
};
const _AppSettingslastFiredFromEnumValueMap = {
  'primary': 0,
  'alternate': 1,
};
const _AppSettingslastFiredFromValueEnumMap = {
  0: LibrarySlot.primary,
  1: LibrarySlot.alternate,
};
const _AppSettingspromptOrderEnumValueMap = {
  'random': 0,
  'sequential': 1,
};
const _AppSettingspromptOrderValueEnumMap = {
  0: PromptOrder.random,
  1: PromptOrder.sequential,
};
const _AppSettingssequenceTriggerEnumValueMap = {
  'onDemand': 0,
  'timer': 1,
};
const _AppSettingssequenceTriggerValueEnumMap = {
  0: SequenceTrigger.onDemand,
  1: SequenceTrigger.timer,
};
const _AppSettingsvisualModeEnumValueMap = {
  'day': 0,
  'night': 1,
};
const _AppSettingsvisualModeValueEnumMap = {
  0: VisualMode.day,
  1: VisualMode.night,
};

Id _appSettingsGetId(AppSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsGetLinks(AppSettings object) {
  return [];
}

void _appSettingsAttach(
    IsarCollection<dynamic> col, Id id, AppSettings object) {
  object.id = id;
}

extension AppSettingsQueryWhereSort
    on QueryBuilder<AppSettings, AppSettings, QWhere> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsQueryWhere
    on QueryBuilder<AppSettings, AppSettings, QWhereClause> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppSettingsQueryFilter
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {
  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeSequenceUid',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeSequenceUid',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeSequenceUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeSequenceUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeSequenceUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeSequenceUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      activeSequenceUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeSequenceUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alternateLibraryUid',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alternateLibraryUid',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alternateLibraryUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alternateLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alternateLibraryUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alternateLibraryUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      alternateLibraryUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alternateLibraryUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      audioModeEqualTo(AudioMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      audioModeGreaterThan(
    AudioMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      audioModeLessThan(
    AudioMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      audioModeBetween(
    AudioMode lower,
    AudioMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      deliveryModeEqualTo(DeliveryMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      deliveryModeGreaterThan(
    DeliveryMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      deliveryModeLessThan(
    DeliveryMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      deliveryModeBetween(
    DeliveryMode lower,
    DeliveryMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fixedIntervalSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fixedIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fixedIntervalSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fixedIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fixedIntervalSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fixedIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fixedIntervalSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fixedIntervalSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      intervalTypeEqualTo(IntervalType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalType',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      intervalTypeGreaterThan(
    IntervalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalType',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      intervalTypeLessThan(
    IntervalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalType',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      intervalTypeBetween(
    IntervalType lower,
    IntervalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> isPausedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaused',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      isRunningEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRunning',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredAltSequentialIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFiredAltSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredAltSequentialIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFiredAltSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredAltSequentialIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFiredAltSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredAltSequentialIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFiredAltSequentialIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredFromEqualTo(LibrarySlot value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFiredFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredFromGreaterThan(
    LibrarySlot value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFiredFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredFromLessThan(
    LibrarySlot value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFiredFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredFromBetween(
    LibrarySlot lower,
    LibrarySlot upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFiredFrom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredSequentialIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFiredSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredSequentialIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFiredSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredSequentialIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFiredSequentialIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lastFiredSequentialIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFiredSequentialIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      maxIntervalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      maxIntervalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      maxIntervalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      maxIntervalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxIntervalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      minIntervalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      minIntervalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      minIntervalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minIntervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      minIntervalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minIntervalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryLibraryUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryLibraryUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryLibraryUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryLibraryUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      primaryLibraryUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryLibraryUid',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      promptOrderEqualTo(PromptOrder value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      promptOrderGreaterThan(
    PromptOrder value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promptOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      promptOrderLessThan(
    PromptOrder value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promptOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      promptOrderBetween(
    PromptOrder lower,
    PromptOrder upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promptOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedChime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedChime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedChime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChime',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedChimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedChime',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedVoiceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedVoiceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedVoiceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedVoiceName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      selectedVoiceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedVoiceName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceGapSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceGapSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceGapSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceGapSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceGapSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceGapSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceGapSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceGapSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTimerMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceTimerMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTimerMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceTimerMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTimerMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceTimerMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTimerMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceTimerMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTriggerEqualTo(SequenceTrigger value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceTrigger',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTriggerGreaterThan(
    SequenceTrigger value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceTrigger',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTriggerLessThan(
    SequenceTrigger value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceTrigger',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      sequenceTriggerBetween(
    SequenceTrigger lower,
    SequenceTrigger upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceTrigger',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechPitchEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speechPitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechPitchGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speechPitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechPitchLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speechPitch',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechPitchBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speechPitch',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speechRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speechRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speechRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      speechRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speechRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      visualModeEqualTo(VisualMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visualMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      visualModeGreaterThan(
    VisualMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visualMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      visualModeLessThan(
    VisualMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visualMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      visualModeBetween(
    VisualMode lower,
    VisualMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visualMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppSettingsQueryObject
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQueryLinks
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQuerySortBy
    on QueryBuilder<AppSettings, AppSettings, QSortBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByActiveSequenceUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSequenceUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByActiveSequenceUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSequenceUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByAlternateLibraryUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alternateLibraryUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByAlternateLibraryUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alternateLibraryUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByAudioMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByAudioModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByDeliveryMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDeliveryModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByFixedIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByFixedIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIntervalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalType', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByIntervalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalType', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLastFiredAltSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredAltSequentialIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLastFiredAltSequentialIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredAltSequentialIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLastFiredFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredFrom', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLastFiredFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredFrom', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLastFiredSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredSequentialIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLastFiredSequentialIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredSequentialIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMaxIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMaxIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxIntervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMinIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByMinIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minIntervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByPrimaryLibraryUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryLibraryUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByPrimaryLibraryUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryLibraryUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByPromptOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptOrder', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByPromptOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptOrder', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySelectedChime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedChime', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySelectedChimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedChime', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySelectedVoiceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedVoiceName', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySelectedVoiceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedVoiceName', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySequenceGapSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceGapSeconds', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySequenceGapSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceGapSeconds', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySequenceTimerMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTimerMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySequenceTimerMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTimerMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySequenceTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTrigger', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySequenceTriggerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTrigger', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySpeechPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechPitch', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySpeechPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechPitch', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechRate', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySpeechRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechRate', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByVisualMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByVisualModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualMode', Sort.desc);
    });
  }
}

extension AppSettingsQuerySortThenBy
    on QueryBuilder<AppSettings, AppSettings, QSortThenBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByActiveSequenceUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSequenceUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByActiveSequenceUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSequenceUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByAlternateLibraryUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alternateLibraryUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByAlternateLibraryUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alternateLibraryUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByAudioMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByAudioModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByDeliveryMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDeliveryModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByFixedIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByFixedIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIntervalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalType', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByIntervalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalType', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRunning', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLastFiredAltSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredAltSequentialIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLastFiredAltSequentialIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredAltSequentialIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLastFiredFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredFrom', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLastFiredFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredFrom', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLastFiredSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredSequentialIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLastFiredSequentialIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFiredSequentialIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMaxIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMaxIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxIntervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMinIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minIntervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByMinIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minIntervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByPrimaryLibraryUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryLibraryUid', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByPrimaryLibraryUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryLibraryUid', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByPromptOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptOrder', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByPromptOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptOrder', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySelectedChime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedChime', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySelectedChimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedChime', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySelectedVoiceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedVoiceName', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySelectedVoiceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedVoiceName', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySequenceGapSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceGapSeconds', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySequenceGapSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceGapSeconds', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySequenceTimerMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTimerMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySequenceTimerMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTimerMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySequenceTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTrigger', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySequenceTriggerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceTrigger', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySpeechPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechPitch', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySpeechPitchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechPitch', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechRate', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySpeechRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speechRate', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByVisualMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByVisualModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualMode', Sort.desc);
    });
  }
}

extension AppSettingsQueryWhereDistinct
    on QueryBuilder<AppSettings, AppSettings, QDistinct> {
  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByActiveSequenceUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeSequenceUid',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByAlternateLibraryUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alternateLibraryUid',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByAudioMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioMode');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByDeliveryMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryMode');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByFixedIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fixedIntervalSeconds');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByIntervalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalType');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaused');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByIsRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRunning');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByLastFiredAltSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFiredAltSequentialIndex');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLastFiredFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFiredFrom');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByLastFiredSequentialIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFiredSequentialIndex');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByMaxIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxIntervalMinutes');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByMinIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minIntervalMinutes');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByPrimaryLibraryUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryLibraryUid',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByPromptOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promptOrder');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctBySelectedChime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedChime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctBySelectedVoiceName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedVoiceName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctBySequenceGapSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceGapSeconds');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctBySequenceTimerMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceTimerMinutes');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctBySequenceTrigger() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceTrigger');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctBySpeechPitch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speechPitch');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctBySpeechRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speechRate');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByVisualMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visualMode');
    });
  }
}

extension AppSettingsQueryProperty
    on QueryBuilder<AppSettings, AppSettings, QQueryProperty> {
  QueryBuilder<AppSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations>
      activeSequenceUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeSequenceUid');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations>
      alternateLibraryUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alternateLibraryUid');
    });
  }

  QueryBuilder<AppSettings, AudioMode, QQueryOperations> audioModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioMode');
    });
  }

  QueryBuilder<AppSettings, DeliveryMode, QQueryOperations>
      deliveryModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryMode');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      fixedIntervalSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fixedIntervalSeconds');
    });
  }

  QueryBuilder<AppSettings, IntervalType, QQueryOperations>
      intervalTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalType');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> isPausedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaused');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> isRunningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRunning');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      lastFiredAltSequentialIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFiredAltSequentialIndex');
    });
  }

  QueryBuilder<AppSettings, LibrarySlot, QQueryOperations>
      lastFiredFromProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFiredFrom');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      lastFiredSequentialIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFiredSequentialIndex');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      maxIntervalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxIntervalMinutes');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      minIntervalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minIntervalMinutes');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations>
      primaryLibraryUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryLibraryUid');
    });
  }

  QueryBuilder<AppSettings, PromptOrder, QQueryOperations>
      promptOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promptOrder');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> selectedChimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedChime');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations>
      selectedVoiceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedVoiceName');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      sequenceGapSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceGapSeconds');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
      sequenceTimerMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceTimerMinutes');
    });
  }

  QueryBuilder<AppSettings, SequenceTrigger, QQueryOperations>
      sequenceTriggerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceTrigger');
    });
  }

  QueryBuilder<AppSettings, double, QQueryOperations> speechPitchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speechPitch');
    });
  }

  QueryBuilder<AppSettings, double, QQueryOperations> speechRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speechRate');
    });
  }

  QueryBuilder<AppSettings, VisualMode, QQueryOperations> visualModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visualMode');
    });
  }
}
