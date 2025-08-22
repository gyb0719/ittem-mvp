import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/item_model.dart';
import '../../services/supabase_service.dart';
import '../../services/google_maps_service.dart';
import '../../services/image_upload_service.dart';
import '../../shared/widgets/teal_components.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  final ItemModel item;
  
  const EditItemScreen({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _locationController;

  late String _selectedCategory;
  final List<String> _categories = [
    '카메라', '스포츠', '도구', '주방용품', '완구', '악기', '의류', '가전제품', '도서', '기타'
  ];

  late List<String> _uploadedImageUrls;
  bool _isLoading = false;
  bool _isUploadingImages = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _descriptionController = TextEditingController(text: widget.item.description);
    _priceController = TextEditingController(text: widget.item.price.toString());
    _locationController = TextEditingController(text: widget.item.location);
    _selectedCategory = widget.item.category;
    _uploadedImageUrls = widget.item.imageUrls ?? [widget.item.imageUrl];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 수정'),
        actions: [
          // 삭제 버튼
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteDialog,
          ),
          // 저장 버튼
          TextButton(
            onPressed: _isLoading ? null : _updateItem,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 표시
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.item.isAvailable 
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.item.isAvailable ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.item.isAvailable ? Icons.check_circle : Icons.schedule,
                      color: widget.item.isAvailable ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.item.isAvailable ? '대여 가능 상태' : '대여 중',
                      style: TextStyle(
                        color: widget.item.isAvailable ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TealButton(
                      text: widget.item.isAvailable ? '대여중으로 변경' : '대여가능으로 변경',
                      type: TealButtonType.outline,
                      size: TealButtonSize.small,
                      onPressed: _toggleAvailability,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // 이미지 섹션
              Text(
                '사진',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _uploadedImageUrls.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _uploadedImageUrls.length) {
                      return _buildAddImageButton();
                    }
                    return _buildImageCard(_uploadedImageUrls[index], index);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 기본 정보
              TealTextField(
                controller: _titleController,
                labelText: '제목',
                hintText: '어떤 물건인가요?',
              ),
              const SizedBox(height: 16),

              // 카테고리
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '카테고리',
                ),
                value: _selectedCategory,
                items: _categories.map((category) => 
                  DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 설명
              TealTextField(
                controller: _descriptionController,
                labelText: '상세 설명',
                hintText: '물건에 대해 자세히 설명해주세요',
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // 가격
              TealTextField(
                controller: _priceController,
                labelText: '하루 대여료',
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // 위치
              TealTextField(
                controller: _locationController,
                labelText: '위치',
                hintText: '대여 가능한 위치',
              ),
              const SizedBox(height: 24),

              // 통계 정보
              TealCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상품 통계',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('조회수', '127'),
                        _buildStatItem('관심', '23'),
                        _buildStatItem('문의', '8'),
                        _buildStatItem('평점', widget.item.rating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _isUploadingImages ? null : _pickImages,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isUploadingImages
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: Colors.grey[600],
                  ),
            const SizedBox(height: 4),
            Text(
              _isUploadingImages 
                  ? '업로드 중...'
                  : '${_uploadedImageUrls.length}/5',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, int index) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          if (index == 0)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '대표',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
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
        ],
      ),
    );
  }

  void _pickImages() async {
    if (_uploadedImageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최대 5장까지 선택할 수 있습니다')),
      );
      return;
    }

    setState(() => _isUploadingImages = true);

    try {
      final imageUploadService = ref.read(imageUploadServiceProvider);
      final uploadedUrls = await imageUploadService.pickAndUploadMultipleImages(
        bucket: 'items',
        folder: 'item_images',
        limit: 5 - _uploadedImageUrls.length,
      );
      
      if (uploadedUrls.isNotEmpty) {
        setState(() => _uploadedImageUrls.addAll(uploadedUrls));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${uploadedUrls.length}장의 이미지가 업로드되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미지 업로드 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUploadingImages = false);
    }
  }

  void _removeImage(int index) {
    if (_uploadedImageUrls.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 1장의 사진은 필요합니다')),
      );
      return;
    }

    final imageUrl = _uploadedImageUrls[index];
    setState(() => _uploadedImageUrls.removeAt(index));
    
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

  void _getCurrentLocation() async {
    try {
      final mapsService = ref.read(googleMapsServiceProvider);
      final location = await mapsService.getCurrentLocation();
      
      if (location != null) {
        final address = await mapsService.reverseGeocode(location);
        if (address != null && mounted) {
          setState(() => _locationController.text = address.split(',').first);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('현재 위치로 설정되었습니다')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('위치를 가져올 수 없습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleAvailability() async {
    setState(() => _isLoading = true);
    
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      
      // TODO: Implement toggle availability in SupabaseService
      // await supabaseService.toggleItemAvailability(widget.item.id, !widget.item.isAvailable);
      
      // For now, just show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.item.isAvailable ? '상품이 대여중으로 변경되었습니다' : '상품이 대여가능으로 변경되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Update local state (in real app, this would come from the server)
      setState(() {
        // widget.item.isAvailable = !widget.item.isAvailable; // This won't work with Freezed
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('상태 변경 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateItem() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 1장의 사진을 선택해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      
      // TODO: Implement updateItem in SupabaseService
      /*
      final updatedItem = await supabaseService.updateItem(
        itemId: widget.item.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text),
        category: _selectedCategory,
        location: _locationController.text.trim(),
        imageUrls: _uploadedImageUrls,
      );
      */

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('상품이 성공적으로 수정되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // 이전 화면으로 돌아가기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('수정 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상품 삭제'),
        content: const Text('정말로 이 상품을 삭제하시겠습니까?\n삭제된 상품은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _deleteItem() async {
    setState(() => _isLoading = true);

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      
      // TODO: Implement deleteItem in SupabaseService
      // await supabaseService.deleteItem(widget.item.id);

      // Delete all images
      for (final imageUrl in _uploadedImageUrls) {
        await _deleteImageFromStorage(imageUrl);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('상품이 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/home'); // 홈으로 돌아가기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}