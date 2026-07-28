import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/posts/comment/comment_list.dart';
import 'package:gbc/ui/widgets/image.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostEntity post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width * 0.8,
            flexibleSpace: ImageLoadingService(
              imageUrl: post.coverImageUrl,
              borderRadius: BorderRadius.circular(24),
            ),
            foregroundColor: LightThemeColors.primaryTextColor,
            backgroundColor: DarkThemeColors.backgroundColor,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bookmark)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        post.excerpt,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        post.categoryName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                    decoration: BoxDecoration(
                      color: DarkThemeColors.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: ImageLoadingService(
                                      imageUrl: post.authorAvatarUrl,

                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(post.authorUsername),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.eye),
                                  Text('120k'),
                                ],
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(child: Icon(CupertinoIcons.heart)),
                                  Text('10k'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: DarkThemeColors.surfaceColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
                    width: MediaQuery.of(context).size.width,
                    child: Text(post.content),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Comments'),
                        TextButton(
                          onPressed: () {},
                          child: Text('Leave a comment'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CommentList(postId: post.id),
        ],
      ),
    );
  }
}
