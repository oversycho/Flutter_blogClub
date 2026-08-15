import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/post.dart';

import 'package:gbc/ui/posts/post_details.dart';
import 'package:gbc/ui/widgets/image.dart';

// ignore: camel_case_types
class postItems extends StatelessWidget {
  const postItems({super.key, required this.posts, required this.borderRadius});

  final PostEntity posts;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),

      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => PostDetailsScreen(postSlug: posts.slug),
          ),
        ),
        child: SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  height: 320,
                  child: ImageLoadingService(
                    imageUrl: posts.coverImageUrl,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    posts.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    posts.authorUsername,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
