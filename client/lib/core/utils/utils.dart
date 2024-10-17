import 'package:client/core/constant/app_export.dart';
import 'package:client/helper/logcat.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void customSnackBar({
  required BuildContext context,
  required String msg,
  Color backgroundColor = Colors.green,
}) {
  ScaffoldMessengerState snack = ScaffoldMessenger.of(context);
  snack.hideCurrentSnackBar();
  snack.showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
    snackBarAnimationStyle: AnimationStyle(
        duration: const Duration(seconds: 1), curve: Curves.easeOutCubic),
  );
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    logCat(e.toString());
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    logCat(e.toString());
    return null;
  }
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
