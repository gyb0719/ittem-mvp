import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'skeleton_shimmer.dart';

/// 기본 사각형 스켈레톤 (카드, 이미지용)
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool shimmer;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: SkeletonColors.getBaseColor(context),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    return shimmer
        ? SkeletonShimmer(child: skeleton)
        : skeleton;
  }
}

/// 텍스트 스켈레톤 (제목, 본문용)
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool shimmer;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 14.0,
    this.borderRadius = 4.0,
    this.margin,
    this.shimmer = true,
  });

  /// 제목용 텍스트 스켈레톤
  const SkeletonText.title({
    super.key,
    this.width,
    this.height = 18.0,
    this.borderRadius = 4.0,
    this.margin,
    this.shimmer = true,
  });

  /// 부제목용 텍스트 스켈레톤
  const SkeletonText.subtitle({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
    this.margin,
    this.shimmer = true,
  });

  /// 본문용 텍스트 스켈레톤
  const SkeletonText.body({
    super.key,
    this.width,
    this.height = 14.0,
    this.borderRadius = 4.0,
    this.margin,
    this.shimmer = true,
  });

  /// 캡션용 텍스트 스켈레톤
  const SkeletonText.caption({
    super.key,
    this.width,
    this.height = 12.0,
    this.borderRadius = 4.0,
    this.margin,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: SkeletonColors.getBaseColor(context),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    return shimmer
        ? SkeletonShimmer(child: skeleton)
        : skeleton;
  }
}

/// 원형 스켈레톤 (아바타, 아이콘용)
class SkeletonCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;
  final bool shimmer;

  const SkeletonCircle({
    super.key,
    required this.size,
    this.margin,
    this.shimmer = true,
  });

  /// 아바타용 원형 스켈레톤
  const SkeletonCircle.avatar({
    super.key,
    this.size = 40.0,
    this.margin,
    this.shimmer = true,
  });

  /// 작은 아이콘용 원형 스켈레톤
  const SkeletonCircle.icon({
    super.key,
    this.size = 24.0,
    this.margin,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: SkeletonColors.getBaseColor(context),
        shape: BoxShape.circle,
      ),
    );

    return shimmer
        ? SkeletonShimmer(child: skeleton)
        : skeleton;
  }
}

/// 라인 스켈레톤 (구분선용)
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final bool shimmer;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 1.0,
    this.margin,
    this.shimmer = false, // 라인은 기본적으로 shimmer 효과 없음
  });

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      margin: margin,
      color: SkeletonColors.getBaseColor(context),
    );

    return shimmer
        ? SkeletonShimmer(child: skeleton)
        : skeleton;
  }
}

/// 다중 텍스트 라인을 위한 스켈레톤
class SkeletonParagraph extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double lineSpacing;
  final List<double>? lineWidths; // 각 라인의 너비 지정 (null이면 자동)
  final bool shimmer;

  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 14.0,
    this.lineSpacing = 6.0,
    this.lineWidths,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        double? width;
        
        if (lineWidths != null && index < lineWidths!.length) {
          width = lineWidths![index];
        } else {
          // 기본적으로 마지막 라인은 70% 정도로 설정
          if (index == lines - 1) {
            width = null; // 부모 너비의 70%로 설정하려면 null 사용
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < lines - 1 ? lineSpacing : 0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lineWidth = width ?? 
                (index == lines - 1 ? constraints.maxWidth * 0.7 : constraints.maxWidth);
              
              return SkeletonText(
                width: lineWidth,
                height: lineHeight,
                shimmer: shimmer,
              );
            },
          ),
        );
      }),
    );
  }
}