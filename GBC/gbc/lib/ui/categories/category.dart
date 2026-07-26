import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/theme.dart';

class categoryItem extends StatelessWidget {
  const categoryItem({
    super.key,
    required this.categoriess,
    required this.borderRadius,
  });
  final CategoriesEntity categoriess;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: SizedBox(
          width: 80,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: DarkThemeColors.surfaceColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(categoriess.categoiresName)],
            ),
          ),
        ),
      ),
    );
  }
}
