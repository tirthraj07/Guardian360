import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart'; // Import RSA key types

class Encryption {
  static String encryptMessage(String message, String publicKeyPem) {
    // Properly format public key
    String formattedPublicKey = publicKeyPem
        .replaceAll(RegExp(r'\\n'), '\n') // Convert escaped new lines
        .replaceAll('"', '') // Remove any extra quotes
        .trim(); // Trim leading/trailing spaces

    print("Formatted Key:\n$formattedPublicKey");

    try {
      final parser = RSAKeyParser();
      final RSAPublicKey publicKey = parser.parse(formattedPublicKey) as RSAPublicKey;

      final encrypter = Encrypter(RSA(publicKey: publicKey));
      final encrypted = encrypter.encrypt(message);

      return encrypted.base16; // Return as a hex string
    } catch (e) {
      print("Encryption Error: $e");
      return "Error: Invalid Key Format";
    }
  }

}
