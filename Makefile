init:
	@dart pub get
generate:
	@dart run build_runner build --delete-conflicting-outputs
build:
	@dart compile exe bin/rde_discovery.dart