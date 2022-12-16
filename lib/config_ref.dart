import 'dart:io';

import 'package:leto_schema/leto_schema.dart';
import 'package:rde_discovery/schema.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

final ref = ScopedRef<ConfigController>.global((scope) {
  String filepath = 'config.yml';
  String? location = Platform.environment["CONFIG_LOCATION"];
  if (location != null) {
    filepath = p.join(location, filepath);
  }
  String configSrc = File(filepath).readAsStringSync();
  final YamlMap? config = loadYaml(configSrc);
  if (config == null || config.isEmpty) {
    throw "config file is empty or not valid YAML";
  }
  return ConfigController(
    Config(
      (config["commutator"] ?? "localhost:8080") as String,
      (config["bufferSize"] ?? 128) as int,
    ),
  );
});
