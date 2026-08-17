import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

Future<String?> pickRecipeImage() async {
  try {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        final base64String = base64Encode(file.bytes!);
        return 'data:image/png;base64,$base64String';
      }
    }
  } catch (_) {}
  return null;
}
