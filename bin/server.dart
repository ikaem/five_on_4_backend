// import 'dart:io';
// import 'package:drift_postgres/drift_postgres.dart';
// import 'package:postgres/postgres.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:stormberry/stormberry.dart';

// void main(List<String> args) async {
//   // // db - stormberry
//   // final db = Database(
//   //   host: "ep-dry-violet-63420544-pooler.eu-central-1.aws.neon.tech",
//   //   database: "fiveonfour",
//   //   password: "dERmDq6CilZ1",
//   //   username: "marinovic.karlo",
//   // );

//   // final res = await db.authors.queryAuthors();

//   // ////////////////
//   // db - drift
//   final pgDatabase = PgDatabase(
//     endpoint: Endpoint(
//       host: "ep-dry-violet-63420544-pooler.eu-central-1.aws.neon.tech",
//       database: "fiveonfour",
//       password: "dERmDq6CilZ1",
//       username: "marinovic.karlo",
//     ),
//     settings: ConnectionSettings(
//       // If you expect to talk to a Postgres database over a public connection,
//       // please use SslMode.verifyFull instead.
//       // sslMode: SslMode.disable,
//       sslMode: SslMode.require,

//       onOpen: (connection) async {
//         print("Connected!");
//       },
//     ),
//   );

//   // final driftDatabase = MyDatabase(pgDatabase);
//   // final driftDatabase = MyDatabase(pgDatabase);

//   // TODO needed to actually connect immediately and do the migrations
//   // final currentTimestamp = await driftDatabase.current_timestamp().get();

//   // print("currentTimestamp: $currentTimestamp");

//   // await driftDatabase.somethingElse.all().get();

//   // driftDatabase.

//   // await driftDatabase.users.insertOne(UsersCompanion(
//   //   name: Value("Karlo"),
//   //   birthDate: Value(DateTime.now()),
//   // ));

//   // router

//   Response rootHandler(Request req) {
//     return Response.ok('Hello, World!\n');
//   }

//   Response echoHandler(Request request) {
//     final message = request.params['message'];
//     return Response.ok('$message\n');
//   }

// // Configure routes.
//   final router = Router()
//     ..get('/', rootHandler)
//     ..get('/echo/<message>', echoHandler);

//   //
//   // Use any available host or container IP (usually `0.0.0.0`).
//   final ip = InternetAddress.anyIPv4;

//   // Configure a pipeline that logs requests.
//   final handler =
//       Pipeline().addMiddleware(logRequests()).addHandler(router.call);

//   // For running in containers, we respect the PORT environment variable.
//   final port = int.parse(Platform.environment['PORT'] ?? '8080');
//   final server = await serve(handler, ip, port);
//   print('Server listening on port ${server.port}');
// }

// /* 

// PGHOST='ep-dry-violet-63420544-pooler.eu-central-1.aws.neon.tech'
// PGDATABASE='fiveonfour'
// PGUSER='marinovic.karlo'
// PGPASSWORD='dERmDq6CilZ1'


//  */
