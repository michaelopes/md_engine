import 'dart:convert';
import 'dart:io';
import 'bin_utils.dart';

import 'package:args/args.dart';

class TrCommandsRunner {
  static Future<void> run(List<String> args) async {
    final nArgs = [...args];
    final parser = ArgParser()
      ..addOption(
        'tr',
        abbr: 't',
        help: 'Caminho da tradução',
        defaultsTo: "assets/i18n/pt_BR.json",
      );
    bool watch = false;
    if (nArgs.contains("-w")) {
      watch = true;
      nArgs.remove("-w");
    }
    final argResults = parser.parse(nArgs);

    String dir = "";
    void gen() {
      final file = File(argResults["tr"]);
      dir = file.parent.path;
      final jsonContent = file.readAsStringSync();
      final jsonMap = jsonDecode(jsonContent) as Map<String, dynamic>;
      final generatedCode = Generator().run(jsonMap);

      final outputFile = File('lib/generated/md_i18n.dart');
      outputFile.createSync(recursive: true);
      outputFile.writeAsStringSync(generatedCode);
      // ignore: avoid_print
      print('I18n atualizado.');
    }

    gen();
    if (watch) {
      BinUtils().watch(dir, gen);
    }
  }

  void m([Map<String, String>? params]) {}
}

class Generator {
  final mainBuffer = StringBuffer();
  void generate(Map<String, dynamic> json, {String breadcrumb = ""}) {
    final buffer = StringBuffer();
    final className =
        breadcrumb.isEmpty ? 'MdI18n' : transformString(breadcrumb);

    buffer.writeln('final class $className {');

    buffer.writeln('  final BuildContext context;');
    buffer.writeln('  $className(this.context);');

    for (final item in json.entries) {
      if (item.value is! Map) {
        String attr = item.key;
        if (attr.startsWith("_")) {
          attr = attr.replaceFirst("_", "p_");
        }
        buffer.writeln(
          '  String $attr([Map<String, String>? params]) => "$breadcrumb.${item.key}".tr(context, params: params);',
        );
      } else {
        String newBreadcrumb = breadcrumb;
        if (newBreadcrumb.isNotEmpty) {
          newBreadcrumb = "$newBreadcrumb.";
        }
        newBreadcrumb = "$newBreadcrumb${item.key}";
        final fieldClassName = transformString(newBreadcrumb);
        buffer.writeln('  late final ${item.key} = $fieldClassName(context);');
        generate(item.value, breadcrumb: newBreadcrumb);
      }
    }
    buffer.writeln('}');
    mainBuffer.writeln(buffer.toString());
  }

  String run(Map<String, dynamic> json) {
    mainBuffer.writeln("// ignore_for_file: non_constant_identifier_names");
    mainBuffer.writeln("import 'package:flutter/material.dart';");
    mainBuffer.writeln("import 'package:md_engine/md_engine.dart';");
    mainBuffer.writeln();
    mainBuffer.writeln();

    generate(json);

    mainBuffer.writeln();
    mainBuffer.writeln('final Tr =  MdI18n(MdApp.context);');
    mainBuffer.writeln();

    return mainBuffer.toString();
  }

  String transformString(String input) {
    List<String> parts = input.replaceAll('_', '.').split('.');

    for (int i = 0; i < parts.length; i++) {
      parts[i] = parts[i][0].toUpperCase() +
          (parts.isNotEmpty ? parts[i].substring(1) : "");
    }

    // Junta as partes e adiciona 'Generated' no final
    String result = "_${'Md${parts.join()}Generated'.replaceAll("_", "")}";

    return result;
  }
}
