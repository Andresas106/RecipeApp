import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

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
      return Image.memory(imageBytes);
    }catch(e) {
      throw Exception("Error converting base64 String to Image Widget: $e");
    }
  }
}