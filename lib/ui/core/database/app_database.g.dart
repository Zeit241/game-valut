// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LibraryGamesTable extends LibraryGames
    with TableInfo<$LibraryGamesTable, LibraryGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releasedMeta = const VerificationMeta(
    'released',
  );
  @override
  late final GeneratedColumn<DateTime> released = GeneratedColumn<DateTime>(
    'released',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _developerMeta = const VerificationMeta(
    'developer',
  );
  @override
  late final GeneratedColumn<String> developer = GeneratedColumn<String>(
    'developer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backgroundImageMeta = const VerificationMeta(
    'backgroundImage',
  );
  @override
  late final GeneratedColumn<Uint8List> backgroundImage =
      GeneratedColumn<Uint8List>(
        'background_image',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    check: () => ComparableExpr(rating).isSmallerOrEqualValue(5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completionMeta = const VerificationMeta(
    'completion',
  );
  @override
  late final GeneratedColumn<int> completion = GeneratedColumn<int>(
    'completion',
    aliasedName,
    false,
    check: () => ComparableExpr(completion).isSmallerOrEqualValue(100),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Status, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Status>($LibraryGamesTable.$converterstatus);
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    released,
    developer,
    notes,
    backgroundImage,
    rating,
    completion,
    status,
    addedAt,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryGame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('released')) {
      context.handle(
        _releasedMeta,
        released.isAcceptableOrUnknown(data['released']!, _releasedMeta),
      );
    }
    if (data.containsKey('developer')) {
      context.handle(
        _developerMeta,
        developer.isAcceptableOrUnknown(data['developer']!, _developerMeta),
      );
    } else if (isInserting) {
      context.missing(_developerMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('background_image')) {
      context.handle(
        _backgroundImageMeta,
        backgroundImage.isAcceptableOrUnknown(
          data['background_image']!,
          _backgroundImageMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('completion')) {
      context.handle(
        _completionMeta,
        completion.isAcceptableOrUnknown(data['completion']!, _completionMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryGame(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      released: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}released'],
      ),
      developer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}developer'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      backgroundImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}background_image'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      completion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion'],
      )!,
      status: $LibraryGamesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $LibraryGamesTable createAlias(String alias) {
    return $LibraryGamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Status, String, String> $converterstatus =
      const EnumNameConverter<Status>(Status.values);
}

class LibraryGame extends DataClass implements Insertable<LibraryGame> {
  final int id;
  final String name;
  final DateTime? released;
  final String developer;
  final String notes;
  final Uint8List? backgroundImage;
  final int rating;
  final int completion;
  final Status status;
  final DateTime addedAt;
  final DateTime? endedAt;
  const LibraryGame({
    required this.id,
    required this.name,
    this.released,
    required this.developer,
    required this.notes,
    this.backgroundImage,
    required this.rating,
    required this.completion,
    required this.status,
    required this.addedAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || released != null) {
      map['released'] = Variable<DateTime>(released);
    }
    map['developer'] = Variable<String>(developer);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || backgroundImage != null) {
      map['background_image'] = Variable<Uint8List>(backgroundImage);
    }
    map['rating'] = Variable<int>(rating);
    map['completion'] = Variable<int>(completion);
    {
      map['status'] = Variable<String>(
        $LibraryGamesTable.$converterstatus.toSql(status),
      );
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  LibraryGamesCompanion toCompanion(bool nullToAbsent) {
    return LibraryGamesCompanion(
      id: Value(id),
      name: Value(name),
      released: released == null && nullToAbsent
          ? const Value.absent()
          : Value(released),
      developer: Value(developer),
      notes: Value(notes),
      backgroundImage: backgroundImage == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundImage),
      rating: Value(rating),
      completion: Value(completion),
      status: Value(status),
      addedAt: Value(addedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory LibraryGame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryGame(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      released: serializer.fromJson<DateTime?>(json['released']),
      developer: serializer.fromJson<String>(json['developer']),
      notes: serializer.fromJson<String>(json['notes']),
      backgroundImage: serializer.fromJson<Uint8List?>(json['backgroundImage']),
      rating: serializer.fromJson<int>(json['rating']),
      completion: serializer.fromJson<int>(json['completion']),
      status: $LibraryGamesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'released': serializer.toJson<DateTime?>(released),
      'developer': serializer.toJson<String>(developer),
      'notes': serializer.toJson<String>(notes),
      'backgroundImage': serializer.toJson<Uint8List?>(backgroundImage),
      'rating': serializer.toJson<int>(rating),
      'completion': serializer.toJson<int>(completion),
      'status': serializer.toJson<String>(
        $LibraryGamesTable.$converterstatus.toJson(status),
      ),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  LibraryGame copyWith({
    int? id,
    String? name,
    Value<DateTime?> released = const Value.absent(),
    String? developer,
    String? notes,
    Value<Uint8List?> backgroundImage = const Value.absent(),
    int? rating,
    int? completion,
    Status? status,
    DateTime? addedAt,
    Value<DateTime?> endedAt = const Value.absent(),
  }) => LibraryGame(
    id: id ?? this.id,
    name: name ?? this.name,
    released: released.present ? released.value : this.released,
    developer: developer ?? this.developer,
    notes: notes ?? this.notes,
    backgroundImage: backgroundImage.present
        ? backgroundImage.value
        : this.backgroundImage,
    rating: rating ?? this.rating,
    completion: completion ?? this.completion,
    status: status ?? this.status,
    addedAt: addedAt ?? this.addedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  LibraryGame copyWithCompanion(LibraryGamesCompanion data) {
    return LibraryGame(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      released: data.released.present ? data.released.value : this.released,
      developer: data.developer.present ? data.developer.value : this.developer,
      notes: data.notes.present ? data.notes.value : this.notes,
      backgroundImage: data.backgroundImage.present
          ? data.backgroundImage.value
          : this.backgroundImage,
      rating: data.rating.present ? data.rating.value : this.rating,
      completion: data.completion.present
          ? data.completion.value
          : this.completion,
      status: data.status.present ? data.status.value : this.status,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryGame(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('released: $released, ')
          ..write('developer: $developer, ')
          ..write('notes: $notes, ')
          ..write('backgroundImage: $backgroundImage, ')
          ..write('rating: $rating, ')
          ..write('completion: $completion, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    released,
    developer,
    notes,
    $driftBlobEquality.hash(backgroundImage),
    rating,
    completion,
    status,
    addedAt,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryGame &&
          other.id == this.id &&
          other.name == this.name &&
          other.released == this.released &&
          other.developer == this.developer &&
          other.notes == this.notes &&
          $driftBlobEquality.equals(
            other.backgroundImage,
            this.backgroundImage,
          ) &&
          other.rating == this.rating &&
          other.completion == this.completion &&
          other.status == this.status &&
          other.addedAt == this.addedAt &&
          other.endedAt == this.endedAt);
}

class LibraryGamesCompanion extends UpdateCompanion<LibraryGame> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> released;
  final Value<String> developer;
  final Value<String> notes;
  final Value<Uint8List?> backgroundImage;
  final Value<int> rating;
  final Value<int> completion;
  final Value<Status> status;
  final Value<DateTime> addedAt;
  final Value<DateTime?> endedAt;
  const LibraryGamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.released = const Value.absent(),
    this.developer = const Value.absent(),
    this.notes = const Value.absent(),
    this.backgroundImage = const Value.absent(),
    this.rating = const Value.absent(),
    this.completion = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
  });
  LibraryGamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.released = const Value.absent(),
    required String developer,
    required String notes,
    this.backgroundImage = const Value.absent(),
    this.rating = const Value.absent(),
    this.completion = const Value.absent(),
    required Status status,
    this.addedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
  }) : name = Value(name),
       developer = Value(developer),
       notes = Value(notes),
       status = Value(status);
  static Insertable<LibraryGame> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? released,
    Expression<String>? developer,
    Expression<String>? notes,
    Expression<Uint8List>? backgroundImage,
    Expression<int>? rating,
    Expression<int>? completion,
    Expression<String>? status,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? endedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (released != null) 'released': released,
      if (developer != null) 'developer': developer,
      if (notes != null) 'notes': notes,
      if (backgroundImage != null) 'background_image': backgroundImage,
      if (rating != null) 'rating': rating,
      if (completion != null) 'completion': completion,
      if (status != null) 'status': status,
      if (addedAt != null) 'added_at': addedAt,
      if (endedAt != null) 'ended_at': endedAt,
    });
  }

  LibraryGamesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? released,
    Value<String>? developer,
    Value<String>? notes,
    Value<Uint8List?>? backgroundImage,
    Value<int>? rating,
    Value<int>? completion,
    Value<Status>? status,
    Value<DateTime>? addedAt,
    Value<DateTime?>? endedAt,
  }) {
    return LibraryGamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      released: released ?? this.released,
      developer: developer ?? this.developer,
      notes: notes ?? this.notes,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      rating: rating ?? this.rating,
      completion: completion ?? this.completion,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (released.present) {
      map['released'] = Variable<DateTime>(released.value);
    }
    if (developer.present) {
      map['developer'] = Variable<String>(developer.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (backgroundImage.present) {
      map['background_image'] = Variable<Uint8List>(backgroundImage.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (completion.present) {
      map['completion'] = Variable<int>(completion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LibraryGamesTable.$converterstatus.toSql(status.value),
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryGamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('released: $released, ')
          ..write('developer: $developer, ')
          ..write('notes: $notes, ')
          ..write('backgroundImage: $backgroundImage, ')
          ..write('rating: $rating, ')
          ..write('completion: $completion, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LibraryGamesTable libraryGames = $LibraryGamesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [libraryGames];
}

typedef $$LibraryGamesTableCreateCompanionBuilder =
    LibraryGamesCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime?> released,
      required String developer,
      required String notes,
      Value<Uint8List?> backgroundImage,
      Value<int> rating,
      Value<int> completion,
      required Status status,
      Value<DateTime> addedAt,
      Value<DateTime?> endedAt,
    });
typedef $$LibraryGamesTableUpdateCompanionBuilder =
    LibraryGamesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> released,
      Value<String> developer,
      Value<String> notes,
      Value<Uint8List?> backgroundImage,
      Value<int> rating,
      Value<int> completion,
      Value<Status> status,
      Value<DateTime> addedAt,
      Value<DateTime?> endedAt,
    });

class $$LibraryGamesTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryGamesTable> {
  $$LibraryGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get released => $composableBuilder(
    column: $table.released,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get backgroundImage => $composableBuilder(
    column: $table.backgroundImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Status, Status, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryGamesTable> {
  $$LibraryGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get released => $composableBuilder(
    column: $table.released,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get backgroundImage => $composableBuilder(
    column: $table.backgroundImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryGamesTable> {
  $$LibraryGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get released =>
      $composableBuilder(column: $table.released, builder: (column) => column);

  GeneratedColumn<String> get developer =>
      $composableBuilder(column: $table.developer, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<Uint8List> get backgroundImage => $composableBuilder(
    column: $table.backgroundImage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Status, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$LibraryGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryGamesTable,
          LibraryGame,
          $$LibraryGamesTableFilterComposer,
          $$LibraryGamesTableOrderingComposer,
          $$LibraryGamesTableAnnotationComposer,
          $$LibraryGamesTableCreateCompanionBuilder,
          $$LibraryGamesTableUpdateCompanionBuilder,
          (
            LibraryGame,
            BaseReferences<_$AppDatabase, $LibraryGamesTable, LibraryGame>,
          ),
          LibraryGame,
          PrefetchHooks Function()
        > {
  $$LibraryGamesTableTableManager(_$AppDatabase db, $LibraryGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> released = const Value.absent(),
                Value<String> developer = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<Uint8List?> backgroundImage = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<int> completion = const Value.absent(),
                Value<Status> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
              }) => LibraryGamesCompanion(
                id: id,
                name: name,
                released: released,
                developer: developer,
                notes: notes,
                backgroundImage: backgroundImage,
                rating: rating,
                completion: completion,
                status: status,
                addedAt: addedAt,
                endedAt: endedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> released = const Value.absent(),
                required String developer,
                required String notes,
                Value<Uint8List?> backgroundImage = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<int> completion = const Value.absent(),
                required Status status,
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
              }) => LibraryGamesCompanion.insert(
                id: id,
                name: name,
                released: released,
                developer: developer,
                notes: notes,
                backgroundImage: backgroundImage,
                rating: rating,
                completion: completion,
                status: status,
                addedAt: addedAt,
                endedAt: endedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryGamesTable, LibraryGame>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LibraryGamesTable,
                    LibraryGame
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryGamesTable,
      LibraryGame,
      $$LibraryGamesTableFilterComposer,
      $$LibraryGamesTableOrderingComposer,
      $$LibraryGamesTableAnnotationComposer,
      $$LibraryGamesTableCreateCompanionBuilder,
      $$LibraryGamesTableUpdateCompanionBuilder,
      (
        LibraryGame,
        BaseReferences<_$AppDatabase, $LibraryGamesTable, LibraryGame>,
      ),
      LibraryGame,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LibraryGamesTableTableManager get libraryGames =>
      $$LibraryGamesTableTableManager(_db, _db.libraryGames);
}
