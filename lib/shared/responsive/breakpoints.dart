/// 반응형 디자인을 위한 브레이크포인트 정의
/// Expedia 수준의 반응형 시스템을 위한 기준점들
class BreakPoints {
  /// 모바일 디바이스 (0-599px)
  /// - 스마트폰 세로/가로 모드
  /// - 하단 네비게이션 사용
  static const double mobile = 0;
  
  /// 태블릿 디바이스 (600-1023px)  
  /// - 태블릿 세로 모드
  /// - 네비게이션 레일 사용
  static const double tablet = 600;
  
  /// 데스크톱 디바이스 (1024-1439px)
  /// - 태블릿 가로 모드 / 소형 데스크톱
  /// - 전체 사이드바 사용
  static const double desktop = 1024;
  
  /// 와이드 스크린 (1440px+)
  /// - 대형 데스크톱 / 모니터
  /// - 확장된 사이드바 사용
  static const double wide = 1440;
  
  /// 초대형 스크린 (1920px+)
  /// - 울트라와이드 모니터
  /// - 최대 컨텐츠 너비 제한 사용
  static const double ultraWide = 1920;
}

/// 그리드 시스템을 위한 컬럼 수 정의
class GridColumns {
  /// 화면 크기별 기본 컬럼 수
  static int getColumns(double screenWidth) {
    if (screenWidth >= BreakPoints.ultraWide) return 6;
    if (screenWidth >= BreakPoints.wide) return 5;
    if (screenWidth >= BreakPoints.desktop) return 4;
    if (screenWidth >= BreakPoints.tablet) return 3;
    return 2; // mobile
  }
  
  /// 카테고리 그리드 컬럼 수
  static int getCategoryColumns(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 8;
    if (screenWidth >= BreakPoints.tablet) return 6;
    return 4; // mobile
  }
  
  /// 아이템 리스트 컬럼 수
  static int getItemColumns(double screenWidth) {
    if (screenWidth >= BreakPoints.ultraWide) return 4;
    if (screenWidth >= BreakPoints.desktop) return 3;
    if (screenWidth >= BreakPoints.tablet) return 2;
    return 1; // mobile
  }
}

/// 레이아웃 패딩과 마진 값들
class ResponsiveSpacing {
  /// 기본 패딩 값
  static double getPadding(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 32.0;
    if (screenWidth >= BreakPoints.tablet) return 24.0;
    return 20.0; // mobile
  }
  
  /// 섹션 간 간격
  static double getSectionSpacing(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 48.0;
    if (screenWidth >= BreakPoints.tablet) return 32.0;
    return 24.0; // mobile
  }
  
  /// 카드 간 간격
  static double getCardSpacing(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 16.0;
    if (screenWidth >= BreakPoints.tablet) return 12.0;
    return 12.0; // mobile
  }
  
  /// 컨테이너 최대 너비
  static double getMaxContentWidth(double screenWidth) {
    if (screenWidth >= BreakPoints.ultraWide) return 1200.0;
    return double.infinity;
  }
}

/// 폰트 크기 조정
class ResponsiveFontSize {
  /// 제목 폰트 크기
  static double getTitle(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 32.0;
    if (screenWidth >= BreakPoints.tablet) return 28.0;
    return 24.0; // mobile
  }
  
  /// 서브 타이틀 폰트 크기
  static double getSubTitle(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 24.0;
    if (screenWidth >= BreakPoints.tablet) return 22.0;
    return 20.0; // mobile
  }
  
  /// 본문 폰트 크기
  static double getBody(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 16.0;
    if (screenWidth >= BreakPoints.tablet) return 15.0;
    return 14.0; // mobile
  }
  
  /// 캡션 폰트 크기
  static double getCaption(double screenWidth) {
    if (screenWidth >= BreakPoints.desktop) return 14.0;
    if (screenWidth >= BreakPoints.tablet) return 13.0;
    return 12.0; // mobile
  }
}