import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/items_provider.dart';
import '../../../theme/colors.dart';

class RadiusFilterChip extends ConsumerWidget {
  const RadiusFilterChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRadius = ref.watch(mapRadiusProvider);
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [1000, 3000, 5000].map((radius) {
          final isSelected = currentRadius == radius;
          return FilterChip(
            label: Text(_getRadiusLabel(radius)),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(mapRadiusProvider.notifier).setRadius(radius);
              }
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary.withValues(alpha: 0.1),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.separator,
                width: isSelected ? 2 : 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getRadiusLabel(int radius) {
    return '${(radius / 1000).toInt()}km';
  }
}