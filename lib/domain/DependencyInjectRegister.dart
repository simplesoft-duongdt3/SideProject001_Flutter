import 'package:kiwi/kiwi.dart' as kiwi;

abstract class DependencyInjectRegister{
  Future<void> register(kiwi.Container di);
}