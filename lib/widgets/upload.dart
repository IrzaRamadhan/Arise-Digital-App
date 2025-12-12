import 'dart:io';
import 'package:arise/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

import '../shared/theme.dart';

class FilePickerFormField extends StatefulWidget {
  final BuildContext context;
  final String title;
  final String placeholder;
  final TextEditingController controllerFile;
  final TextEditingController controllerPathFile;
  final List<String> allowedExtensions;
  final int maxSizeMB;
  final bool useTitle;
  final bool badgeRequired;
  final FormFieldValidator<String>? validator;

  const FilePickerFormField({
    super.key,
    required this.context,
    required this.title,
    required this.placeholder,
    required this.controllerFile,
    required this.controllerPathFile,
    this.allowedExtensions = const ['pdf'],
    this.maxSizeMB = 3,
    this.useTitle = true,
    this.badgeRequired = false,
    this.validator,
  });

  @override
  State<FilePickerFormField> createState() => _FilePickerFormFieldState();
}

class _FilePickerFormFieldState extends State<FilePickerFormField> {
  File? selectedFile;
  String? fileSize;

  Future<void> _pickFile() async {
    final resultFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
    );

    if (resultFile == null) return;

    String fileExtension =
        extension(resultFile.files.single.name).toLowerCase();

    if (!widget.allowedExtensions
        .map((ext) => ext.toLowerCase().replaceAll('.', ''))
        .contains(fileExtension.replaceAll('.', ''))) {
      if (widget.context.mounted) {
        showCustomSnackbar(
          context: widget.context,
          message:
              'Hanya file ${widget.allowedExtensions.join(", ").toUpperCase()} yang diizinkan',
          isSuccess: false,
        );
      }
      return;
    }

    File file = File(resultFile.files.single.path!);
    int sizeInBytes = file.lengthSync();

    if (sizeInBytes > widget.maxSizeMB * 1024 * 1024) {
      if (widget.context.mounted) {
        showCustomSnackbar(
          context: widget.context,
          message: 'Ukuran file maksimal ${widget.maxSizeMB} MB',
          isSuccess: false,
        );
      }
      return;
    }

    setState(() {
      selectedFile = file;
      widget.controllerFile.text = resultFile.files.single.name;
      widget.controllerPathFile.text = file.path;
      fileSize = _formatFileSize(sizeInBytes);
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.useTitle) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.title,
                  style: interBodySmallSemibold.copyWith(color: Colors.black),
                ),
                if (widget.badgeRequired)
                  TextSpan(
                    text: ' *',
                    style: interBodySmallSemibold.copyWith(color: danger600),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: _pickFile,
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controllerFile,
              style: interSmallRegular,
              validator:
                  widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih File ${widget.title}';
                    }
                    return null;
                  },
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: interSmallRegular.copyWith(
                  color: const Color(0xFFD7D3D3),
                ),
                suffixIcon: Icon(Hicons.uploadBold, color: primary1),
              ),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }
}
