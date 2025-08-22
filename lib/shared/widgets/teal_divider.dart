import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealDividerType { solid, dashed, dotted, gradient }
enum TealDividerStyle { thin, medium, thick }

class TealDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final TealDividerType type;
  final TealDividerStyle style;
  final bool isVertical;

  const TealDivider({
    super.key,
    this.height,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.type = TealDividerType.solid,
    this.style = TealDividerStyle.thin,
    this.isVertical = false,
  });

  // 팩토리 생성자들
  factory TealDivider.horizontal({
    Key? key,
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
    Color? color,
    TealDividerType type = TealDividerType.solid,
    TealDividerStyle style = TealDividerStyle.thin,
  }) {
    return TealDivider(
      key: key,
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
      type: type,
      style: style,
      isVertical: false,
    );
  }

  factory TealDivider.vertical({
    Key? key,
    double? width,
    double? thickness,
    double? indent,
    double? endIndent,
    Color? color,
    TealDividerType type = TealDividerType.solid,
    TealDividerStyle style = TealDividerStyle.thin,
  }) {
    return TealDivider(
      key: key,
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
      type: type,
      style: style,
      isVertical: true,
    );
  }

  factory TealDivider.gradient({
    Key? key,
    double? height,
    double? width,
    double? thickness,
    double? indent,
    double? endIndent,
    TealDividerStyle style = TealDividerStyle.thin,
    bool isVertical = false,
  }) {
    return TealDivider(
      key: key,
      height: height,
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      type: TealDividerType.gradient,
      style: style,
      isVertical: isVertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = color ?? 
      (isDarkMode ? AppColors.separatorDark : AppColors.separator);
    final dividerThickness = thickness ?? _getThickness();

    switch (type) {
      case TealDividerType.solid:
        return _buildSolidDivider(dividerColor, dividerThickness);
      case TealDividerType.dashed:
        return _buildDashedDivider(dividerColor, dividerThickness);
      case TealDividerType.dotted:
        return _buildDottedDivider(dividerColor, dividerThickness);
      case TealDividerType.gradient:
        return _buildGradientDivider(dividerThickness);
    }
  }

  Widget _buildSolidDivider(Color dividerColor, double dividerThickness) {
    if (isVertical) {
      return Container(
        width: width,
        margin: EdgeInsets.only(
          top: indent ?? 0,
          bottom: endIndent ?? 0,
        ),
        child: VerticalDivider(
          thickness: dividerThickness,
          color: dividerColor,
        ),
      );
    } else {
      return Container(
        height: height,
        margin: EdgeInsets.only(
          left: indent ?? 0,
          right: endIndent ?? 0,
        ),
        child: Divider(
          thickness: dividerThickness,
          color: dividerColor,
        ),
      );
    }
  }

  Widget _buildDashedDivider(Color dividerColor, double dividerThickness) {
    return CustomPaint(
      size: Size(
        isVertical ? dividerThickness : double.infinity,
        isVertical ? double.infinity : dividerThickness,
      ),
      painter: _DashedDividerPainter(
        color: dividerColor,
        thickness: dividerThickness,
        isVertical: isVertical,
        dashWidth: 5,
        dashSpace: 3,
      ),
    );
  }

  Widget _buildDottedDivider(Color dividerColor, double dividerThickness) {
    return CustomPaint(
      size: Size(
        isVertical ? dividerThickness : double.infinity,
        isVertical ? double.infinity : dividerThickness,
      ),
      painter: _DottedDividerPainter(
        color: dividerColor,
        thickness: dividerThickness,
        isVertical: isVertical,
        dotRadius: dividerThickness / 2,
        dotSpace: 4,
      ),
    );
  }

  Widget _buildGradientDivider(double dividerThickness) {
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        AppColors.primary.withValues(alpha: 0.3),
        AppColors.primary,
        AppColors.primary.withValues(alpha: 0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
      end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
    );

    return Container(
      width: isVertical ? dividerThickness : width,
      height: isVertical ? height : dividerThickness,
      margin: EdgeInsets.only(
        left: isVertical ? 0 : (indent ?? 0),
        right: isVertical ? 0 : (endIndent ?? 0),
        top: isVertical ? (indent ?? 0) : 0,
        bottom: isVertical ? (endIndent ?? 0) : 0,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }

  double _getThickness() {
    switch (style) {
      case TealDividerStyle.thin:
        return 1.0;
      case TealDividerStyle.medium:
        return 2.0;
      case TealDividerStyle.thick:
        return 4.0;
    }
  }
}

// 커스텀 대시 디바이더 페인터
class _DashedDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isVertical;
  final double dashWidth;
  final double dashSpace;

  _DashedDividerPainter({
    required this.color,
    required this.thickness,
    required this.isVertical,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    if (isVertical) {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    } else {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 커스텀 점선 디바이더 페인터
class _DottedDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isVertical;
  final double dotRadius;
  final double dotSpace;

  _DottedDividerPainter({
    required this.color,
    required this.thickness,
    required this.isVertical,
    required this.dotRadius,
    required this.dotSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isVertical) {
      double startY = dotRadius;
      while (startY < size.height) {
        canvas.drawCircle(
          Offset(size.width / 2, startY),
          dotRadius,
          paint,
        );
        startY += (dotRadius * 2) + dotSpace;
      }
    } else {
      double startX = dotRadius;
      while (startX < size.width) {
        canvas.drawCircle(
          Offset(startX, size.height / 2),
          dotRadius,
          paint,
        );
        startX += (dotRadius * 2) + dotSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 섹션 디바이더 (텍스트와 함께)
class TealSectionDivider extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final Color? dividerColor;
  final double? thickness;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;

  const TealSectionDivider({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.dividerColor,
    this.thickness,
    this.padding,
    this.alignment = MainAxisAlignment.center,
  });

  factory TealSectionDivider.withText({
    Key? key,
    required String title,
    TextStyle? titleStyle,
    Color? dividerColor,
    double? thickness,
    EdgeInsetsGeometry? padding,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) {
    return TealSectionDivider(
      key: key,
      title: title,
      titleStyle: titleStyle,
      dividerColor: dividerColor,
      thickness: thickness,
      padding: padding,
      alignment: alignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultTitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (alignment != MainAxisAlignment.start) ...[
            Expanded(
              child: TealDivider(
                color: dividerColor,
                thickness: thickness,
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          titleWidget ?? Text(
            title ?? '',
            style: titleStyle ?? defaultTitleStyle,
          ),
          
          if (alignment != MainAxisAlignment.end) ...[
            const SizedBox(width: 16),
            Expanded(
              child: TealDivider(
                color: dividerColor,
                thickness: thickness,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// 간격 디바이더 (공간만 차지)
class TealSpaceDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const TealSpaceDivider({
    super.key,
    this.height,
    this.width,
    this.color,
  });

  factory TealSpaceDivider.vertical(double height) {
    return TealSpaceDivider(height: height);
  }

  factory TealSpaceDivider.horizontal(double width) {
    return TealSpaceDivider(width: width);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}

// 브랜드 디바이더 (틸 색상 활용)
class TealBrandDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final bool showGradient;
  final bool animated;

  const TealBrandDivider({
    super.key,
    this.height,
    this.thickness,
    this.showGradient = true,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return _AnimatedTealDivider(
        height: height,
        thickness: thickness,
        showGradient: showGradient,
      );
    }

    return TealDivider.gradient(
      height: height,
      thickness: thickness,
    );
  }
}

class _AnimatedTealDivider extends StatefulWidget {
  final double? height;
  final double? thickness;
  final bool showGradient;

  const _AnimatedTealDivider({
    this.height,
    this.thickness,
    required this.showGradient,
  });

  @override
  State<_AnimatedTealDivider> createState() => _AnimatedTealDividerState();
}

class _AnimatedTealDividerState extends State<_AnimatedTealDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.thickness ?? 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: _animation.value),
                AppColors.primary.withValues(alpha: 0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}