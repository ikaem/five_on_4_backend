A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```
## Db for tests
1. it is setup with docker compose 
   1. made with this really quickly 
      1. https://medium.com/@jewelski/quickly-set-up-a-local-postgres-database-using-docker-5098052a4726 
2. it needs to be run each time before we run tests
   1. navigate to directory of test db
   2. run docker-compose up -d
3. with make - have to be in root of the project
   1. enter in terminal: make start_tests_db
4. first time i guess, the image needs to be created
   1. and then later, we can always just start them before tests
5. this is how to run docker compose in separate dir
   1. https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc 

## How to do db migrations
1. make sure version 1 schema exists
   1. wiuth migration 1
   2. if not, create it with maake generate_migrations_schema
2. make changes 
- add new table
- or add new column
- or change column type
- - or some such
1. increase "schemaVersion" on AppDatabase by 1
<!-- 2. run make generate --> -> maybe not this
3. run the following command
```
maake generate_migrations_schema
```
1. run the following command
```
make generate_migrations_steps
```
1. add next migration to migration_wrapper that matches your db modification. for example:
```
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // await m.addColumn(schema.users, schema.users.nickname);
        await m.createTable(schema.matchEntity);
      },
      from2To3: (m, schema) async {
        // await m.createTable(schema.somethingElse);
        await m.addColumn(schema.matchEntity, schema.matchEntity.title);
      },
    ),

```
6. run the following command
```
make generate
```


## Docs for tools
- shelf by andrea - https://codewithandrea.com/articles/build-deploy-dart-shelf-app-globe/
- add middleware to specific routes - https://codereview.stackexchange.com/questions/274183/authentication-middleware-using-dart-shelf 
- kodecode middleware - https://www.kodeco.com/31602619-building-dart-apis-with-google-cloud-run?page=4 

# TODO 
- CREATE ERROR HANDLER FOR ALL ROUTES - TO BE ABLE TO JUST THROW SPECIFIC ERROR, AND THIS ERROR HANDLER WOULD DO THAT


## Controller vs use case
- controller should pass raw data to the use case. if repo needs any Value data, use case should assemble it
  - just to make sure that use case has work to do