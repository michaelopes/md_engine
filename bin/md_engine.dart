import 'dart:io';
import 'package:encrypt_env/src/command_runner.dart';
import 'assets_commands_runner.dart';

Future<void> main(List<String> args) async {
  final newArgs = [...args]
    ..remove("env")
    ..remove("assets")
    ..remove("all");

  final envArgs = [
    "gen",
    "--file-path",
    "lib/generated/",
    "--file",
    "md_environment",
    "--format",
    "cc"
  ];

  if (args.contains("env")) {
    await _flushThenExit(await EncryptEnvCommandRunner().run(envArgs));
  } else if (args.contains("assets")) {
    await AssetsCommandsRunner.run(newArgs);
  } else if (args.contains("all")) {
    await AssetsCommandsRunner.run(newArgs);
    await _flushThenExit(await EncryptEnvCommandRunner().run(envArgs));
  }
}

Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
