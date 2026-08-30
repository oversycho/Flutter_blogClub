import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/auth/auth.dart';
import 'package:gbc/ui/create/bloc/create_post_bloc.dart';
import 'package:gbc/ui/posts/post_details.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthInfo?>(
      valueListenable: AuthRepository.authChangeNotifier,
      builder: (context, authState, child) {
        final bool isAuthenticated =
            authState != null && authState.accessToken.isNotEmpty;

        if (!isAuthenticated) {
          return const _AuthenticationRequiredScreen();
        }

        return const _CreatePostForm();
      },
    );
  }
}

class _AuthenticationRequiredScreen extends StatelessWidget {
  const _AuthenticationRequiredScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.lock, size: 56),
              const SizedBox(height: 16),
              Text(
                'Authentication required',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'You need to log in before you can write and publish a post.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatePostForm extends StatefulWidget {
  const _CreatePostForm();

  @override
  State<_CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<_CreatePostForm> {
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _coverImageController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleController.clear();
    _excerptController.clear();
    _contentController.clear();
    _coverImageController.clear();
    setState(() => _selectedCategoryId = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(
        postRepository: postRepository,
        categoriesRepository: categoriesRepository,
      )..add(CreatePostStarted()),
      child: BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            _resetForm();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: const Text('Post published!'),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            PostDetailsScreen(postSlug: state.post.slug),
                      ),
                    );
                  },
                ),
              ),
            );
            // Re-open a fresh form for writing another post, rather than
            // getting stuck on the success state.
            context.read<CreatePostBloc>().add(CreatePostStarted());
          } else if (state is CreatePostReady && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.errorMessage!),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CreatePostLoading) {
            return const Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }

          final categories = state is CreatePostReady
              ? state.categories
              : <CategoriesEntity>[];
          final bool isSubmitting =
              state is CreatePostReady && state.isSubmitting;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Write a post'),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          if (_titleController.text.trim().isEmpty ||
                              _contentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Title and content are required'),
                              ),
                            );
                            return;
                          }
                          context.read<CreatePostBloc>().add(
                            CreatePostSubmitted(
                              title: _titleController.text.trim(),
                              excerpt: _excerptController.text.trim(),
                              content: _contentController.text.trim(),
                              coverImageUrl: _coverImageController.text.trim(),
                              categoryId: _selectedCategoryId,
                            ),
                          );
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Share'),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _excerptController,
                  decoration: const InputDecoration(
                    label: Text('Excerpt (optional)'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _coverImageController,
                  decoration: const InputDecoration(
                    label: Text('Cover image URL (optional)'),
                  ),
                ),
                const SizedBox(height: 12),
                if (categories.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(label: Text('Category')),
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.categoiresName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  minLines: 8,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    label: Text('Content'),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
