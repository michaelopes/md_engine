import 'dart:io';
import 'package:args/args.dart';

class AssetsCommandsRunner {
  static Future<void> run(List<String> args) async {
    final parser = ArgParser()
      ..addOption(
        'icons',
        abbr: 'i',
        help: 'Diretório de ícones',
        defaultsTo: "assets/icons/",
      )
      ..addOption(
        'images',
        abbr: 'm',
        help: 'Diretório de imagens',
        defaultsTo: "assets/images/",
      )
      ..addOption(
        'animations',
        abbr: 'a',
        help: 'Diretório de animações',
        defaultsTo: "assets/animations/",
      );

    final argResults = parser.parse(args);

    // Pega os diretórios passados como argumentos
    final iconsDir = argResults['icons'];
    final imagesDir = argResults['images'];
    final animationsDir = argResults['animations'];

    if (iconsDir != null) {
      _generateAssetsClass(
        iconsDir,
        'MdIcons',
        'lib/generated/md_icons.dart',
      );
    }

    if (imagesDir != null) {
      _generateAssetsClass(
        imagesDir,
        'MdImages',
        'lib/generated/md_images.dart',
      );
    }

    if (animationsDir != null) {
      _generateAssetsClass(
        animationsDir,
        'MdAnimations',
        'lib/generated/md_animations.dart',
      );
    }
  }

  static void _generateAssetsClass(
      String assetsDirectory, String className, String outputFile) {
    final dir = Directory(assetsDirectory);
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('Directory "$assetsDirectory" as not found.');

      return;
    }

    // Coleta os assets no diretório
    final assets = <String>[];
    for (final file in dir.listSync(recursive: true)) {
      if (file is File) {
        final relativePath = file.path.replaceAll('\\', '/');
        assets.add(relativePath);
      }
    }

    // Gera a classe com os caminhos dos assets
    final buffer = StringBuffer();

    buffer.writeln("// ignore: unused_import");
    buffer.writeln("import 'package:md_engine/md_engine.dart';");

    buffer.writeln('class $className {');

    for (final asset in assets) {
      final fileName = asset.split('/').last;
      final slp = fileName.split(".");
      final assetName = _snakeCaseToCamelCase(slp.first);
      final ext = slp.last.toLowerCase();

      if (className == "MdIcons") {
        if (ext == "svg" || ext == "png") {
          buffer.writeln(
              '  static const MdAssetIcon $assetName = MdAssetIcon(fileName: \'$asset\');');
        }
      } else if (className == "MdImages") {
        if (ext == "jpeg" || ext == "jpg" || ext == "png") {
          buffer.writeln(
              '  static const MdAssetImage $assetName = MdAssetImage(fileName: \'$asset\');');
        }
      } else if (className == "MdAnimations") {
        if (ext == "json") {
          buffer.writeln(
              '  static const MdAssetAnimation $assetName = MdAssetAnimation(fileName: \'$asset\');');
        }
      }
    }

    buffer.writeln('}');

    // Cria o arquivo de saída
    final outputFileObj = File(outputFile);
    outputFileObj.createSync(recursive: true);
    outputFileObj.writeAsStringSync(buffer.toString());

    // ignore: avoid_print
    print('Class $className succesful in $outputFile');
  }

  static String _snakeCaseToCamelCase(String input) {
    List<String> parts = input.split('_');
    String camelCase = '';
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (i == 0) {
        camelCase += part;
      } else {
        camelCase += part[0].toUpperCase() + part.substring(1);
      }
    }
    return camelCase;
  }
}
