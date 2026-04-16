import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/utils/validators.dart';
import 'package:tubes_apb_flutter/features/settings/data/repositories/settings_repository.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_text_field.dart';
import 'package:tubes_apb_flutter/shared/widgets/feedback.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  static const _allowedExtensions = <String>{'.jpg', '.jpeg', '.png', '.webp'};
  static const _maxImageSize = 2 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  XFile? _selectedImage;
  Uint8List? _compressedImageBytes;
  bool _isSaving = false;
  Map<String, String> _fieldErrors = const {};

  @override
  void initState() {
    super.initState();

    final user = ref.read(authSessionControllerProvider).user;
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null || !mounted) {
      return;
    }

    final extension = p.extension(picked.path).toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      showErrorSnackBar(
        context,
        const FormatException('Please select jpg, jpeg, png, or webp image.'),
      );
      return;
    }

    final bytes = await picked.readAsBytes();
    if (!mounted) {
      return;
    }

    Uint8List? uploadBytes;
    if (bytes.length > _maxImageSize) {
      final shouldCompress = await _askCompressionApproval();
      if (!mounted) {
        return;
      }

      if (shouldCompress != true) {
        showErrorSnackBar(
          context,
          const FormatException(
            'Image exceeds 2MB. Compression is required to continue.',
          ),
        );
        return;
      }

      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 72,
        format: _formatForExtension(extension),
      );

      if (!mounted) {
        return;
      }

      if (compressedBytes.length > _maxImageSize) {
        showErrorSnackBar(
          context,
          const FormatException(
            'Compressed image is still larger than 2MB. Choose another image.',
          ),
        );
        return;
      }

      uploadBytes = Uint8List.fromList(compressedBytes);
    }

    setState(() {
      _selectedImage = picked;
      _compressedImageBytes = uploadBytes;
    });
  }

  CompressFormat _formatForExtension(String extension) {
    return switch (extension) {
      '.png' => CompressFormat.png,
      '.webp' => CompressFormat.webp,
      _ => CompressFormat.jpeg,
    };
  }

  Future<bool?> _askCompressionApproval() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Too Large'),
          content: const Text(
            'Selected image is larger than 2MB. Compress it automatically?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Compress'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
      _fieldErrors = const {};
    });

    final repository = ref.read(settingsRepositoryProvider);
    final sessionController = ref.read(authSessionControllerProvider.notifier);

    SelectedImageUpload? upload;
    final selectedImage = _selectedImage;
    if (selectedImage != null) {
      upload = SelectedImageUpload(
        fileName: p.basename(selectedImage.path),
        filePath: _compressedImageBytes == null ? selectedImage.path : null,
        bytes: _compressedImageBytes,
      );
    }

    try {
      await sessionController.withRefreshRetry(
        () => repository.updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          image: upload,
        ),
      );

      await sessionController.refreshProfile();

      if (!mounted) {
        return;
      }

      showSuccessSnackBar(context, 'Profile updated successfully.');
      Navigator.of(context).pop();
    } catch (error) {
      if (error is ApiException) {
        final mappedErrors = <String, String>{};
        for (final entry in error.fieldErrors.entries) {
          if (entry.value.isNotEmpty) {
            mappedErrors[entry.key] = entry.value.first;
          }
        }

        setState(() {
          _fieldErrors = mappedErrors;
        });
      }

      if (mounted) {
        showErrorSnackBar(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authSessionControllerProvider).user;

    ImageProvider<Object>? preview;
    if (_selectedImage != null) {
      if (_compressedImageBytes != null) {
        preview = MemoryImage(_compressedImageBytes!);
      } else {
        preview = FileImage(File(_selectedImage!.path));
      }
    } else if (user?.profilePicture != null &&
        user!.profilePicture!.isNotEmpty) {
      preview = NetworkImage(user.profilePicture!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundImage: preview,
                  child: preview == null
                      ? const Icon(Icons.person, size: 42)
                      : null,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Upload Profile Picture'),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'First Name',
                  controller: _firstNameController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'First name'),
                  errorText: _fieldErrors['firstName'],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Last name'),
                  errorText: _fieldErrors['lastName'],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Save Changes',
                  isLoading: _isSaving,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
