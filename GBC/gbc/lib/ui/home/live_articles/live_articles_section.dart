import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/live_article.dart';
import 'package:gbc/data/repo/live_article_repository.dart';
import 'package:gbc/ui/home/live_articles/bloc/live_articles_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

/// Live gaming news pulled from an external API (NewsAPI) — separate from
/// user-written posts, refreshed every time this section builds. Wrapped
/// in its own bloc so a failure here never breaks the rest of Home.
class LiveArticlesSection extends StatelessWidget {
  const LiveArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveArticlesBloc(repository: liveArticleRepository)
        ..add(LiveArticlesStarted()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Text('Live Game News'),
          ),
          BlocBuilder<LiveArticlesBloc, LiveArticlesState>(
            builder: (context, state) {
              if (state is LiveArticlesLoading) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              if (state is LiveArticlesError) {
                return SizedBox(
                  height: 220,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.exception.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                );
              }

              final articles = (state as LiveArticlesSuccess).articles;
              if (articles.isEmpty) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: Text('No live news right now.')),
                );
              }

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: articles.length,
                  itemBuilder: (context, index) =>
                      _LiveArticleCard(article: articles[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LiveArticleCard extends StatelessWidget {
  final LiveArticleEntity article;
  const _LiveArticleCard({required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.tryParse(article.url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openArticle,
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: double.infinity,
              child: article.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: article.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: const Icon(CupertinoIcons.photo),
                      ),
                    )
                  : Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      child: const Icon(CupertinoIcons.photo),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${article.sourceName} · ${timeago.format(article.publishedAt)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
