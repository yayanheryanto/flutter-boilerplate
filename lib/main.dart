import 'package:emas/app/bootstrap.dart';
import 'package:emas/core/config/env.dart';

/// Entry point Production.
Future<void> main() => bootstrap(Environment.prod);
