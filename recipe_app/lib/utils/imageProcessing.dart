import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageProcessing {
  static Future<String> imageFileToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    }catch(e)
    {
      throw Exception('Error converting image to Base64: $e');
    }
  }

  static Widget base64ToImageWidget(String base64String) {
    try {
      final Uint8List imageBytes = base64Decode(base64String);
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        child: Image.memory(
          imageBytes,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }catch(e) {
      throw Exception("Error converting base64 String to Image Widget: $e");
    }
  }

  static Future<File> base64ToFile(String base64String) async {
    try {
      final Uint8List imageBytes = base64Decode(base64String);

      final directory = await getTemporaryDirectory();
      final String path = '${directory.path}/image.png'; // Ruta temporal

      final File imageFile = File(path);

      await imageFile.writeAsBytes(imageBytes);

      return imageFile;
    } catch (e) {
      throw Exception("Error converting Base64 String to File: $e");
    }
  }
}