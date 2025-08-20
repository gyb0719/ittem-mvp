import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';
import '../../services/google_maps_service.dart';
import '../../services/image_upload_service.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = '카메라';
  final List<String> _categories = [
    '카메라',
    '스포츠',
    '도구',
    '주방용품',
    '완구',
    '악기',
    '의류',
    '가전제품',
    '도서',
    '기타'
  ];

  List<String> _uploadedImageUrls = [];
  bool _isLoading = false;
  bool _isUploadingImages = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final mapsService = ref.read(googleMapsServiceProvider);
      final location = await mapsService.getCurrentLocation();
      
      if (location != null) {
        final address = await mapsService.reverseGeocode(location);
        if (address != null && mounted) {
          setState(() {
            _locationController.text = address.split(',').first;
          });
        }
      } else {
        setState(() {
          _locationController.text = '강남구 역삼동';
        });
      }
    } catch (e) {
      debugPrint('Error loading location: $e');
      setState(() {
        _locationController.text = '강남구 역삼동';
      });
    }
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
        title: const Text('아이템 등록'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveItem,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('등록'),
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
              // 이미지 선택 섹션
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

              // 제목
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '어떤 물건인가요?',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 카테고리
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: '카테고리',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 설명
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '상세 설명',
                  hintText: '물건에 대해 자세히 설명해주세요',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '설명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 가격
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '하루 대여료',
                  hintText: '0',
                  suffixText: '원',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '가격을 입력해주세요';
                  }
                  final price = int.tryParse(value);
                  if (price == null || price < 0) {
                    return '올바른 가격을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 위치
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: '위치',
                  hintText: '대여 가능한 위치',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '위치를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 대여 규칙
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '대여 규칙',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('• 물건을 깨끗하게 사용해주세요'),
                      const Text('• 약속된 시간에 반납해주세요'),
                      const Text('• 고장이나 분실 시 즉시 연락주세요'),
                      const Text('• 타인에게 재대여는 금지입니다'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
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
        const SnackBar(
          content: Text('최대 5장까지 선택할 수 있습니다'),
        ),
      );
      return;
    }

    setState(() {
      _isUploadingImages = true;
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
      setState(() {
        _isUploadingImages = false;
      });
    }
  }

  void _removeImage(int index) {
    final imageUrl = _uploadedImageUrls[index];
    
    setState(() {
      _uploadedImageUrls.removeAt(index);
    });
    
    // Optionally delete from Supabase storage
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
          setState(() {
            _locationController.text = address.split(',').first;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('현재 위치로 설정되었습니다'),
            ),
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

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1장의 사진을 선택해주세요'),
        ),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final mapsService = ref.read(googleMapsServiceProvider);
      
      // Get coordinates from address
      final coordinates = await mapsService.geocodeAddress(_locationController.text);
      
      final item = await supabaseService.createItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text),
        category: _selectedCategory,
        location: _locationController.text.trim(),
        imageUrl: _uploadedImageUrls.first, // Main image
        ownerId: user.id,
      );

      if (item != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이템이 성공적으로 등록되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        throw Exception('아이템 등록에 실패했습니다');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('등록 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}