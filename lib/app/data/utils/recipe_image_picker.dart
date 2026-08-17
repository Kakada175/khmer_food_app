import 'recipe_image_picker_stub.dart'
    if (dart.library.html) 'recipe_image_picker_web.dart'
    if (dart.library.io) 'recipe_image_picker_mobile.dart';

Future<String?> pickImage() {
  return pickRecipeImage();
}
