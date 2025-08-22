import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_item_step1_basic_info.dart';
import 'add_item_step2_photos.dart';
import 'add_item_step3_pricing.dart';
import 'add_item_step4_confirm.dart';

class AddItemFlowScreen extends ConsumerStatefulWidget {
  const AddItemFlowScreen({super.key});

  @override
  ConsumerState<AddItemFlowScreen> createState() => _AddItemFlowScreenState();
}

class _AddItemFlowScreenState extends ConsumerState<AddItemFlowScreen> {
  int _currentStep = 0;
  final Map<String, dynamic> _itemData = {};

  // List of step widgets
  List<Widget> get _steps => [
    AddItemStep1BasicInfo(
      data: _itemData,
      onNext: () => _nextStep(),
    ),
    AddItemStep2Photos(
      data: _itemData,
      onNext: () => _nextStep(),
      onBack: () => _previousStep(),
    ),
    AddItemStep3Pricing(
      data: _itemData,
      onNext: () => _nextStep(),
      onBack: () => _previousStep(),
    ),
    AddItemStep4Confirm(
      data: _itemData,
      onBack: () => _previousStep(),
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          _previousStep();
          return false;
        }
        return true;
      },
      child: _steps[_currentStep],
    );
  }
}