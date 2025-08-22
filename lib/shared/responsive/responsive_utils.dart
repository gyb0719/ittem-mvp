import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// 반응형 디자인을 위한 유틸리티 클래스
/// 화면 크기에 따른 다양한 판단과 계산을 제공
class ResponsiveUtils {
  /// 현재 화면이 모바일 크기인지 확인
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < BreakPoints.tablet;
  }
  
  /// 현재 화면이 태블릿 크기인지 확인
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= BreakPoints.tablet && width < BreakPoints.desktop;
  }
  
  /// 현재 화면이 데스크톱 크기인지 확인
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= BreakPoints.desktop && width < BreakPoints.wide;
  }
  
  /// 현재 화면이 와이드 스크린인지 확인
  static bool isWide(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= BreakPoints.wide && width < BreakPoints.ultraWide;
  }
  
  /// 현재 화면이 울트라와이드 스크린인지 확인
  static bool isUltraWide(BuildContext context) {
    return MediaQuery.of(context).size.width >= BreakPoints.ultraWide;
  }
  
  /// 태블릿 이상 크기인지 확인 (태블릿 + 데스크톱)
  static bool isTabletUp(BuildContext context) {
    return MediaQuery.of(context).size.width >= BreakPoints.tablet;
  }
  
  /// 데스크톱 이상 크기인지 확인 (데스크톱 + 와이드)
  static bool isDesktopUp(BuildContext context) {
    return MediaQuery.of(context).size.width >= BreakPoints.desktop;
  }
  
  /// 현재 화면의 디바이스 타입을 반환
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= BreakPoints.ultraWide) return DeviceType.ultraWide;
    if (width >= BreakPoints.wide) return DeviceType.wide;
    if (width >= BreakPoints.desktop) return DeviceType.desktop;
    if (width >= BreakPoints.tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
  
  /// 현재 화면 크기에 맞는 그리드 컬럼 수를 반환
  static int getGridColumns(BuildContext context) {
    return GridColumns.getColumns(MediaQuery.of(context).size.width);
  }
  
  /// 카테고리 그리드 컬럼 수를 반환
  static int getCategoryColumns(BuildContext context) {
    return GridColumns.getCategoryColumns(MediaQuery.of(context).size.width);
  }
  
  /// 아이템 리스트 컬럼 수를 반환
  static int getItemColumns(BuildContext context) {
    return GridColumns.getItemColumns(MediaQuery.of(context).size.width);
  }
  
  /// 화면 크기에 맞는 패딩 값을 반환
  static double getPadding(BuildContext context) {
    return ResponsiveSpacing.getPadding(MediaQuery.of(context).size.width);
  }
  
  /// 섹션 간 간격을 반환
  static double getSectionSpacing(BuildContext context) {
    return ResponsiveSpacing.getSectionSpacing(MediaQuery.of(context).size.width);
  }
  
  /// 카드 간 간격을 반환
  static double getCardSpacing(BuildContext context) {
    return ResponsiveSpacing.getCardSpacing(MediaQuery.of(context).size.width);
  }
  
  /// 최대 컨텐츠 너비를 반환
  static double getMaxContentWidth(BuildContext context) {
    return ResponsiveSpacing.getMaxContentWidth(MediaQuery.of(context).size.width);
  }
  
  /// 반응형 폰트 크기들
  static double getTitleFontSize(BuildContext context) {
    return ResponsiveFontSize.getTitle(MediaQuery.of(context).size.width);
  }
  
  static double getSubTitleFontSize(BuildContext context) {
    return ResponsiveFontSize.getSubTitle(MediaQuery.of(context).size.width);
  }
  
  static double getBodyFontSize(BuildContext context) {
    return ResponsiveFontSize.getBody(MediaQuery.of(context).size.width);
  }
  
  static double getCaptionFontSize(BuildContext context) {
    return ResponsiveFontSize.getCaption(MediaQuery.of(context).size.width);
  }
  
  /// 네비게이션 타입을 결정
  static NavigationType getNavigationType(BuildContext context) {
    if (isDesktopUp(context)) return NavigationType.sidebar;
    if (isTabletUp(context)) return NavigationType.rail;
    return NavigationType.bottomBar;
  }
  
  /// 화면 방향 확인
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  
  /// 화면 비율 계산
  static double getAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width / size.height;
  }
  
  /// 안전한 영역 높이를 고려한 사용 가능한 높이
  static double getUsableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom;
  }
  
  /// 키보드가 올라왔을 때의 사용 가능한 높이
  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom - 
           mediaQuery.viewInsets.bottom;
  }
  
  /// 터치 영역 크기 (접근성을 위한 최소 터치 영역)
  static double getTouchTargetSize(BuildContext context) {
    // 모바일에서는 44px, 데스크톱에서는 32px
    return isMobile(context) ? 44.0 : 32.0;
  }
  
  /// 스크롤바 너비
  static double getScrollbarWidth(BuildContext context) {
    return isDesktopUp(context) ? 8.0 : 0.0;
  }
}

/// 디바이스 타입 열거형
enum DeviceType {
  mobile,
  tablet,
  desktop,
  wide,
  ultraWide,
}

/// 네비게이션 타입 열거형
enum NavigationType {
  bottomBar,  // 하단 네비게이션 바
  rail,       // 네비게이션 레일
  sidebar,    // 사이드바
}

/// 레이아웃 타입 열거형
enum LayoutType {
  stack,      // 세로 스택 (모바일)
  split,      // 2분할 (태블릿)
  threColumn, // 3컬럼 (데스크톱)
  fourColumn, // 4컬럼 (와이드)
}