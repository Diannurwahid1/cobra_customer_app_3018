import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './product_card_widget.dart';

class ProductGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final Function(Map<String, dynamic>)? onProductTap;
  final Function(Map<String, dynamic>)? onOrderTap;

  const ProductGridWidget({
    super.key,
    required this.products,
    this.isLoading = false,
    this.onLoadMore,
    this.onProductTap,
    this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Responsive grid columns
    int crossAxisCount;
    if (width >= 1024) {
      crossAxisCount = 4;
    } else if (width >= 768) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    // Responsive spacing
    final double spacing = (width >= 768) ? 3.w : 4.w; // slightly wider spacing on phones

    // Responsive card aspect ratio (width / height)
    final double cardAspectRatio = crossAxisCount >= 4
        ? 0.68
        : (crossAxisCount == 3 ? 0.7 : 0.72);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Trigger load more slightly before reaching the end for smoother UX
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100 &&
            !isLoading) {
          onLoadMore?.call();
        }
        return false;
      },
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 8.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: cardAspectRatio,
        ),
        itemCount: products.length + (isLoading ? 4 : 0),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return _buildSkeletonCard(context);
          }

          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ProductCardWidget(
              product: product,
              onTap: () => onProductTap?.call(product),
              onOrderTap: () => onOrderTap?.call(product),
              onWishlistTap: () => _handleWishlist(product),
              onShareTap: () => _handleShare(product),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double imgSize = constraints.maxWidth - 4.w; // square-ish image
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(3.w, 2.w, 3.w, 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: imgSize * 0.75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'image',
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: 1.6.h),
                Container(
                  height: 1.8.h,
                  width: constraints.maxWidth * 0.9,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 1.4.h,
                  width: constraints.maxWidth * 0.7,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 3.6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleWishlist(Map<String, dynamic> product) {
    // Handle wishlist functionality
    print('Added to wishlist: ${product['name']}');
  }

  void _handleShare(Map<String, dynamic> product) {
    // Handle share functionality
    print('Sharing product: ${product['name']}');
  }
}
