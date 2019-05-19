import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/PresentationDependencyInjectRegister.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'data/DataDependencyInjectRegister.dart';
import 'package:sentry/sentry.dart';

final SentryClient _sentry = new SentryClient(dsn: "xxx");
final kiwi.Container diResolver = kiwi.Container();
void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await setupDi();

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });
}

bool get isInDebugMode {
  // Assume you're in production mode
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

Future<void> setupDi() async {
  var diRegisters = [
    DataDependencyInjectRegister(),
    PresentationDependencyInjectRegister(),
  ];
  for (var di in diRegisters) {
    await di.register(diResolver);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Task',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SplashScreen(),
    );
  }
}
