// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuthEntityTable extends AuthEntity
    with TableInfo<$AuthEntityTable, AuthEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authTypeMeta =
      const VerificationMeta('authType');
  @override
  late final GeneratedColumn<String> authType = GeneratedColumn<String>(
      'auth_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, password, authType, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_entity';
  @override
  VerificationContext validateIntegrity(Insertable<AuthEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('auth_type')) {
      context.handle(_authTypeMeta,
          authType.isAcceptableOrUnknown(data['auth_type']!, _authTypeMeta));
    } else if (isInserting) {
      context.missing(_authTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      authType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auth_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AuthEntityTable createAlias(String alias) {
    return $AuthEntityTable(attachedDatabase, alias);
  }
}

class AuthEntityData extends DataClass implements Insertable<AuthEntityData> {
  final int id;
  final String email;
  final String? password;
  final String authType;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AuthEntityData(
      {required this.id,
      required this.email,
      this.password,
      required this.authType,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['auth_type'] = Variable<String>(authType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AuthEntityCompanion toCompanion(bool nullToAbsent) {
    return AuthEntityCompanion(
      id: Value(id),
      email: Value(email),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      authType: Value(authType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AuthEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthEntityData(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String?>(json['password']),
      authType: serializer.fromJson<String>(json['authType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String?>(password),
      'authType': serializer.toJson<String>(authType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AuthEntityData copyWith(
          {int? id,
          String? email,
          Value<String?> password = const Value.absent(),
          String? authType,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AuthEntityData(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password.present ? password.value : this.password,
        authType: authType ?? this.authType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('AuthEntityData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('authType: $authType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, password, authType, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthEntityData &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.authType == this.authType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AuthEntityCompanion extends UpdateCompanion<AuthEntityData> {
  final Value<int> id;
  final Value<String> email;
  final Value<String?> password;
  final Value<String> authType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AuthEntityCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.authType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AuthEntityCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.password = const Value.absent(),
    required String authType,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : email = Value(email),
        authType = Value(authType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AuthEntityData> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? authType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (authType != null) 'auth_type': authType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AuthEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String?>? password,
      Value<String>? authType,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AuthEntityCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      authType: authType ?? this.authType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<String>(authType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthEntityCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('authType: $authType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TeamEntityTable extends TeamEntity
    with TableInfo<$TeamEntityTable, TeamEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_entity';
  @override
  VerificationContext validateIntegrity(Insertable<TeamEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TeamEntityTable createAlias(String alias) {
    return $TeamEntityTable(attachedDatabase, alias);
  }
}

class TeamEntityData extends DataClass implements Insertable<TeamEntityData> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TeamEntityData(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TeamEntityCompanion toCompanion(bool nullToAbsent) {
    return TeamEntityCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TeamEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamEntityData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TeamEntityData copyWith(
          {int? id,
          String? name,
          String? description,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TeamEntityData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TeamEntityData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamEntityData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TeamEntityCompanion extends UpdateCompanion<TeamEntityData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TeamEntityCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TeamEntityCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        description = Value(description),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TeamEntityData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TeamEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TeamEntityCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamEntityCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlayerEntityTable extends PlayerEntity
    with TableInfo<$PlayerEntityTable, PlayerEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _authIdMeta = const VerificationMeta('authId');
  @override
  late final GeneratedColumn<int> authId = GeneratedColumn<int>(
      'auth_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES auth_entity (id)'));
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
      'team_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES team_entity (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, firstName, lastName, nickname, createdAt, updatedAt, authId, teamId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_entity';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('auth_id')) {
      context.handle(_authIdMeta,
          authId.isAcceptableOrUnknown(data['auth_id']!, _authIdMeta));
    } else if (isInserting) {
      context.missing(_authIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(_teamIdMeta,
          teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      authId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}auth_id'])!,
      teamId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}team_id']),
    );
  }

  @override
  $PlayerEntityTable createAlias(String alias) {
    return $PlayerEntityTable(attachedDatabase, alias);
  }
}

class PlayerEntityData extends DataClass
    implements Insertable<PlayerEntityData> {
  final int id;
  final String firstName;
  final String lastName;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int authId;
  final int? teamId;
  const PlayerEntityData(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.nickname,
      required this.createdAt,
      required this.updatedAt,
      required this.authId,
      this.teamId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['nickname'] = Variable<String>(nickname);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['auth_id'] = Variable<int>(authId);
    if (!nullToAbsent || teamId != null) {
      map['team_id'] = Variable<int>(teamId);
    }
    return map;
  }

  PlayerEntityCompanion toCompanion(bool nullToAbsent) {
    return PlayerEntityCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      nickname: Value(nickname),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      authId: Value(authId),
      teamId:
          teamId == null && nullToAbsent ? const Value.absent() : Value(teamId),
    );
  }

  factory PlayerEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerEntityData(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      nickname: serializer.fromJson<String>(json['nickname']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      authId: serializer.fromJson<int>(json['authId']),
      teamId: serializer.fromJson<int?>(json['teamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'nickname': serializer.toJson<String>(nickname),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'authId': serializer.toJson<int>(authId),
      'teamId': serializer.toJson<int?>(teamId),
    };
  }

  PlayerEntityData copyWith(
          {int? id,
          String? firstName,
          String? lastName,
          String? nickname,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? authId,
          Value<int?> teamId = const Value.absent()}) =>
      PlayerEntityData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        nickname: nickname ?? this.nickname,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        authId: authId ?? this.authId,
        teamId: teamId.present ? teamId.value : this.teamId,
      );
  @override
  String toString() {
    return (StringBuffer('PlayerEntityData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('authId: $authId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, firstName, lastName, nickname, createdAt, updatedAt, authId, teamId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerEntityData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.nickname == this.nickname &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.authId == this.authId &&
          other.teamId == this.teamId);
}

class PlayerEntityCompanion extends UpdateCompanion<PlayerEntityData> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> nickname;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> authId;
  final Value<int?> teamId;
  const PlayerEntityCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nickname = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.authId = const Value.absent(),
    this.teamId = const Value.absent(),
  });
  PlayerEntityCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    required String nickname,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int authId,
    this.teamId = const Value.absent(),
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        nickname = Value(nickname),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        authId = Value(authId);
  static Insertable<PlayerEntityData> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? nickname,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? authId,
    Expression<int>? teamId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (nickname != null) 'nickname': nickname,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (authId != null) 'auth_id': authId,
      if (teamId != null) 'team_id': teamId,
    });
  }

  PlayerEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String>? nickname,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? authId,
      Value<int?>? teamId}) {
    return PlayerEntityCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authId: authId ?? this.authId,
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (authId.present) {
      map['auth_id'] = Variable<int>(authId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerEntityCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('authId: $authId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }
}

class $MatchEntityTable extends MatchEntity
    with TableInfo<$MatchEntityTable, MatchEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateAndTimeMeta =
      const VerificationMeta('dateAndTime');
  @override
  late final GeneratedColumn<DateTime> dateAndTime = GeneratedColumn<DateTime>(
      'date_and_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, dateAndTime, location, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_entity';
  @override
  VerificationContext validateIntegrity(Insertable<MatchEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date_and_time')) {
      context.handle(
          _dateAndTimeMeta,
          dateAndTime.isAcceptableOrUnknown(
              data['date_and_time']!, _dateAndTimeMeta));
    } else if (isInserting) {
      context.missing(_dateAndTimeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      dateAndTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_and_time'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MatchEntityTable createAlias(String alias) {
    return $MatchEntityTable(attachedDatabase, alias);
  }
}

class MatchEntityData extends DataClass implements Insertable<MatchEntityData> {
  final int id;
  final String title;
  final DateTime dateAndTime;
  final String location;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MatchEntityData(
      {required this.id,
      required this.title,
      required this.dateAndTime,
      required this.location,
      required this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['date_and_time'] = Variable<DateTime>(dateAndTime);
    map['location'] = Variable<String>(location);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MatchEntityCompanion toCompanion(bool nullToAbsent) {
    return MatchEntityCompanion(
      id: Value(id),
      title: Value(title),
      dateAndTime: Value(dateAndTime),
      location: Value(location),
      description: Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MatchEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchEntityData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      dateAndTime: serializer.fromJson<DateTime>(json['dateAndTime']),
      location: serializer.fromJson<String>(json['location']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'dateAndTime': serializer.toJson<DateTime>(dateAndTime),
      'location': serializer.toJson<String>(location),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MatchEntityData copyWith(
          {int? id,
          String? title,
          DateTime? dateAndTime,
          String? location,
          String? description,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MatchEntityData(
        id: id ?? this.id,
        title: title ?? this.title,
        dateAndTime: dateAndTime ?? this.dateAndTime,
        location: location ?? this.location,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('MatchEntityData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dateAndTime: $dateAndTime, ')
          ..write('location: $location, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, dateAndTime, location, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchEntityData &&
          other.id == this.id &&
          other.title == this.title &&
          other.dateAndTime == this.dateAndTime &&
          other.location == this.location &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MatchEntityCompanion extends UpdateCompanion<MatchEntityData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> dateAndTime;
  final Value<String> location;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MatchEntityCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.dateAndTime = const Value.absent(),
    this.location = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MatchEntityCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime dateAndTime,
    required String location,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : title = Value(title),
        dateAndTime = Value(dateAndTime),
        location = Value(location),
        description = Value(description),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MatchEntityData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? dateAndTime,
    Expression<String>? location,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (dateAndTime != null) 'date_and_time': dateAndTime,
      if (location != null) 'location': location,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MatchEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? dateAndTime,
      Value<String>? location,
      Value<String>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MatchEntityCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dateAndTime.present) {
      map['date_and_time'] = Variable<DateTime>(dateAndTime.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchEntityCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dateAndTime: $dateAndTime, ')
          ..write('location: $location, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlayerMatchParticipationEntityTable
    extends PlayerMatchParticipationEntity
    with
        TableInfo<$PlayerMatchParticipationEntityTable,
            PlayerMatchParticipationEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerMatchParticipationEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<PlayerMatchParticipationStatus,
      int> status = GeneratedColumn<int>('status', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true)
      .withConverter<PlayerMatchParticipationStatus>(
          $PlayerMatchParticipationEntityTable.$converterstatus);
  static const VerificationMeta _playerIdMeta =
      const VerificationMeta('playerId');
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
      'player_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES player_entity (id)'));
  static const VerificationMeta _matchIdMeta =
      const VerificationMeta('matchId');
  @override
  late final GeneratedColumn<int> matchId = GeneratedColumn<int>(
      'match_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES match_entity (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, status, playerId, matchId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_match_participation_entity';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlayerMatchParticipationEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('match_id')) {
      context.handle(_matchIdMeta,
          matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta));
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {playerId, matchId},
      ];
  @override
  PlayerMatchParticipationEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerMatchParticipationEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      status: $PlayerMatchParticipationEntityTable.$converterstatus.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      playerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_id'])!,
      matchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}match_id'])!,
    );
  }

  @override
  $PlayerMatchParticipationEntityTable createAlias(String alias) {
    return $PlayerMatchParticipationEntityTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlayerMatchParticipationStatus, int, int>
      $converterstatus =
      const EnumIndexConverter<PlayerMatchParticipationStatus>(
          PlayerMatchParticipationStatus.values);
}

class PlayerMatchParticipationEntityData extends DataClass
    implements Insertable<PlayerMatchParticipationEntityData> {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PlayerMatchParticipationStatus status;
  final int playerId;
  final int matchId;
  const PlayerMatchParticipationEntityData(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      required this.playerId,
      required this.matchId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['status'] = Variable<int>(
          $PlayerMatchParticipationEntityTable.$converterstatus.toSql(status));
    }
    map['player_id'] = Variable<int>(playerId);
    map['match_id'] = Variable<int>(matchId);
    return map;
  }

  PlayerMatchParticipationEntityCompanion toCompanion(bool nullToAbsent) {
    return PlayerMatchParticipationEntityCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      status: Value(status),
      playerId: Value(playerId),
      matchId: Value(matchId),
    );
  }

  factory PlayerMatchParticipationEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerMatchParticipationEntityData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      status: $PlayerMatchParticipationEntityTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      playerId: serializer.fromJson<int>(json['playerId']),
      matchId: serializer.fromJson<int>(json['matchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'status': serializer.toJson<int>(
          $PlayerMatchParticipationEntityTable.$converterstatus.toJson(status)),
      'playerId': serializer.toJson<int>(playerId),
      'matchId': serializer.toJson<int>(matchId),
    };
  }

  PlayerMatchParticipationEntityData copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          PlayerMatchParticipationStatus? status,
          int? playerId,
          int? matchId}) =>
      PlayerMatchParticipationEntityData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        playerId: playerId ?? this.playerId,
        matchId: matchId ?? this.matchId,
      );
  @override
  String toString() {
    return (StringBuffer('PlayerMatchParticipationEntityData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('playerId: $playerId, ')
          ..write('matchId: $matchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, status, playerId, matchId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerMatchParticipationEntityData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.status == this.status &&
          other.playerId == this.playerId &&
          other.matchId == this.matchId);
}

class PlayerMatchParticipationEntityCompanion
    extends UpdateCompanion<PlayerMatchParticipationEntityData> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<PlayerMatchParticipationStatus> status;
  final Value<int> playerId;
  final Value<int> matchId;
  const PlayerMatchParticipationEntityCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.playerId = const Value.absent(),
    this.matchId = const Value.absent(),
  });
  PlayerMatchParticipationEntityCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required PlayerMatchParticipationStatus status,
    required int playerId,
    required int matchId,
  })  : createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        status = Value(status),
        playerId = Value(playerId),
        matchId = Value(matchId);
  static Insertable<PlayerMatchParticipationEntityData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? status,
    Expression<int>? playerId,
    Expression<int>? matchId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (status != null) 'status': status,
      if (playerId != null) 'player_id': playerId,
      if (matchId != null) 'match_id': matchId,
    });
  }

  PlayerMatchParticipationEntityCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<PlayerMatchParticipationStatus>? status,
      Value<int>? playerId,
      Value<int>? matchId}) {
    return PlayerMatchParticipationEntityCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      playerId: playerId ?? this.playerId,
      matchId: matchId ?? this.matchId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>($PlayerMatchParticipationEntityTable
          .$converterstatus
          .toSql(status.value));
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<int>(matchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerMatchParticipationEntityCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('playerId: $playerId, ')
          ..write('matchId: $matchId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AuthEntityTable authEntity = $AuthEntityTable(this);
  late final $TeamEntityTable teamEntity = $TeamEntityTable(this);
  late final $PlayerEntityTable playerEntity = $PlayerEntityTable(this);
  late final $MatchEntityTable matchEntity = $MatchEntityTable(this);
  late final $PlayerMatchParticipationEntityTable
      playerMatchParticipationEntity =
      $PlayerMatchParticipationEntityTable(this);
  Selectable<String> current_timestamp() {
    return customSelect('SELECT CURRENT_TIMESTAMP AS _c0',
        variables: [],
        readsFrom: {}).map((QueryRow row) => row.read<String>('_c0'));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        authEntity,
        teamEntity,
        playerEntity,
        matchEntity,
        playerMatchParticipationEntity
      ];
}
