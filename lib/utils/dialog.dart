import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showAwesomeLibraryDialog(
  BuildContext context, {
  required String title,
  required String message,
  required DialogType dialogType,
  VoidCallback? onOk,
  bool showCancelBtn = false,
  bool autoClose = false,
  Duration autoCloseDelay = const Duration(seconds: 2),
  String okText = 'Oke',
  String cancelText = 'Batal',
}) {
  final dialog = AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.scale,
    title: title,
    desc: message,
    customHeader: Icon(
      _getIconForType(dialogType),
      size: 50,
      color: _getIconColor(dialogType),
    ),
    btnOkText: okText,
    btnCancelText: cancelText,
    btnOkOnPress: onOk,
    btnCancelOnPress: showCancelBtn ? () {} : null,
  );

  dialog.show();

  if (autoClose) {
    Future.delayed(autoCloseDelay, () {
      // ignore: use_build_context_synchronously
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop(); // Tutup dialog
        onOk?.call(); // Jalankan callback OK
      }
    });
  }
}

IconData _getIconForType(DialogType type) {
  switch (type) {
    case DialogType.success:
      return Icons.check_circle;
    case DialogType.error:
      return Icons.error;
    case DialogType.warning:
      return Icons.warning;
    case DialogType.question:
      return Icons.help;
    case DialogType.info:
      return Icons.info;
    default:
      return Icons.info_outline;
  }
}

Color _getIconColor(DialogType type) {
  switch (type) {
    case DialogType.success:
      return Colors.green;
    case DialogType.error:
      return Colors.red;
    case DialogType.warning:
      return Colors.orange;
    case DialogType.question:
      return Colors.blue;
    case DialogType.info:
      return Colors.blueGrey;
    default:
      return Colors.grey;
  }
}
