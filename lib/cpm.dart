import 'package:cryptography/cryptography.dart';
import 'strings.dart';
import 'dart:convert';
import 'dart:io';

const saltLength = 32;
const nonceLength = 12;
const macLength = 16;

Future<void> createDatabase(String name, String key, { String contents = '{"version": "$version"}' }) async {
  // Initialization
  final algo = AesGcm.with256bits();

  // Generating random data
  final salt = SecretKeyData.random(length: saltLength).bytes;
  final nonce = SecretKeyData.random(length: nonceLength).bytes;

  // Creating derived key
  final argon2 = Argon2id(parallelism: 2, memory: 128 * 1024, iterations: 5, hashLength: saltLength);

  // Skey & Sbox
  final secretKey = await argon2.deriveKey(secretKey: SecretKey(utf8.encode(key)), nonce: salt);
  final secretBox = await algo.encrypt(utf8.encode(contents), secretKey: secretKey, nonce: nonce);

  // Creating file contents and writing it to the disk
  final outputFile = File(name);
  final outputData = [...salt,  ...nonce, ...secretBox.cipherText, ...secretBox.mac.bytes];
  outputFile.writeAsBytesSync(outputData);
}

Future<dynamic> decryptDatabase(String name, String key) async {
  // Initialization
  final algo = AesGcm.with256bits();

  // Retrieving salt, nonce, MAC from a file
  // File structure:
  // saltLength bytes - salt
  // nonceLength bytes - nonce
  // cipher text... (any size)
  // macLength bytes - MAC
  final file = File(name);
  final fileData = file.readAsBytesSync();
  final salt = fileData.sublist(0, saltLength);
  final nonce = fileData.sublist(saltLength, saltLength + nonceLength);
  final cipherText = fileData.sublist(saltLength + nonceLength, fileData.length - macLength);
  final mac = fileData.sublist(fileData.length - 16);

  // Restoring sbox
  final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));

  // Creating derived key
  final argon2 = Argon2id(parallelism: 2, memory: 128 * 1024, iterations: 5, hashLength: saltLength);
  final secretKey = await argon2.deriveKey(secretKey: SecretKey(utf8.encode(key)), nonce: salt);

  return jsonDecode(utf8.decode(await algo.decrypt(secretBox, secretKey: secretKey)));
}

Future<void> addEntryToDatabase(String name, String key, String dbKey, String dbValue) async {
  final db = await decryptDatabase(name, key);
  db[dbKey] = dbValue;

  final file = File(name);
  file.deleteSync();

  await createDatabase(name, key, contents: jsonEncode(db));
}

Future<void> listEntries(String name, String key) async {
  final db = await decryptDatabase(name, key);

  for (var key in db.keys) {
    if (key == 'version') {
      continue;
    }

    print(key);
  }
}

Future<void> showEntry(String name, String key, String dbKey) async {
  final db = await decryptDatabase(name, key);
  print(db[dbKey]);
}