class BannerEntty {
  final int id;
  final String imageUrl;
  BannerEntty.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      imageUrl = json['image'];
}
