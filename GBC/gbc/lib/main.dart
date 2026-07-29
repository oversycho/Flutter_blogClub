import 'package:flutter/material.dart';

//import 'package:gbc/common/http_client.dart';
//import 'package:gbc/data/source/banner_data_source.dart';
//import 'package:gbc/data/source/categoires_data_source.dart';
//import 'package:gbc/data/source/post_data_source.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/auth/auth.dart';
import 'package:gbc/ui/home/home.dart';
import 'package:gbc/ui/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* 
  // --- TEMPORARY DEBUG CHECK ---
  final bannerDataSource = BannerRemoteDataSource(restClient);
  try {
    final banners = await bannerDataSource.getBanners();
    debugPrint('✅ Got ${banners.length} banners');
    for (final b in banners) {
      debugPrint('  - ${b.id}: ${b.imageUrl}');
    }
  } catch (e) {
    debugPrint('❌ Failed to fetch banners: $e');
  }
  //------------------------------------------
  final categoriesdatasource = CategoriesRemoteDataSource(restClient);
  try {
    final categories = await categoriesdatasource.getCategories();
    debugPrint('✅ Got ${categories.length} category');
    for (final b in categories) {
      debugPrint('  - ${b.id}: ${b.categoiresName} ');
    }
  } catch (e) {
    debugPrint('❌ Failed to fetch categories: $e');
  }
  //----------------------
  final postDataSource = PostRemoteDataSource(restClient);
  try {
    final posts = await postDataSource.getPosts();
    debugPrint('✅ Got ${posts.length} posts');
    for (final b in posts) {
      debugPrint('  - ${b.id}: ${b.title} ${b.authorUsername} ');
    }
  } catch (e) {
    debugPrint('❌ Failed to fetch posts : $e');
  }
  final commentDataSource = CommentRemoteDataSource(restClient);
  try{final comments = await commentDataSource.getComments(postId: );
    debugPrint('✅ Got ${comments.length} posts');
    for (final b in comments) {
      debugPrint('  - ${b.id}: ${b.content} ${b.postId} ');
    }}catch(e){  debugPrint('❌ Failed to fetch comments : $e');}
  // --- END DEBUG CHECK ---
 */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Store',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode
          .system, // will switch automatically later — swap to a Bloc-driven value once you wire up your theme cubit/bloc
      home: const AuthScreen(),
    );
  }
}
