run_dev: 
	dart run bin/main.dart

generate: 
	dart run build_runner build --delete-conflicting-outputs

generate_clean_cache:
	dart run build_runner clean


generate_migrations:
	dart run drift_dev schema dump bin/database-drift/database.dart drift_schemas && dart run drift_dev schema steps drift_schemas bin/database-drift/schema_versions.dart


generate_migrations_schema:
	dart run drift_dev schema dump bin/src/wrappers/libraries/drift/app_database.dart bin/src/wrappers/libraries/drift/migrations/schemas

generate_migrations_steps:
	dart run drift_dev schema steps bin/src/wrappers/libraries/drift/migrations/schemas bin/src/wrappers/libraries/drift/migrations/schema_versions/schema_versions.dart


just_example_how_to_add_env_vars_to_built_app:
	flutter build appbundle --flavor production -t lib/main_production.dart --dart-define-from-file=.env