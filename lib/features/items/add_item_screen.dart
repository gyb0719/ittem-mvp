import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_item_flow/add_item_flow_screen.dart';

class AddItemScreen extends ConsumerWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simply redirect to the new flow-based screen
    return const AddItemFlowScreen();
  }
}