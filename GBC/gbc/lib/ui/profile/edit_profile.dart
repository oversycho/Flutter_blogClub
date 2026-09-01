import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/profile.dart';
import 'package:gbc/ui/profile/bloc/profile_bloc.dart';
import 'package:gbc/ui/widgets/image.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  Uint8List? _pickedAvatarBytes;
  String? _pickedAvatarExtension;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 600,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final extension = picked.name.contains('.')
        ? picked.name.split('.').last.toLowerCase()
        : 'jpg';

    setState(() {
      _pickedAvatarBytes = bytes;
      _pickedAvatarExtension = extension;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess && !state.isSaving) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.errorMessage!),
              ),
            );
          } else {
            // Saved successfully — go back to the profile page.
            Navigator.of(context).pop();
          }
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final bool isSaving = state is ProfileSuccess && state.isSaving;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(
                            ProfileEditSubmitted(
                              username: _usernameController.text.trim(),
                              bio: _bioController.text.trim(),
                              avatarBytes: _pickedAvatarBytes,
                              avatarExtension: _pickedAvatarExtension,
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: isSaving ? null : _pickAvatar,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: _pickedAvatarBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.memory(
                                    _pickedAvatarBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : widget.profile.avatarUrl != null
                              ? ImageLoadingService(
                                  imageUrl: widget.profile.avatarUrl!,
                                  borderRadius: BorderRadius.circular(50),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    size: 40,
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: const Icon(
                              CupertinoIcons.camera_fill,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(label: Text('Username')),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bioController,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    label: Text('Bio'),
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
