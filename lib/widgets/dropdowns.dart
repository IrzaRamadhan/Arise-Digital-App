import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../shared/theme.dart';
import '../utils/dropdown_style.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final String placeholder;
  final List<String> listItem;
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final bool useTitle;
  final bool badgeRequired;
  final String? hint;
  final bool showSearchBox;

  const CustomDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.placeholder,
    required this.listItem,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.useTitle = true,
    this.badgeRequired = false,
    this.hint,
    this.showSearchBox = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (useTitle) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: interBodySmallSemibold.copyWith(color: Colors.black),
                ),
                if (badgeRequired)
                  TextSpan(
                    text: ' *',
                    style: interBodySmallSemibold.copyWith(color: danger600),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
        DropdownSearch<String>(
          enabled: !readOnly,
          items: (filter, infiniteScrollProps) => listItem,
          selectedItem: selectedValue,
          onBeforePopupOpening: (selectedItem) async {
            FocusScope.of(context).requestFocus(FocusNode());
            return true;
          },
          decoratorProps: DropdownStyles.defaultDecorator(
            hintText: placeholder,
          ),
          suffixProps: DropdownStyles.defaultSuffix(),
          popupProps: PopupProps.dialog(
            dialogProps: DialogProps(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            showSearchBox: showSearchBox,
            searchDelay: Duration.zero,
            fit: FlexFit.loose,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: interSmallRegular.copyWith(color: Color(0xFFD7D3D3)),
                border: OutlineInputBorder(),
              ),
            ),
            listViewProps: const ListViewProps(
              itemExtent: 40,
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            itemBuilder: (context, item, isSelected, isHighlighted) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(item, style: interBodySmallRegular),
              );
            },
            emptyBuilder:
                (context, searchEntry) => const SizedBox(
                  height: 50,
                  child: Center(child: Text('Tidak ada data')),
                ),

            containerBuilder: (context, child) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: child,
              );
            },
          ),
          onChanged: onChanged,
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih $title';
                }
                return null;
              },
        ),
      ],
    );
  }
}

class CustomDropdownGeneric<T> extends StatelessWidget {
  final String title;
  final bool useTitle;
  final bool badgeRequired;
  final T? selectedItem;
  final void Function(T?) onChanged;
  final List<T> items;
  final String Function(T) itemAsString;
  final bool Function(T, T)? compareFn;
  final String hintText;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool showSearchBox;

  const CustomDropdownGeneric({
    super.key,
    required this.title,
    this.useTitle = true,
    this.badgeRequired = false,
    required this.selectedItem,
    required this.onChanged,
    required this.items,
    required this.itemAsString,
    this.compareFn,
    this.hintText = 'Pilih item',
    this.validator,
    this.enabled = true,
    this.showSearchBox = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (useTitle) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: interBodySmallSemibold.copyWith(color: Colors.black),
                ),
                if (badgeRequired)
                  TextSpan(
                    text: ' *',
                    style: interBodySmallSemibold.copyWith(color: danger600),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
        DropdownSearch<T>(
          enabled: enabled && items.isNotEmpty,
          items: (filter, _) => items,
          itemAsString: itemAsString,
          selectedItem: selectedItem,
          compareFn: compareFn,

          decoratorProps: DropdownStyles.defaultDecorator(hintText: hintText),
          suffixProps: DropdownStyles.defaultSuffix(),
          popupProps: DropdownStyles.defaultPopup<T>(
            searchHint: 'Cari...',
            showSearchBox: showSearchBox,
            itemBuilder: (context, item, isSelected, isHighlighted) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(itemAsString(item), style: interBodySmallRegular),
              );
            },
          ),
          onChanged: onChanged,
          validator:
              validator ?? (value) => value == null ? 'Pilih $title' : null,
        ),
      ],
    );
  }
}
