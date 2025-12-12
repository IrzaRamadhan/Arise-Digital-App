import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';

import '../shared/theme.dart';

class DropdownStyles {
  /// Default decorator untuk semua DropdownSearch
  static DropDownDecoratorProps defaultDecorator({
    String hintText = 'Pilih opsi',
  }) {
    
    return DropDownDecoratorProps(
      baseStyle: interSmallRegular,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: interSmallRegular.copyWith(color: const Color(0xFFD7D3D3)),
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Default suffix icon (panah bawah/atas)
  static DropdownSuffixProps defaultSuffix() {
    return DropdownSuffixProps(
      dropdownButtonProps: DropdownButtonProps(
        iconClosed: Icon(
          SolarLinearIcons.altArrowDown,
          color: Color(0xFFBFBFC4),
        ),
        iconOpened: Icon(SolarLinearIcons.altArrowUp, color: Color(0xFFBFBFC4)),
      ),
    );
  }

  /// Default popup props (search dialog)
  static PopupProps<T> defaultPopup<T>({
    String searchHint = 'Cari...',
    bool showSearchBox = true,
    required Widget Function(BuildContext, T, bool, bool) itemBuilder,
  }) {
    return PopupProps.dialog(
      showSearchBox: showSearchBox,
      fit: FlexFit.loose,
      dialogProps: const DialogProps(backgroundColor: Colors.white),
      searchDelay: Duration.zero,
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          hintText: searchHint,
          hintStyle: interSmallRegular.copyWith(color: const Color(0xFFD7D3D3)),
          border: const OutlineInputBorder(),
        ),
      ),
      listViewProps: const ListViewProps(
        itemExtent: 40,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
      containerBuilder: (context, child) {
        if (showSearchBox) {
          return Container(height: 400, color: Colors.white, child: child);
        } else {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: child,
          );
        }
      },
      itemBuilder: itemBuilder,
    );
  }
}
