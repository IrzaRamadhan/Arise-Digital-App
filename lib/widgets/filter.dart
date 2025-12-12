import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import '../shared/theme.dart';

class CustomSearchFilter extends StatelessWidget {
  final TextEditingController searchController;
  final String hintSearch;
  final void Function(String value)? onSubmitted;
  final VoidCallback? onOpenFilter;
  final VoidCallback? onOpenSorter;
  final bool isShowFilter;
  final bool isShowSorter;
  const CustomSearchFilter({
    super.key,
    required this.searchController,
    required this.hintSearch,
    this.onSubmitted,
    this.onOpenFilter,
    this.onOpenSorter,
    this.isShowFilter = false,
    this.isShowSorter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                if (onSubmitted != null) {
                  onSubmitted!(value);
                }
              },
              style: interSmallRegular,
              decoration: InputDecoration(
                prefixIcon: Icon(Hicons.search1Bold, color: Color(0xFFF58612)),
                hintText: hintSearch,
                hintStyle: interSmallRegular.copyWith(color: Color(0xFFD7D3D3)),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
        if (isShowFilter)
          GestureDetector(
            onTap: onOpenFilter,
            child: Container(
              height: 44,
              width: 44,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEAE9EA)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Hicons.filter5Bold, color: Color(0xFFF58612)),
            ),
          ),
        if (isShowSorter)
          GestureDetector(
            onTap: onOpenSorter,
            child: Container(
              height: 44,
              width: 44,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEAE9EA)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/images/sort.png'),
            ),
          ),
      ],
    );
  }
}
