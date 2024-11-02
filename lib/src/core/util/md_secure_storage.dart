import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:get_storage/get_storage.dart';

class MdSecureStorage {
  MdSecureStorage._internal();
  static final I = MdSecureStorage._internal();

  final _box = GetStorage("MdSecureStorage");

  late Encrypter encrypter;
  late IV iv;

  Future<void> init({
    required String size32EncryptKey,
    required String size16IVKey,
  }) async {
    if (size32EncryptKey.length != 32) {
      throw Exception("The 'size32EncryptKey' not contains 32 characters.");
    }

    final key = Key.fromUtf8(size32EncryptKey);
    iv = IV.fromUtf8(size16IVKey);
    encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    await GetStorage.init("MdSecureStorage");
  }

  String _encryptData(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // Função para descriptografar
  String _decryptData(String encryptedText) {
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  Future<void> write(String key, dynamic value) async {
    final json = jsonEncode(value);
    final eJson = _encryptData(json);
    await _box.write(key, eJson);
  }

  Future<dynamic> read(String key) async {
    try {
      final eJson = _box.read(key);
      if (eJson == null) return null;
      final json = _decryptData(eJson);
      return jsonDecode(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String key) async {
    await _box.remove(key);
  }
}
