import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onOrderTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onShareTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onOrderTap,
    this.onWishlistTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            LayoutBuilder(
              builder: (context, constraints) {
                // Maintain a consistent aspect ratio across devices
                final imageHeight = constraints.maxWidth * 0.72; // 4:3-ish
                return Container(
                  width: double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    color: colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: product['image'] as String? ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 2.2.w, 3.w, 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'] as String? ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * 0.98,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.8.h),

                  // Price
                  Text(
                    product['price'] as String? ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * 0.98,
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Tambah ke Wishlist'),
              onTap: () {
                Navigator.pop(context);
                onWishlistTap?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Bagikan'),
              onTap: () {
                Navigator.pop(context);
                onShareTap?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'search',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Lihat Produk Serupa'),
              onTap: () {
                Navigator.pop(context);
                // Handle view similar products
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
