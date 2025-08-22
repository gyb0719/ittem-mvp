import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'teal_button.dart';

enum TealDialogType { alert, confirmation, custom, loading }

class TealDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final TealDialogType type;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment actionsAlignment;
  final bool barrierDismissible;

  const TealDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.actions,
    this.type = TealDialogType.custom,
    this.contentPadding,
    this.actionsPadding,
    this.actionsAlignment = MainAxisAlignment.end,
    this.barrierDismissible = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required TealDialog dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => dialog,
    );
  }

  // 미리 정의된 다이얼로그들
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = '확인',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      dialog: TealDialog.alert(
        title: title,
        content: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      dialog: TealDialog.confirmation(
        title: title,
        content: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
  }

  static Future<T?> showLoading<T>({
    required BuildContext context,
    String message = '처리 중...',
  }) {
    return show<T>(
      context: context,
      barrierDismissible: false,
      dialog: TealDialog.loading(message: message),
    );
  }

  // 팩토리 생성자들
  factory TealDialog.alert({
    required String title,
    required String content,
    String buttonText = '확인',
    VoidCallback? onPressed,
  }) {
    return TealDialog(
      type: TealDialogType.alert,
      title: title,
      content: content,
      actions: [
        TealButton(
          text: buttonText,
          onPressed: onPressed,
          size: TealButtonSize.medium,
        ),
      ],
    );
  }

  factory TealDialog.confirmation({
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDestructive = false,
  }) {
    return TealDialog(
      type: TealDialogType.confirmation,
      title: title,
      content: content,
      actions: [
        TealButton(
          text: cancelText,
          type: TealButtonType.outline,
          onPressed: () {
            final context = NavigationService.currentContext;
            if (context != null) Navigator.of(context).pop(false);
          },
          size: TealButtonSize.medium,
        ),
        const SizedBox(width: 12),
        TealButton(
          text: confirmText,
          type: isDestructive ? TealButtonType.danger : TealButtonType.primary,
          onPressed: () {
            final context = NavigationService.currentContext;
            if (context != null) Navigator.of(context).pop(true);
          },
          size: TealButtonSize.medium,
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  factory TealDialog.loading({
    String message = '처리 중...',
  }) {
    return TealDialog(
      type: TealDialogType.loading,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDarkMode ? AppColors.surfaceDark : AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 280,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hasTitle()) _buildTitle(isDarkMode),
            if (_hasContent()) _buildContent(isDarkMode),
            if (_hasActions()) _buildActions(),
          ],
        ),
      ),
    );
  }

  bool _hasTitle() => title != null || titleWidget != null;
  bool _hasContent() => content != null || contentWidget != null;
  bool _hasActions() => actions != null && actions!.isNotEmpty;

  Widget _buildTitle(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: titleWidget ?? Text(
        title!,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: contentPadding ?? EdgeInsets.fromLTRB(
        24, 
        _hasTitle() ? 0 : 24, 
        24, 
        _hasActions() ? 16 : 24,
      ),
      child: contentWidget ?? Text(
        content!,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      width: double.infinity,
      padding: actionsPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: actionsAlignment == MainAxisAlignment.spaceEvenly
          ? Row(
              mainAxisAlignment: actionsAlignment,
              children: actions!.map((action) => 
                Expanded(child: action),
              ).toList(),
            )
          : Wrap(
              alignment: WrapAlignment.end,
              spacing: 12,
              children: actions!,
            ),
    );
  }
}

// 네비게이션 서비스 (글로벌 컨텍스트용)
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static BuildContext? get currentContext => navigatorKey.currentContext;
  
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }
  
  static void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
  
  static Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }
  
  static Future<T?> pushNamedAndRemoveUntil<T>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }
}

// 특수한 다이얼로그들
class TealInputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final int? maxLines;
  final String confirmText;
  final String cancelText;
  final String? Function(String?)? validator;

  const TealInputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.validator,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    String confirmText = '확인',
    String cancelText = '취소',
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => TealInputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        keyboardType: keyboardType,
        maxLines: maxLines,
        confirmText: confirmText,
        cancelText: cancelText,
        validator: validator,
      ),
    );
  }

  @override
  State<TealInputDialog> createState() => _TealInputDialogState();
}

class _TealInputDialogState extends State<TealInputDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_controller.text);
      });
    }
  }

  void _confirm() {
    _validate();
    if (_errorText == null) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TealDialog(
      title: widget.title,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            autofocus: true,
            onChanged: (_) => _validate(),
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: _errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TealButton(
          text: widget.cancelText,
          type: TealButtonType.outline,
          onPressed: () => Navigator.of(context).pop(),
          size: TealButtonSize.medium,
        ),
        const SizedBox(width: 12),
        TealButton(
          text: widget.confirmText,
          onPressed: _confirm,
          size: TealButtonSize.medium,
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}