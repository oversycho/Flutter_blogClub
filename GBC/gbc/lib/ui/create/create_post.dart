import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/auth/auth.dart';
import 'package:gbc/ui/create/bloc/create_post_bloc.dart';
import 'package:gbc/ui/posts/post_details.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _selectedCategoryId;

  Uint8List? _pickedImageBytes;
  String? _pickedImageExtension;

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleController.clear();
    _excerptController.clear();
    _contentController.clear();
    setState(() {
      _selectedCategoryId = null;
      _pickedImageBytes = null;
      _pickedImageExtension = null;
    });
  }

  Future<void> _pickImage() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // compress a bit — full-res phone photos are large
      maxWidth: 1600,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    // e.g. "photo.JPG" -> "jpg"
    final extension = picked.name.contains('.')
        ? picked.name.split('.').last.toLowerCase()
        : 'jpg';

    setState(() {
      _pickedImageBytes = bytes;
      _pickedImageExtension = extension;
    });
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
                          context.read<CreatePostBloc>().add(
                            CreatePostSubmitted(
                              title: _titleController.text.trim(),
                              excerpt: _excerptController.text.trim(),
                              content: _contentController.text.trim(),
                              categoryId: _selectedCategoryId,
                              coverImageBytes: _pickedImageBytes,
                              coverImageExtension: _pickedImageExtension,
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
                GestureDetector(
                  onTap: isSubmitting ? null : _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      image: _pickedImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_pickedImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _pickedImageBytes == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.photo, size: 36),
                              SizedBox(height: 8),
                              Text('Tap to add a cover image'),
                            ],
                          )
                        : Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: isSubmitting
                                      ? null
                                      : () => setState(() {
                                          _pickedImageBytes = null;
                                          _pickedImageExtension = null;
                                        }),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
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
                if (categories.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
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
