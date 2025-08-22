import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_result.dart';

final searchAnalyticsServiceProvider = Provider<SearchAnalyticsService>((ref) {
  return SearchAnalyticsService();
});

class SearchAnalyticsService {
  final List<SearchAnalytics> _analytics = [];
  final String _sessionId = _generateSessionId();
  
  // 검색 이벤트 추적
  Future<void> trackSearch({
    required String query,
    int? resultsCount,
    Map<String, dynamic>? filters,
    String source = 'text', // text, voice, barcode, image
  }) async {
    final analytics = SearchAnalytics(
      sessionId: _sessionId,
      query: query,
      timestamp: DateTime.now(),
      resultsCount: resultsCount,
      filters: filters,
      source: source,
    );
    
    _analytics.add(analytics);
    await _sendAnalytics(analytics);
  }

  // 검색 결과 클릭 추적
  Future<void> trackResultClick({
    required String query,
    required String itemId,
    required int position,
    int? searchDuration,
  }) async {
    // 기존 검색 이벤트 업데이트
    final searchEvent = _analytics
        .where((a) => a.query == query)
        .lastOrNull;
    
    if (searchEvent != null) {
      final updatedAnalytics = searchEvent.copyWith(
        clickedItemId: itemId,
        clickPosition: position,
        searchDuration: searchDuration,
      );
      
      final index = _analytics.indexOf(searchEvent);
      _analytics[index] = updatedAnalytics;
      
      await _sendAnalytics(updatedAnalytics);
    }
  }

  // 검색어 정제 추적 (사용자가 검색어를 변경한 경우)
  Future<void> trackQueryRefinement({
    required String originalQuery,
    required String refinedQuery,
  }) async {
    final analytics = SearchAnalytics(
      sessionId: _sessionId,
      query: originalQuery,
      timestamp: DateTime.now(),
      refinedQuery: refinedQuery,
    );
    
    _analytics.add(analytics);
    await _sendAnalytics(analytics);
  }

  // 검색 성과 메트릭 계산
  SearchPerformanceMetrics getSearchPerformance() {
    if (_analytics.isEmpty) {
      return SearchPerformanceMetrics.empty();
    }

    final totalSearches = _analytics.length;
    final searchesWithResults = _analytics.where((a) => (a.resultsCount ?? 0) > 0).length;
    final searchesWithClicks = _analytics.where((a) => a.clickedItemId != null).length;
    
    final avgResultsCount = _analytics
        .where((a) => a.resultsCount != null)
        .map((a) => a.resultsCount!)
        .fold(0, (sum, count) => sum + count) / 
        _analytics.where((a) => a.resultsCount != null).length;

    final avgClickPosition = _analytics
        .where((a) => a.clickPosition != null)
        .map((a) => a.clickPosition!)
        .fold(0, (sum, pos) => sum + pos) /
        searchesWithClicks;

    return SearchPerformanceMetrics(
      totalSearches: totalSearches,
      successRate: searchesWithResults / totalSearches,
      clickThroughRate: searchesWithClicks / totalSearches,
      averageResultsCount: avgResultsCount,
      averageClickPosition: avgClickPosition,
      zeroResultsRate: (totalSearches - searchesWithResults) / totalSearches,
    );
  }

  // 인기 검색어 분석
  List<SearchTerm> getPopularSearchTerms({int limit = 20}) {
    final termCounts = <String, int>{};
    final termData = <String, SearchTermData>{};
    
    for (final analytics in _analytics) {
      final query = analytics.query.toLowerCase().trim();
      if (query.isNotEmpty) {
        termCounts[query] = (termCounts[query] ?? 0) + 1;
        
        // 추가 데이터 수집
        if (!termData.containsKey(query)) {
          termData[query] = SearchTermData(
            totalSearches: 0,
            totalClicks: 0,
            totalResults: 0,
            lastSearched: analytics.timestamp,
          );
        }
        
        final data = termData[query]!;
        termData[query] = data.copyWith(
          totalSearches: data.totalSearches + 1,
          totalClicks: data.totalClicks + (analytics.clickedItemId != null ? 1 : 0),
          totalResults: data.totalResults + (analytics.resultsCount ?? 0),
          lastSearched: analytics.timestamp.isAfter(data.lastSearched) 
              ? analytics.timestamp 
              : data.lastSearched,
        );
      }
    }
    
    // 검색 빈도로 정렬
    final sortedTerms = termCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedTerms.take(limit).map((entry) {
      final query = entry.key;
      final data = termData[query]!;
      
      return SearchTerm(
        query: query,
        searchCount: entry.value,
        clickThroughRate: data.totalClicks / data.totalSearches,
        averageResults: data.totalResults / data.totalSearches,
        lastSearched: data.lastSearched,
        trendScore: _calculateTrendScore(query, data),
      );
    }).toList();
  }

  // 검색 패턴 분석
  SearchPatternAnalysis getSearchPatterns() {
    final hourlySearches = <int, int>{};
    final searchSources = <String, int>{};
    final queryLengths = <int>[];
    
    for (final analytics in _analytics) {
      // 시간대별 검색 패턴
      final hour = analytics.timestamp.hour;
      hourlySearches[hour] = (hourlySearches[hour] ?? 0) + 1;
      
      // 검색 소스별 분포
      final source = analytics.source ?? 'text';
      searchSources[source] = (searchSources[source] ?? 0) + 1;
      
      // 검색어 길이 분포
      queryLengths.add(analytics.query.length);
    }
    
    final avgQueryLength = queryLengths.isNotEmpty
        ? queryLengths.reduce((a, b) => a + b) / queryLengths.length
        : 0.0;
    
    return SearchPatternAnalysis(
      hourlyDistribution: hourlySearches,
      sourceDistribution: searchSources,
      averageQueryLength: avgQueryLength,
      totalSessions: 1, // 현재 세션만 추적중
    );
  }

  // 사용자 검색 여정 분석
  List<SearchJourney> getSearchJourneys() {
    final journeys = <SearchJourney>[];
    
    // 세션 내에서 연속된 검색들을 여정으로 그룹화
    SearchJourney? currentJourney;
    
    for (final analytics in _analytics) {
      if (currentJourney == null || 
          analytics.timestamp.difference(currentJourney.endTime).inMinutes > 5) {
        // 새로운 여정 시작 (5분 이상 간격이 나면 새 여정으로 간주)
        currentJourney = SearchJourney(
          sessionId: _sessionId,
          startTime: analytics.timestamp,
          endTime: analytics.timestamp,
          searches: [analytics],
        );
        journeys.add(currentJourney);
      } else {
        // 기존 여정에 검색 추가
        currentJourney = currentJourney.copyWith(
          endTime: analytics.timestamp,
          searches: [...currentJourney.searches, analytics],
        );
        journeys[journeys.length - 1] = currentJourney;
      }
    }
    
    return journeys;
  }

  // Private methods
  
  Future<void> _sendAnalytics(SearchAnalytics analytics) async {
    // TODO: 실제 분석 서버로 데이터 전송
    // 지금은 로컬에만 저장
    print('Analytics: ${analytics.toString()}');
  }

  double _calculateTrendScore(String query, SearchTermData data) {
    // 최근 검색 빈도와 클릭률을 기반으로 트렌드 점수 계산
    final recentWeight = _getRecencyWeight(data.lastSearched);
    final ctrWeight = data.totalClicks / data.totalSearches;
    
    return (recentWeight * 0.6 + ctrWeight * 0.4) * 10;
  }

  double _getRecencyWeight(DateTime lastSearched) {
    final hoursSinceLastSearch = DateTime.now().difference(lastSearched).inHours;
    
    if (hoursSinceLastSearch <= 1) return 1.0;
    if (hoursSinceLastSearch <= 6) return 0.8;
    if (hoursSinceLastSearch <= 24) return 0.6;
    if (hoursSinceLastSearch <= 72) return 0.4;
    return 0.2;
  }

  static String _generateSessionId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void dispose() {
    _analytics.clear();
  }
}

// 데이터 클래스들

class SearchPerformanceMetrics {
  final int totalSearches;
  final double successRate;
  final double clickThroughRate;
  final double averageResultsCount;
  final double averageClickPosition;
  final double zeroResultsRate;

  SearchPerformanceMetrics({
    required this.totalSearches,
    required this.successRate,
    required this.clickThroughRate,
    required this.averageResultsCount,
    required this.averageClickPosition,
    required this.zeroResultsRate,
  });

  factory SearchPerformanceMetrics.empty() {
    return SearchPerformanceMetrics(
      totalSearches: 0,
      successRate: 0.0,
      clickThroughRate: 0.0,
      averageResultsCount: 0.0,
      averageClickPosition: 0.0,
      zeroResultsRate: 0.0,
    );
  }
}

class SearchTerm {
  final String query;
  final int searchCount;
  final double clickThroughRate;
  final double averageResults;
  final DateTime lastSearched;
  final double trendScore;

  SearchTerm({
    required this.query,
    required this.searchCount,
    required this.clickThroughRate,
    required this.averageResults,
    required this.lastSearched,
    required this.trendScore,
  });
}

class SearchTermData {
  final int totalSearches;
  final int totalClicks;
  final int totalResults;
  final DateTime lastSearched;

  SearchTermData({
    required this.totalSearches,
    required this.totalClicks,
    required this.totalResults,
    required this.lastSearched,
  });

  SearchTermData copyWith({
    int? totalSearches,
    int? totalClicks,
    int? totalResults,
    DateTime? lastSearched,
  }) {
    return SearchTermData(
      totalSearches: totalSearches ?? this.totalSearches,
      totalClicks: totalClicks ?? this.totalClicks,
      totalResults: totalResults ?? this.totalResults,
      lastSearched: lastSearched ?? this.lastSearched,
    );
  }
}

class SearchPatternAnalysis {
  final Map<int, int> hourlyDistribution;
  final Map<String, int> sourceDistribution;
  final double averageQueryLength;
  final int totalSessions;

  SearchPatternAnalysis({
    required this.hourlyDistribution,
    required this.sourceDistribution,
    required this.averageQueryLength,
    required this.totalSessions,
  });
}

class SearchJourney {
  final String sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final List<SearchAnalytics> searches;

  SearchJourney({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.searches,
  });

  Duration get duration => endTime.difference(startTime);
  int get searchCount => searches.length;
  bool get hasSuccessfulSearch => searches.any((s) => s.clickedItemId != null);

  SearchJourney copyWith({
    String? sessionId,
    DateTime? startTime,
    DateTime? endTime,
    List<SearchAnalytics>? searches,
  }) {
    return SearchJourney(
      sessionId: sessionId ?? this.sessionId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      searches: searches ?? this.searches,
    );
  }
}