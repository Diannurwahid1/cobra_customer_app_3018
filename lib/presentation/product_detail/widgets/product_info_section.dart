import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoSection extends StatelessWidget {
  final String productName;
  final String price;
  final String originalPrice;
  final int discount;
  final double rating;
  final int reviewCount;
  final VoidCallback onOrderPressed;

  const ProductInfoSection({
    super.key,
    required this.productName,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            productName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),

          // Rating and Reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < rating.floor() ? 'star' : 'star_border',
                    color: AppTheme.accentLight,
                    size: 16,
                  );
                }),
              ),
              SizedBox(width: 2.w),
              Text(
                rating.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '($reviewCount ulasan)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Price Section (responsive & no overflow)
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 3.w,
                runSpacing: 1.h,
                children: [
                  // Current Price
                  Text(
                    price,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                  if (discount > 0) ...[
                    // Original price (strikethrough)
                    Text(
                      originalPrice,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    // Discount badge
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.28,
                        minHeight: 28,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '-$discount%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          SizedBox(height: 4.h),

          // Order Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: onOrderPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentLight,
                foregroundColor: Colors.black,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Pesan Sekarang',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
