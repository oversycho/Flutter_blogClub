import 'dart:core';

class CategoriesEntity {
  final String id;
  final String categoiresName;
  final String categoiresSlug;

  CategoriesEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      categoiresName = json['name'],
      categoiresSlug = json['slug'];
}
