import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/comment.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/widgets/image.dart';
import 'package:timeago/timeago.dart' as timeago;

class commentItem extends StatelessWidget {
  final CommentEntity data;
  const commentItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: DarkThemeColors.secondaryTextColor,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: data.authorAvatarUrl != null
                        ? ImageLoadingService(
                            imageUrl: data.authorAvatarUrl!,
                            borderRadius: BorderRadius.circular(14),
                          )
                        : const CircleAvatar(
                            radius: 14,
                            child: Icon(CupertinoIcons.person, size: 14),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.authorUsername ?? 'Unknown',
                    style: themeData.textTheme.labelMedium,
                  ),
                ],
              ),
              Text(
                timeago.format(data.createdAt),
                style: themeData.textTheme.labelSmall!.apply(
                  color: const Color.fromARGB(144, 158, 158, 162),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(data.content, style: TextStyle(height: 1.7)),
        ],
      ),
    );
  }
}
