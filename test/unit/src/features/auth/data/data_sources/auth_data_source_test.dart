import 'package:drift/drift.dart' hide isNull;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/data/data_sources/auth_data_source.dart';
import '../../../../../../../bin/src/features/auth/data/data_sources/auth_data_source_impl.dart';
import '../../../../../../../bin/src/features/auth/domain/values/new_auth_data_value.dart';
import '../../../../../../../bin/src/features/auth/utils/constants/auth_type_constants.dart';
import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/wrappers/libraries/crypt/crypt_wrapper.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';
import '../../../../../../helpers/database/test_database.dart';

Future<void> main() async {
  // final cryptWrapper = _MockCryptWrapper();
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late AuthDataSource authDataSource;

  setUp(() async {
    testDatabaseWrapper = await getTestMemoryDatabaseWrapper();

    authDataSource = AuthDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
      // cryptWrapper: cryptWrapper,
    );
  });

  setUp(() {
    // when(() => cryptWrapper.getHashedValue(value: any(named: "password")))
    //     .thenReturn("hashedPassword");
  });

  tearDown(() async {
    // reset(cryptWrapper);
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group("$AuthDataSource", () {
    group(".createAuth()", () {
      final dataValueGoogle = NewAuthDataValueGoogle(
        // createdAt: DateTime.now().normalizedToSeconds,
        email: "email",
        firstName: "firstName",
        lastName: "lastName",
        nickname: "nickname",
        // updatedAt: DateTime.now().normalizedToSeconds,
      );

      test(
        "given a NewAuthDataValueGoogle "
        "when .createAuth() is called "
        "then should create expected auth in db",
        () async {
          // setup

          // given

          // when
          final authId =
              await authDataSource.createAuth(authValue: dataValueGoogle);

          // then
          final select = testDatabaseWrapper.databaseWrapper.authRepo.select();
          final findAuth = select..where((tbl) => tbl.id.equals(authId));
          final auth = await findAuth.getSingleOrNull();

          // expect
          final expectedAuth = AuthEntityData(
            id: authId,
            email: dataValueGoogle.email,
            password: null,
            authType: AuthTypeConstants.google.name,
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
            // createdAt: dataValueGoogle.createdAt,
            // updatedAt: dataValueGoogle.updatedAt,
          );
          expect(auth, equals(expectedAuth));

          // cleanup
        },
      );

      test(
        "given a NewAuthDataValueGoogle "
        "when .createAuth() is called "
        "then should create expected Player entity in db",
        () async {
          // setup

          // given

          // when
          final authId =
              await authDataSource.createAuth(authValue: dataValueGoogle);

          // then
          final select =
              testDatabaseWrapper.databaseWrapper.playersRepo.select();
          final findPlayer = select..where((tbl) => tbl.authId.equals(authId));
          final player = await findPlayer.getSingleOrNull();

          // expect
          expect(player, isNot(null));

          final expectedPlayer = PlayerEntityData(
            id: player!.id,
            authId: authId,
            firstName: dataValueGoogle.firstName,
            lastName: dataValueGoogle.lastName,
            nickname: dataValueGoogle.nickname,
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
            // createdAt: dataValueGoogle.createdAt,
            // updatedAt: dataValueGoogle.updatedAt,
            teamId: null,
          );

          expect(player, equals(expectedPlayer));

          // cleanup
        },
      );
      // when email and password auth is created
    });

    group(".getAuthByEmailAndHashedPassword", () {
      test(
        "given auth does NOT exist in db"
        "when .getAuthByEmailAndHashedPassword() is called with valid email and password"
        "then should return null",
        () async {
          // setup
          final email = testAuthCompanion.email.value;
          final hashedPassword = testAuthCompanion.password.value;

          // given

          // when
          final auth = await authDataSource.getAuthByEmailAndHashedPassword(
            email: email,
            hashedPassword: hashedPassword!,
          );

          // then
          expect(
            auth,
            isNull,
          );

          // cleanup
        },
      );

      test(
        "given auth exists in db"
        "when .getAuthByEmailAndHashedPassword() is called with valid email and password"
        "then should return expected auth",
        () async {
          // setup
          final email = testAuthCompanion.email.value;
          final hashedPassword = testAuthCompanion.password.value;

          // given
          await testDatabaseWrapper.databaseWrapper.authRepo
              .insertOne(testAuthCompanion);

          // when
          final auth = await authDataSource.getAuthByEmailAndHashedPassword(
            email: email,
            hashedPassword: hashedPassword!,
          );

          // then
          expect(
            auth,
            equals(testAuthEntityData),
          );

          // cleanup
        },
      );
    });

    group(".getAuthByEmail()", () {
      test(
        "given auth exists in db "
        "when .getAuthByEmail() is called with valid email"
        "then should return expected auth",
        () async {
          // setup
          final email = testAuthCompanion.email.value;

          await testDatabaseWrapper.databaseWrapper.authRepo
              .insertOne(testAuthCompanion);

          // when
          final auth = await authDataSource.getAuthByEmail(email: email);

          // then
          expect(
            auth,
            equals(testAuthEntityData),
          );

          // cleanup
        },
      );

      test(
        "given auth does not exist in db "
        "when .getAuthByEmail() is called with invalid email"
        "then should return null",
        () async {
          // setup
          final email = "email";

          // given

          // when
          final auth = await authDataSource.getAuthByEmail(email: email);

          // then
          expect(auth, equals(null));

          // cleanup
        },
      );
    });

    group(".getAuthById()", () {
      test(
        "given invalid authId "
        "when .getAuthById() is called "
        "then should return null",
        () async {
          // setup

          // given
          final authId = 1;

          // when
          final auth = await authDataSource.getAuthById(id: authId);

          // then
          expect(auth, isNull);

          // cleanup
        },
      );

      test(
        "given valid authId "
        "when .getAuthById() is called "
        "then should return expected auth",
        () async {
          // setup
          await testDatabaseWrapper.databaseWrapper.authRepo
              .insertOne(testAuthCompanion);

          // given
          final authId = testAuthCompanion.id.value;

          // when
          final auth = await authDataSource.getAuthById(id: authId);

          // then
          expect(auth, equals(testAuthEntityData));

          // cleanup
        },
      );
    });
  });
}

class _MockCryptWrapper extends Mock implements CryptWrapper {}

final testAuthCompanion = AuthEntityCompanion.insert(
  id: Value(1),
  email: "email",
  password: Value("password"),
  authType: AuthTypeConstants.emailPassword.name,
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
);

final testAuthEntityData = AuthEntityData(
  id: testAuthCompanion.id.value,
  email: testAuthCompanion.email.value,
  password: testAuthCompanion.password.value,
  authType: testAuthCompanion.authType.value,
  createdAt: testAuthCompanion.createdAt.value,
  updatedAt: testAuthCompanion.updatedAt.value,
);
