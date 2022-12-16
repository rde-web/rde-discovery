import 'dart:async';
import 'package:leto_schema/leto_schema.dart';
import 'package:rde_discovery/config_ref.dart';

part 'schema.g.dart';

@GraphQLObject()
class Config {
  final String commutator;
  final int bufferSize;

  const Config(this.commutator, this.bufferSize);
}

@Query()
Config? getConfig(Ctx ctx) {
  return ref.get(ctx).value;
}

class ConfigController {
  Config? _value;
  Config? get value => _value;

  final _streamController = StreamController<Config>.broadcast();
  Stream<Config> get stream => _streamController.stream;

  ConfigController(this._value);

  void setValue(Config newValue) {
    _value = newValue;
    _streamController.add(newValue);
  }
}
