import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: halve_it server');
    exit(1);
  }

  final command = arguments.first;

  switch (command) {
    case 'generate':
      print('Generating: ${arguments.skip(1).join(' ')}');
      break;
    case 'server':
      final projectName = getCurrentProjectName();
      if (projectName == null) {
        print('Cannot find pubspec.yaml in current directory.');
        exit(1);
      }

      final target = 'bin/$projectName.dart';
      if (!File(target).existsSync()) {
        print('Expected file "$target" not found.');
        exit(1);
      }

      final process = await Process.start(
        'dart',
        ['run', target, ...arguments.skip(1)],
        mode: ProcessStartMode.inheritStdio,
      );

      final exitCode = await process.exitCode;
      exit(exitCode);
    default:
      print('Unknown command: $command');
  }
  
}

String? getCurrentProjectName() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return null;

  final content = file.readAsStringSync();
  final nameMatch = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(content);
  return nameMatch?.group(1);
}