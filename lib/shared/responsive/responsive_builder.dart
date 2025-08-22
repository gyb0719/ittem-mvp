import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// 반응형 레이아웃을 위한 빌더 위젯
/// 화면 크기에 따라 적절한 위젯을 선택해서 렌더링
class ResponsiveBuilder extends StatelessWidget {
  /// 모바일용 위젯 (필수)
  final Widget mobile;
  
  /// 태블릿용 위젯 (선택사항, null이면 mobile 사용)
  final Widget? tablet;
  
  /// 데스크톱용 위젯 (선택사항, null이면 tablet 또는 mobile 사용)
  final Widget? desktop;
  
  /// 와이드 스크린용 위젯 (선택사항, null이면 desktop, tablet, mobile 순으로 fallback)
  final Widget? wide;
  
  /// 울트라와이드용 위젯 (선택사항)
  final Widget? ultraWide;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wide,
    this.ultraWide,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.ultraWide:
        return ultraWide ?? wide ?? desktop ?? tablet ?? mobile;
      case DeviceType.wide:
        return wide ?? desktop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

/// 반응형 값을 제공하는 빌더
/// T 타입의 값을 화면 크기에 따라 반환
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? wide;
  final T? ultraWide;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wide,
    this.ultraWide,
  });

  /// 현재 화면 크기에 맞는 값을 반환
  T value(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.ultraWide:
        return ultraWide ?? wide ?? desktop ?? tablet ?? mobile;
      case DeviceType.wide:
        return wide ?? desktop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

/// 반응형 패딩을 제공하는 위젯
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final ResponsiveValue<EdgeInsetsGeometry>? padding;
  final bool useDefaultPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.useDefaultPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry actualPadding;
    
    if (padding != null) {
      actualPadding = padding!.value(context);
    } else if (useDefaultPadding) {
      final defaultPadding = ResponsiveUtils.getPadding(context);
      actualPadding = EdgeInsets.all(defaultPadding);
    } else {
      actualPadding = EdgeInsets.zero;
    }
    
    return Padding(
      padding: actualPadding,
      child: child,
    );
  }
}

/// 반응형 컨테이너 - 최대 너비를 제한하고 중앙 정렬
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final bool constrainWidth;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.constrainWidth = true,
    this.maxWidth,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (constrainWidth) {
      final actualMaxWidth = maxWidth ?? ResponsiveUtils.getMaxContentWidth(context);
      if (actualMaxWidth != double.infinity) {
        result = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: actualMaxWidth),
          child: result,
        );
        result = Center(child: result);
      }
    }

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    if (margin != null) {
      result = Container(margin: margin, child: result);
    }

    return result;
  }
}

/// 반응형 그리드 뷰
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final ResponsiveValue<int>? crossAxisCount;
  final ResponsiveValue<double>? childAspectRatio;
  final ResponsiveValue<double>? crossAxisSpacing;
  final ResponsiveValue<double>? mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final actualCrossAxisCount = crossAxisCount?.value(context) ?? 
        ResponsiveUtils.getGridColumns(context);
    
    final actualChildAspectRatio = childAspectRatio?.value(context) ?? 1.0;
    
    final actualCrossAxisSpacing = crossAxisSpacing?.value(context) ?? 
        ResponsiveUtils.getCardSpacing(context);
    
    final actualMainAxisSpacing = mainAxisSpacing?.value(context) ?? 
        ResponsiveUtils.getCardSpacing(context);

    return GridView.count(
      crossAxisCount: actualCrossAxisCount,
      childAspectRatio: actualChildAspectRatio,
      crossAxisSpacing: actualCrossAxisSpacing,
      mainAxisSpacing: actualMainAxisSpacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}

/// 반응형 텍스트 스타일을 위한 빌더
class ResponsiveText extends StatelessWidget {
  final String text;
  final ResponsiveValue<TextStyle>? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.value(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// 조건부 렌더링을 위한 위젯
class ConditionalBuilder extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget? fallback;

  const ConditionalBuilder({
    super.key,
    required this.condition,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return condition ? child : (fallback ?? const SizedBox.shrink());
  }
}

/// 화면 크기별 조건부 렌더링
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final bool visibleOnWide;
  final Widget? replacement;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.visibleOnWide = true,
    this.replacement,
  });

  @override
  Widget build(BuildContext context) {
    bool shouldShow;
    
    if (ResponsiveUtils.isMobile(context)) {
      shouldShow = visibleOnMobile;
    } else if (ResponsiveUtils.isTablet(context)) {
      shouldShow = visibleOnTablet;
    } else if (ResponsiveUtils.isDesktop(context)) {
      shouldShow = visibleOnDesktop;
    } else {
      shouldShow = visibleOnWide;
    }

    return shouldShow ? child : (replacement ?? const SizedBox.shrink());
  }
}