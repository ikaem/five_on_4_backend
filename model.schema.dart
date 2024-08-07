// ignore_for_file: annotate_overrides

part of 'model.dart';

extension ModelRepositories on Session {
  AuthorRepository get authors => AuthorRepository._(this);
  BookRepository get books => BookRepository._(this);
}

abstract class AuthorRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<AuthorInsertRequest>,
        ModelRepositoryUpdate<AuthorUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory AuthorRepository._(Session db) = _AuthorRepository;

  Future<AuthorView?> queryAuthor(int id);
  Future<List<AuthorView>> queryAuthors([QueryParams? params]);
}

class _AuthorRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<AuthorInsertRequest>,
        RepositoryUpdateMixin<AuthorUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements AuthorRepository {
  _AuthorRepository(super.db) : super(tableName: 'authors', keyName: 'id');

  @override
  Future<AuthorView?> queryAuthor(int id) {
    return queryOne(id, AuthorViewQueryable());
  }

  @override
  Future<List<AuthorView>> queryAuthors([QueryParams? params]) {
    return queryMany(AuthorViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<AuthorInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named('INSERT INTO "authors" ( "name" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.name)}:text )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<AuthorUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "authors"\n'
          'SET "name" = COALESCE(UPDATED."name", "authors"."name")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.name)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "name")\n'
          'WHERE "authors"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

abstract class BookRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<BookInsertRequest>,
        ModelRepositoryUpdate<BookUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory BookRepository._(Session db) = _BookRepository;

  Future<BookView?> queryBook(String id);
  Future<List<BookView>> queryBooks([QueryParams? params]);
}

class _BookRepository extends BaseRepository
    with
        RepositoryInsertMixin<BookInsertRequest>,
        RepositoryUpdateMixin<BookUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements BookRepository {
  _BookRepository(super.db) : super(tableName: 'books', keyName: 'id');

  @override
  Future<BookView?> queryBook(String id) {
    return queryOne(id, BookViewQueryable());
  }

  @override
  Future<List<BookView>> queryBooks([QueryParams? params]) {
    return queryMany(BookViewQueryable(), params);
  }

  @override
  Future<void> insert(List<BookInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('INSERT INTO "books" ( "id", "title", "author_id" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.title)}:text, ${values.add(r.authorId)}:int8 )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<BookUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "books"\n'
          'SET "title" = COALESCE(UPDATED."title", "books"."title"), "author_id" = COALESCE(UPDATED."author_id", "books"."author_id")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.title)}:text::text, ${values.add(r.authorId)}:int8::int8 )').join(', ')} )\n'
          'AS UPDATED("id", "title", "author_id")\n'
          'WHERE "books"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class AuthorInsertRequest {
  AuthorInsertRequest({
    required this.name,
  });

  final String name;
}

class BookInsertRequest {
  BookInsertRequest({
    required this.id,
    required this.title,
    required this.authorId,
  });

  final String id;
  final String title;
  final int authorId;
}

class AuthorUpdateRequest {
  AuthorUpdateRequest({
    required this.id,
    this.name,
  });

  final int id;
  final String? name;
}

class BookUpdateRequest {
  BookUpdateRequest({
    required this.id,
    this.title,
    this.authorId,
  });

  final String id;
  final String? title;
  final int? authorId;
}

class AuthorViewQueryable extends KeyedViewQueryable<AuthorView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "authors".*'
      'FROM "authors"';

  @override
  String get tableAlias => 'authors';

  @override
  AuthorView decode(TypedMap map) => AuthorView(id: map.get('id'), name: map.get('name'));
}

class AuthorView {
  AuthorView({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}

class BookViewQueryable extends KeyedViewQueryable<BookView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "books".*, row_to_json("author".*) as "author"'
      'FROM "books"'
      'LEFT JOIN (${AuthorViewQueryable().query}) "author"'
      'ON "books"."author_id" = "author"."id"';

  @override
  String get tableAlias => 'books';

  @override
  BookView decode(TypedMap map) => BookView(
      id: map.get('id'),
      title: map.get('title'),
      author: map.get('author', AuthorViewQueryable().decoder));
}

class BookView {
  BookView({
    required this.id,
    required this.title,
    required this.author,
  });

  final String id;
  final String title;
  final AuthorView author;
}
