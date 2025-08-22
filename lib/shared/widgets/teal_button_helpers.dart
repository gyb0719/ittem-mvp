import 'package:flutter/material.dart';
import 'teal_button.dart';

class TealButtons {
  // Primary button
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    Widget? child,
    bool isLoading = false,
    Widget? icon,
    double? width,
    double? height,
    bool fullWidth = false,
  }) {
    return TealButton(
      text: child != null ? '' : text,
      onPressed: onPressed,
      type: TealButtonType.primary,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      fullWidth: fullWidth,
    );
  }

  // Outlined button
  static Widget outlined({
    required String text,
    required VoidCallback? onPressed,
    Widget? child,
    bool isLoading = false,
    Widget? icon,
    double? width,
    double? height,
    bool fullWidth = false,
  }) {
    return TealButton(
      text: child != null ? '' : text,
      onPressed: onPressed,
      type: TealButtonType.outline,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      fullWidth: fullWidth,
    );
  }

  // Text button
  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    Widget? child,
    bool isLoading = false,
    Widget? icon,
    double? width,
    double? height,
    bool fullWidth = false,
  }) {
    return TealButton(
      text: child != null ? '' : text,
      onPressed: onPressed,
      type: TealButtonType.text,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      fullWidth: fullWidth,
    );
  }
}