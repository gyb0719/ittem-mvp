import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/simple_button.dart';
import '../../../services/google_maps_service.dart';

class AddItemStep3Pricing extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AddItemStep3Pricing({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<AddItemStep3Pricing> createState() => _AddItemStep3PricingState();
}

class _AddItemStep3PricingState extends ConsumerState<AddItemStep3Pricing> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _depositController = TextEditingController();
  
  bool _requiresDeposit = false;
  String _selectedPriceType = 'daily';
  bool _isLoadingLocation = false;

  final List<Map<String, String>> _priceTypes = [
    {'value': 'daily', 'label': '일일 대여'},
    {'value': 'weekly', 'label': '주간 대여'},
    {'value': 'monthly', 'label': '월간 대여'},
  ];

  @override
  void initState() {
    super.initState();
    // Load existing data
    _priceController.text = widget.data['price']?.toString() ?? '';
    _locationController.text = widget.data['location'] ?? '';
    _depositController.text = widget.data['deposit']?.toString() ?? '';
    _requiresDeposit = widget.data['requiresDeposit'] ?? false;
    _selectedPriceType = widget.data['priceType'] ?? 'daily';
    
    // Load current location if not set
    if (_locationController.text.isEmpty) {
      _loadCurrentLocation();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _locationController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

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
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

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
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _saveAndNext() {
    if (!_formKey.currentState!.validate()) return;

    widget.data['price'] = int.parse(_priceController.text);
    widget.data['location'] = _locationController.text.trim();
    widget.data['priceType'] = _selectedPriceType;
    widget.data['requiresDeposit'] = _requiresDeposit;
    if (_requiresDeposit && _depositController.text.isNotEmpty) {
      widget.data['deposit'] = int.parse(_depositController.text);
    }

    widget.onNext();
  }

  String _getPriceLabel() {
    switch (_selectedPriceType) {
      case 'weekly':
        return '주';
      case 'monthly':
        return '월';
      default:
        return '일';
    }
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value.replaceAll(',', ''));
    if (number == null) return value;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가격 및 위치'),
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
                '3/4',
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
              value: 0.75,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5CBDBD)),
            ),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '가격과 위치를 설정해주세요',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '적정한 가격으로 더 많은 대여 기회를 얻으세요',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Price type selection
                    Text(
                      '대여 기간 *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: _priceTypes.map((type) {
                        final isSelected = _selectedPriceType == type['value'];
                        return ChoiceChip(
                          label: Text(type['label']!),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPriceType = type['value']!;
                              });
                            }
                          },
                          selectedColor: const Color(0xFF5CBDBD).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected 
                                ? const Color(0xFF5CBDBD)
                                : Colors.grey[700],
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Price
                    Text(
                      '대여료 *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final formatted = _formatCurrency(newValue.text);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        hintText: '예: 10,000',
                        suffixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '원/${_getPriceLabel()}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5CBDBD), width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '가격을 입력해주세요';
                        }
                        final price = int.tryParse(value.replaceAll(',', ''));
                        if (price == null || price <= 0) {
                          return '올바른 가격을 입력해주세요';
                        }
                        if (price < 1000) {
                          return '최소 1,000원 이상 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Deposit section
                    Row(
                      children: [
                        Checkbox(
                          value: _requiresDeposit,
                          onChanged: (value) {
                            setState(() {
                              _requiresDeposit = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF5CBDBD),
                        ),
                        Text(
                          '보증금 받기',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    if (_requiresDeposit) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _depositController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final formatted = _formatCurrency(newValue.text);
                            return TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }),
                        ],
                        decoration: InputDecoration(
                          hintText: '예: 50,000',
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '원',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF5CBDBD), width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: _requiresDeposit ? (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '보증금을 입력해주세요';
                          }
                          final deposit = int.tryParse(value.replaceAll(',', ''));
                          if (deposit == null || deposit <= 0) {
                            return '올바른 보증금을 입력해주세요';
                          }
                          return null;
                        } : null,
                      ),
                    ],
                    const SizedBox(height: 32),

                    // Location
                    Text(
                      '대여 위치 *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: '예: 강남구 역삼동',
                        suffixIcon: IconButton(
                          icon: _isLoadingLocation
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF5CBDBD),
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color: Color(0xFF5CBDBD),
                                ),
                          onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5CBDBD), width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '위치를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Price suggestion card
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
                                Icons.trending_up,
                                color: const Color(0xFF5CBDBD),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '적정 가격 가이드',
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
                            '• ${widget.data['category'] ?? '해당 카테고리'}의 평균 ${_getPriceLabel()}일 대여료: 8,000~15,000원\n• 물건의 상태와 브랜드를 고려해주세요\n• 첫 거래는 경쟁력 있는 가격으로 시작하세요\n• 보증금은 대여료의 2-5배가 적당해요',
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
                    child: const Text(
                      '다음 단계 (최종 확인)',
                      style: TextStyle(
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