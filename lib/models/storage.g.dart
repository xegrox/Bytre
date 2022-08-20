// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetStorageCollection on Isar {
  IsarCollection<Storage> get storages => getCollection();
}

const StorageSchema = CollectionSchema(
  name: 'Storage',
  schema:
      '{"name":"Storage","idName":"id","properties":[{"name":"group","type":"String"},{"name":"name","type":"String"},{"name":"repository","type":"String"}],"indexes":[{"name":"group","unique":false,"properties":[{"name":"group","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: 'id',
  propertyIds: {'group': 0, 'name': 1, 'repository': 2},
  listProperties: {},
  indexIds: {'group': 0},
  indexValueTypes: {
    'group': [
      IndexValueType.stringHash,
    ]
  },
  linkIds: {'projects': 0},
  backlinkLinkNames: {'projects': 'storage'},
  getId: _storageGetId,
  setId: _storageSetId,
  getLinks: _storageGetLinks,
  attachLinks: _storageAttachLinks,
  serializeNative: _storageSerializeNative,
  deserializeNative: _storageDeserializeNative,
  deserializePropNative: _storageDeserializePropNative,
  serializeWeb: _storageSerializeWeb,
  deserializeWeb: _storageDeserializeWeb,
  deserializePropWeb: _storageDeserializePropWeb,
  version: 3,
);

int? _storageGetId(Storage object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _storageSetId(Storage object, int id) {
  object.id = id;
}

List<IsarLinkBase> _storageGetLinks(Storage object) {
  return [object.projects];
}

const _storageStorageRepositoryConverter = StorageRepositoryConverter();

void _storageSerializeNative(
    IsarCollection<Storage> collection,
    IsarRawObject rawObj,
    Storage object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.group;
  final _group = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_group.length) as int;
  final value1 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_name.length) as int;
  final value2 = _storageStorageRepositoryConverter.toIsar(object.repository);
  final _repository = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_repository.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _group);
  writer.writeBytes(offsets[1], _name);
  writer.writeBytes(offsets[2], _repository);
}

Storage _storageDeserializeNative(IsarCollection<Storage> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Storage();
  object.group = reader.readString(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.repository = _storageStorageRepositoryConverter
      .fromIsar(reader.readString(offsets[2]));
  _storageAttachLinks(collection, id, object);
  return object;
}

P _storageDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (_storageStorageRepositoryConverter
          .fromIsar(reader.readString(offset))) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _storageSerializeWeb(
    IsarCollection<Storage> collection, Storage object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'group', object.group);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'repository',
      _storageStorageRepositoryConverter.toIsar(object.repository));
  return jsObj;
}

Storage _storageDeserializeWeb(
    IsarCollection<Storage> collection, dynamic jsObj) {
  final object = Storage();
  object.group = IsarNative.jsObjectGet(jsObj, 'group') ?? '';
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
  object.repository = _storageStorageRepositoryConverter
      .fromIsar(IsarNative.jsObjectGet(jsObj, 'repository') ?? '');
  _storageAttachLinks(collection,
      IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
  return object;
}

P _storageDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'group':
      return (IsarNative.jsObjectGet(jsObj, 'group') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'repository':
      return (_storageStorageRepositoryConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'repository') ?? '')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _storageAttachLinks(IsarCollection col, int id, Storage object) {
  object.projects.attach(col, col.isar.projects, 'projects', id);
}

extension StorageQueryWhereSort on QueryBuilder<Storage, Storage, QWhere> {
  QueryBuilder<Storage, Storage, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Storage, Storage, QAfterWhere> anyGroup() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'group'));
  }
}

extension StorageQueryWhere on QueryBuilder<Storage, Storage, QWhereClause> {
  QueryBuilder<Storage, Storage, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> groupEqualTo(String group) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'group',
      value: [group],
    ));
  }

  QueryBuilder<Storage, Storage, QAfterWhereClause> groupNotEqualTo(
      String group) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'group',
        upper: [group],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'group',
        lower: [group],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'group',
        lower: [group],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'group',
        upper: [group],
        includeUpper: false,
      ));
    }
  }
}

extension StorageQueryFilter
    on QueryBuilder<Storage, Storage, QFilterCondition> {
  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'group',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'group',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> groupMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'group',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryEqualTo(
    IStorageRepository value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryGreaterThan(
    IStorageRepository value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryLessThan(
    IStorageRepository value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryBetween(
    IStorageRepository lower,
    IStorageRepository upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'repository',
      lower: _storageStorageRepositoryConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _storageStorageRepositoryConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryStartsWith(
    IStorageRepository value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryEndsWith(
    IStorageRepository value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryContains(
      IStorageRepository value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'repository',
      value: _storageStorageRepositoryConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Storage, Storage, QAfterFilterCondition> repositoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'repository',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension StorageQueryLinks
    on QueryBuilder<Storage, Storage, QFilterCondition> {
  QueryBuilder<Storage, Storage, QAfterFilterCondition> projects(
      FilterQuery<Project> q) {
    return linkInternal(
      isar.projects,
      q,
      'projects',
    );
  }
}

extension StorageQueryWhereSortBy on QueryBuilder<Storage, Storage, QSortBy> {
  QueryBuilder<Storage, Storage, QAfterSortBy> sortByGroup() {
    return addSortByInternal('group', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByGroupDesc() {
    return addSortByInternal('group', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByRepository() {
    return addSortByInternal('repository', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> sortByRepositoryDesc() {
    return addSortByInternal('repository', Sort.desc);
  }
}

extension StorageQueryWhereSortThenBy
    on QueryBuilder<Storage, Storage, QSortThenBy> {
  QueryBuilder<Storage, Storage, QAfterSortBy> thenByGroup() {
    return addSortByInternal('group', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByGroupDesc() {
    return addSortByInternal('group', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByRepository() {
    return addSortByInternal('repository', Sort.asc);
  }

  QueryBuilder<Storage, Storage, QAfterSortBy> thenByRepositoryDesc() {
    return addSortByInternal('repository', Sort.desc);
  }
}

extension StorageQueryWhereDistinct
    on QueryBuilder<Storage, Storage, QDistinct> {
  QueryBuilder<Storage, Storage, QDistinct> distinctByGroup(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('group', caseSensitive: caseSensitive);
  }

  QueryBuilder<Storage, Storage, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Storage, Storage, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Storage, Storage, QDistinct> distinctByRepository(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('repository', caseSensitive: caseSensitive);
  }
}

extension StorageQueryProperty
    on QueryBuilder<Storage, Storage, QQueryProperty> {
  QueryBuilder<Storage, String, QQueryOperations> groupProperty() {
    return addPropertyNameInternal('group');
  }

  QueryBuilder<Storage, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Storage, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Storage, IStorageRepository, QQueryOperations>
      repositoryProperty() {
    return addPropertyNameInternal('repository');
  }
}
