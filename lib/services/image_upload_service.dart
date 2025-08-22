import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../config/env.dart';

class ImageUploadService {
  final _picker = ImagePicker();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<String?> pickAndUploadImage({
    required String bucket,
    required String folder,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) return null;

      final fileName = '$folder/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      
      if (kIsWeb) {
        // Web implementation
        final bytes = await image.readAsBytes();
        return await _uploadBytesToSupabase(bytes, bucket, fileName);
      } else {
        // Mobile implementation
        final file = File(image.path);
        return await _uploadFileToSupabase(file, bucket, fileName);
      }
    } catch (e) {
      if (Env.enableLogging) print('Error picking/uploading image: $e');
      return null;
    }
  }

  Future<List<String>> pickAndUploadMultipleImages({
    required String bucket,
    required String folder,
    int limit = 5,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (images.isEmpty) return [];

      // Limit the number of images
      final selectedImages = images.take(limit).toList();
      final List<String> uploadedUrls = [];

      for (int i = 0; i < selectedImages.length; i++) {
        final image = selectedImages[i];
        final fileName = '$folder/${DateTime.now().millisecondsSinceEpoch}_${i}_${image.name}';
        
        try {
          String? url;
          if (kIsWeb) {
            final bytes = await image.readAsBytes();
            url = await _uploadBytesToSupabase(bytes, bucket, fileName);
          } else {
            final file = File(image.path);
            url = await _uploadFileToSupabase(file, bucket, fileName);
          }
          
          if (url != null) {
            uploadedUrls.add(url);
          }
        } catch (e) {
          if (Env.enableLogging) print('Error uploading image $i: $e');
          // Continue with other images even if one fails
        }
      }

      return uploadedUrls;
    } catch (e) {
      if (Env.enableLogging) print('Error picking/uploading multiple images: $e');
      return [];
    }
  }

  Future<String?> _uploadBytesToSupabase(
    Uint8List bytes,
    String bucket,
    String fileName,
  ) async {
    try {
      final response = await _supabaseClient.storage
          .from(bucket)
          .uploadBinary(fileName, bytes);

      if (response.isNotEmpty) {
        return _supabaseClient.storage
            .from(bucket)
            .getPublicUrl(fileName);
      }
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Error uploading bytes to Supabase: $e');
      return null;
    }
  }

  Future<String?> _uploadFileToSupabase(
    File file,
    String bucket,
    String fileName,
  ) async {
    try {
      final response = await _supabaseClient.storage
          .from(bucket)
          .upload(fileName, file);

      if (response.isNotEmpty) {
        return _supabaseClient.storage
            .from(bucket)
            .getPublicUrl(fileName);
      }
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Error uploading file to Supabase: $e');
      return null;
    }
  }

  Future<bool> deleteImage(String bucket, String fileName) async {
    try {
      await _supabaseClient.storage
          .from(bucket)
          .remove([fileName]);
      return true;
    } catch (e) {
      if (Env.enableLogging) print('Error deleting image: $e');
      return false;
    }
  }

  // Helper method to extract file name from full URL
  String? extractFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 4) {
        // URL structure: .../storage/v1/object/public/bucket/folder/filename
        return pathSegments.sublist(4).join('/');
      }
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Error extracting filename from URL: $e');
      return null;
    }
  }
}

// State Management
class ImageUploadState {
  final bool isUploading;
  final List<String> uploadedUrls;
  final String? error;

  const ImageUploadState({
    this.isUploading = false,
    this.uploadedUrls = const [],
    this.error,
  });

  ImageUploadState copyWith({
    bool? isUploading,
    List<String>? uploadedUrls,
    String? error,
  }) {
    return ImageUploadState(
      isUploading: isUploading ?? this.isUploading,
      uploadedUrls: uploadedUrls ?? this.uploadedUrls,
      error: error,
    );
  }
}

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final ImageUploadService _imageUploadService;

  ImageUploadNotifier(this._imageUploadService) : super(const ImageUploadState());

  Future<String?> uploadSingleImage({
    required String bucket,
    required String folder,
    ImageSource source = ImageSource.gallery,
  }) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final url = await _imageUploadService.pickAndUploadImage(
        bucket: bucket,
        folder: folder,
        source: source,
      );

      if (url != null) {
        state = state.copyWith(
          isUploading: false,
          uploadedUrls: [...state.uploadedUrls, url],
        );
        return url;
      } else {
        state = state.copyWith(
          isUploading: false,
          error: '이미지 업로드에 실패했습니다.',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: '이미지 업로드 중 오류가 발생했습니다: $e',
      );
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages({
    required String bucket,
    required String folder,
    int limit = 5,
  }) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final urls = await _imageUploadService.pickAndUploadMultipleImages(
        bucket: bucket,
        folder: folder,
        limit: limit,
      );

      state = state.copyWith(
        isUploading: false,
        uploadedUrls: [...state.uploadedUrls, ...urls],
      );

      return urls;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: '이미지 업로드 중 오류가 발생했습니다: $e',
      );
      return [];
    }
  }

  void clearImages() {
    state = state.copyWith(
      uploadedUrls: [],
      error: null,
    );
  }

  void removeImage(String url) {
    final updatedUrls = state.uploadedUrls.where((u) => u != url).toList();
    state = state.copyWith(uploadedUrls: updatedUrls);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});

final imageUploadNotifierProvider = StateNotifierProvider<ImageUploadNotifier, ImageUploadState>((ref) {
  return ImageUploadNotifier(ref.read(imageUploadServiceProvider));
});