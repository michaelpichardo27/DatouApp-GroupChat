import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const LoadingSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _JobSkeletonCard(),
        );
      },
    );
  }
}

// MARK: - Job Skeleton Card
class _JobSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge Skeleton
                _SkeletonBadge(),
                const SizedBox(width: 12),
                
                // Title and Budget Skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonText(
                        height: 20,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 8),
                      _SkeletonText(
                        height: 16,
                        width: 120,
                      ),
                    ],
                  ),
                ),
                
                // Location Badge Skeleton
                _SkeletonBadge(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Description Skeleton
            _SkeletonText(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            _SkeletonText(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            _SkeletonText(height: 16, width: 0.7),
            
            const SizedBox(height: 16),
            
            // Requirements Skeleton
            Row(
              children: [
                _SkeletonChip(),
                const SizedBox(width: 8),
                _SkeletonChip(),
                const SizedBox(width: 8),
                _SkeletonChip(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Footer Row Skeleton
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _SkeletonIcon(),
                      const SizedBox(width: 6),
                      _SkeletonText(height: 14, width: 100),
                    ],
                  ),
                ),
                _SkeletonText(height: 14, width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Skeleton Components
class _SkeletonText extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _SkeletonText({
    required this.height,
    required this.width,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _SkeletonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _SkeletonIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// MARK: - Shimmer Effect (Optional Enhancement)
class ShimmerLoadingSkeleton extends StatefulWidget {
  final int itemCount;

  const ShimmerLoadingSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  State<ShimmerLoadingSkeleton> createState() => _ShimmerLoadingSkeletonState();
}

class _ShimmerLoadingSkeletonState extends State<ShimmerLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Colors.transparent,
                Colors.white,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: LoadingSkeleton(itemCount: widget.itemCount),
        );
      },
    );
  }
}

// MARK: - Compact Loading Skeleton
class CompactLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const CompactLoadingSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _CompactJobSkeleton(),
        );
      },
    );
  }
}

class _CompactJobSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Skeleton
            _SkeletonText(height: 18, width: 0.8),
            const SizedBox(height: 8),
            
            // Budget Skeleton
            _SkeletonText(height: 16, width: 100),
            const SizedBox(height: 12),
            
            // Description Skeleton
            _SkeletonText(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            _SkeletonText(height: 14, width: 0.6),
            const SizedBox(height: 12),
            
            // Footer Skeleton
            Row(
              children: [
                _SkeletonIcon(),
                const SizedBox(width: 6),
                _SkeletonText(height: 12, width: 80),
                const Spacer(),
                _SkeletonText(height: 12, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Preview
class LoadingSkeletonPreview extends StatelessWidget {
  const LoadingSkeletonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: LoadingSkeleton(itemCount: 3),
          ),
          Expanded(
            child: CompactLoadingSkeleton(itemCount: 3),
          ),
        ],
      ),
    );
  }
}
