import 'dart:io';

import 'bootstrap.dart';

void main(List<String> args) {
  // final envVarTest1 = const String.fromEnvironment('ENV_VAR_TEST1');
  // final envVarTest2 = const String.fromEnvironment('ENV_VAR_TEST2');
  final envVarTest1 = Platform.environment['PGHOST'];
  final envVarTest2 = Platform.environment['ENV_VAR_TEST2'];

  print("ENV_VAR_TEST1: $envVarTest1");
  print("ENV_VAR_TEST2: $envVarTest2");

  boostrap();
}
