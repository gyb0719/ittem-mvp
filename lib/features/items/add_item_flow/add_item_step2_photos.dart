import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/simple_button.dart';
import '../../../services/image_upload_service.dart';

class AddItemStep2Photos extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AddItemStep2Photos({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<AddItemStep2Photos> createState() => _AddItemStep2PhotosState();
}

class _AddItemStep2PhotosState extends ConsumerState<AddItemStep2Photos> {
  List<String> _uploadedImageUrls = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadedImageUrls = List<String>.from(widget.data['imageUrls'] ?? []);
  }

  void _saveAndNext() {
    if (_uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('최소 1장의 사진을 추가해주세요'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    widget.data['imageUrls'] = _uploadedImageUrls;
    widget.onNext();
  }

  Future<void> _pickImages() async {
    if (_uploadedImageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최대 5장까지만 선택할 수 있습니다'),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final imageUploadService = ref.read(imageUploadServiceProvider);
      final uploadedUrls = await imageUploadService.pickAndUploadMultipleImages(
        bucket: 'items',
        folder: 'item_images',
        limit: 5 - _uploadedImageUrls.length,
      );

      if (uploadedUrls.isNotEmpty) {
        setState(() {
          _uploadedImageUrls.addAll(uploadedUrls);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${uploadedUrls.length}장의 사진이 추가되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사진 업로드 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    final imageUrl = _uploadedImageUrls[index];

    setState(() {
      _uploadedImageUrls.removeAt(index);
    });

    // Optionally delete from storage
    _deleteImageFromStorage(imageUrl);
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      final imageUploadService = ref.read(imageUploadServiceProvider);
      final fileName = imageUploadService.extractFileNameFromUrl(imageUrl);
      if (fileName != null) {
        await imageUploadService.deleteImage('items', fileName);
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  void _reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _uploadedImageUrls.removeAt(oldIndex);
      _uploadedImageUrls.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 추가'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '2/4',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5CBDBD)),
            ),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '물건의 사진을 추가해주세요',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '첫 번째 사진이 대표 사진으로 사용됩니다',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Add photo button
                  GestureDetector(
                    onTap: _isUploading ? null : _pickImages,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF5CBDBD),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF5CBDBD).withOpacity(0.05),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isUploading)
                              const CircularProgressIndicator(
                                color: Color(0xFF5CBDBD),
                              )
                            else
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: const Color(0xFF5CBDBD),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              _isUploading
                                  ? '사진을 업로드하는 중...'
                                  : '사진 추가하기',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5CBDBD),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '최대 5장까지 (${_uploadedImageUrls.length}/5)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (_uploadedImageUrls.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text(
                      '선택된 사진 (${_uploadedImageUrls.length}장)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Photo grid with reorder functionality
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: _reorderImages,
                      itemCount: _uploadedImageUrls.length,
                      itemBuilder: (context, index) {
                        final imageUrl = _uploadedImageUrls[index];
                        return Container(
                          key: ValueKey(imageUrl),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.center,
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5CBDBD),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '대표',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Tips card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CBDBD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: const Color(0xFF5CBDBD),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '좋은 사진 촬영 팁',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5CBDBD),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '• 자연광에서 촬영해주세요\n• 물건의 전체적인 모습과 세부 사항을 모두 보여주세요\n• 깨끗하고 정리된 배경에서 촬영해주세요\n• 손으로 끌어서 사진 순서를 변경할 수 있어요',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: SimpleButton.outlined(
                    onPressed: widget.onBack,
                    child: const Text('이전'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SimpleButton.primary(
                    onPressed: _saveAndNext,
                    child: Text(
                      _uploadedImageUrls.isEmpty 
                          ? '사진을 추가해주세요'
                          : '다음 단계 (가격 설정)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}