import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'responsive_builder.dart';
import 'breakpoints.dart';

/// 반응형 그리드 시스템
/// 화면 크기에 따라 자동으로 컬럼 수를 조정하는 그리드
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? minCrossAxisCount;
  final int? maxCrossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minCrossAxisCount,
    this.maxCrossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.shrinkWrap = true,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = GridColumns.getColumns(screenWidth);
    
    // 최소/최대 제한 적용
    if (minCrossAxisCount != null) {
      crossAxisCount = crossAxisCount.clamp(minCrossAxisCount!, double.infinity).toInt();
    }
    if (maxCrossAxisCount != null) {
      crossAxisCount = crossAxisCount.clamp(0, maxCrossAxisCount!);
    }
    
    final actualChildAspectRatio = childAspectRatio ?? 1.0;
    final actualCrossAxisSpacing = crossAxisSpacing ?? ResponsiveUtils.getCardSpacing(context);
    final actualMainAxisSpacing = mainAxisSpacing ?? ResponsiveUtils.getCardSpacing(context);

    Widget grid = GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: actualChildAspectRatio,
      crossAxisSpacing: actualCrossAxisSpacing,
      mainAxisSpacing: actualMainAxisSpacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );

    if (padding != null) {
      grid = Padding(padding: padding!, child: grid);
    }

    return grid;
  }
}

/// 반응형 아이템 그리드 (아이템 카드 전용)
class ResponsiveItemGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveItemGrid({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getItemColumns(context);
    final spacing = ResponsiveUtils.getCardSpacing(context);
    
    // 모바일에서는 리스트뷰로, 태블릿 이상에서는 그리드뷰로
    if (ResponsiveUtils.isMobile(context) && crossAxisCount == 1) {
      Widget listView = ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      );
      
      if (padding != null) {
        listView = Padding(padding: padding!, child: listView);
      }
      
      return listView;
    }

    Widget grid = GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: 0.75, // 아이템 카드 비율
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );

    if (padding != null) {
      grid = Padding(padding: padding!, child: grid);
    }

    return grid;
  }
}

/// 반응형 카테고리 그리드
class ResponsiveCategoryGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveCategoryGrid({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getCategoryColumns(context);
    final spacing = ResponsiveUtils.getCardSpacing(context);

    Widget grid = GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: 1.0, // 카테고리는 정사각형
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );

    if (padding != null) {
      grid = Padding(padding: padding!, child: grid);
    }

    return grid;
  }
}

/// 반응형 스태거드 그리드 (Pinterest 스타일)
class ResponsiveStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveStaggeredGrid({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getGridColumns(context);
    final spacing = ResponsiveUtils.getCardSpacing(context);
    
    // 간단한 스태거드 그리드 구현
    // 실제로는 flutter_staggered_grid_view 패키지 사용 권장
    return _SimpleStaggeredGrid(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}

class _SimpleStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const _SimpleStaggeredGrid({
    required this.children,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    this.padding,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    // 컬럼별로 아이템 분배
    final columns = List.generate(crossAxisCount, (index) => <Widget>[]);
    
    for (int i = 0; i < children.length; i++) {
      final columnIndex = i % crossAxisCount;
      columns[columnIndex].add(children[i]);
      
      // 마지막 아이템이 아니라면 간격 추가
      if (i < children.length - 1 && columnIndex == crossAxisCount - 1) {
        for (var column in columns) {
          if (column.isNotEmpty && column != columns.last) {
            column.add(SizedBox(height: mainAxisSpacing));
          }
        }
      }
    }

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.asMap().entries.map((entry) {
        final index = entry.key;
        final columnChildren = entry.value;
        
        return Expanded(
          child: Column(
            children: columnChildren,
          ),
        );
      }).toList(),
    );

    // 컬럼 간 간격 추가
    if (crossAxisCount > 1) {
      row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.asMap().entries.expand((entry) {
          final index = entry.key;
          final columnChildren = entry.value;
          
          final widgets = <Widget>[
            Expanded(
              child: Column(children: columnChildren),
            ),
          ];
          
          if (index < crossAxisCount - 1) {
            widgets.add(SizedBox(width: crossAxisSpacing));
          }
          
          return widgets;
        }).toList(),
      );
    }

    if (padding != null) {
      row = Padding(padding: padding!, child: row);
    }

    return shrinkWrap 
        ? row 
        : SingleChildScrollView(
            physics: physics,
            child: row,
          );
  }
}

/// 마스터-디테일 레이아웃 (태블릿에서 많이 사용)
class ResponsiveMasterDetail extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final double? masterWidth;
  final bool forceStack;

  const ResponsiveMasterDetail({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth,
    this.forceStack = false,
  });

  @override
  Widget build(BuildContext context) {
    // 모바일이나 강제 스택 모드에서는 스택 레이아웃
    if (ResponsiveUtils.isMobile(context) || forceStack) {
      return Column(
        children: [
          master,
          Expanded(child: detail),
        ],
      );
    }

    // 태블릿 이상에서는 좌우 분할
    final actualMasterWidth = masterWidth ?? 300.0;
    
    return Row(
      children: [
        SizedBox(
          width: actualMasterWidth,
          child: master,
        ),
        const VerticalDivider(width: 1),
        Expanded(child: detail),
      ],
    );
  }
}