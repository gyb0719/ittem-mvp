import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/item_model.dart';
import 'item_detail_simple_screen.dart';

class ItemDetailScreen extends ConsumerWidget {
  final ItemModel item;
  
  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect to the simplified version implementing "One Thing per Page" principle
    return ItemDetailSimpleScreen(item: item);
  }
}