import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:intl/intl.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../shared/theme.dart';

class CustomOutlineForm extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String placeholder;
  final bool isPassword;
  final bool isNumber;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final bool readOnly;
  final bool useTitle;
  final bool showsuffixIcon;
  final bool badgeRequired;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomOutlineForm({
    super.key,
    required this.controller,
    required this.title,
    required this.placeholder,
    this.isPassword = false,
    this.isNumber = false,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.useTitle = true,
    this.showsuffixIcon = true,
    this.badgeRequired = false,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<CustomOutlineForm> createState() => _CustomOutlineFormState();
}

class _CustomOutlineFormState extends State<CustomOutlineForm> {
  bool isShow = false;

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
        TextFormField(
          controller: widget.controller,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: widget.isPassword && !isShow,
          obscuringCharacter: '•',
          readOnly: widget.readOnly,
          keyboardType:
              widget.isNumber ? TextInputType.number : TextInputType.text,
          style: interSmallRegular,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          buildCounter:
              (_, {required currentLength, maxLength, required isFocused}) =>
                  null,
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan ${widget.title}';
                }
                return null;
              },

          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.minLines == 1 ? 0 : 16,
              horizontal: 16,
            ),
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: Color(0xFFBFBFC4))
                    : null,
            suffixIcon:
                widget.isPassword && widget.showsuffixIcon
                    ? IconButton(
                      icon: Icon(
                        isShow
                            ? SolarLinearIcons.eye
                            : SolarLinearIcons.eyeClosed,
                      ),
                      color: Color(0xFFBFBFC4),
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                    )
                    : null,
            hintText: widget.placeholder,
            hintStyle: interSmallRegular.copyWith(color: Color(0xFFD7D3D3)),
          ),
        ),
      ],
    );
  }
}

// Custom Date Form
class CustomDateForm extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController tanggalController;
  final String firstDate;
  final bool readOnly;
  final bool useTitle;
  final bool badgeRequired;

  const CustomDateForm({
    super.key,
    required this.title,
    required this.placeholder,
    required this.tanggalController,
    this.firstDate = '01/01/1950',
    this.readOnly = false,
    this.useTitle = true,
    this.badgeRequired = false,
  });

  @override
  State<CustomDateForm> createState() => _CustomDateFormState();
}

class _CustomDateFormState extends State<CustomDateForm> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    final String formattedStartDate = outputFormat.format(
      inputFormat.parse(widget.firstDate),
    );
    final DateTime firstDate = DateTime.parse(formattedStartDate);
    DateTime initialDate = DateTime.now();

    if (firstDate.isAfter(initialDate)) {
      initialDate = firstDate;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primary1,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.tanggalController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
      });
    }
  }

  @override
  void initState() {
    if (widget.tanggalController.text != '') {
      _selectedDate = DateTime.now();
      setState(() {});
    }
    super.initState();
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
        TextFormField(
          onTap: () {
            if (widget.firstDate != '' && widget.readOnly == false) {
              _selectDate(context);
            }
          },
          controller: widget.tanggalController,
          obscuringCharacter: '*',
          readOnly: true,
          style: interSmallRegular,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan ${widget.title}';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            suffixIcon: Icon(Hicons.calender2Bold, color: primary1),
            hintText: widget.placeholder,
            hintStyle: interSmallRegular.copyWith(color: Color(0xFFD7D3D3)),
          ),
        ),
      ],
    );
  }
}
