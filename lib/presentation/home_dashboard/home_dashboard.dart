import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/membership_card_widget.dart';
import './widgets/product_highlights_widget.dart';
import './widgets/promotional_carousel_widget.dart';
import './widgets/quick_access_shortcuts_widget.dart';
import './widgets/recent_orders_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentBottomIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh dashboard data
      });
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    // Navigate based on bottom nav selection
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/product-catalog');
        break;
      case 2:
        Navigator.pushNamed(context, '/finance-dashboard');
        break;
      case 3:
        Navigator.pushNamed(context, '/promo-and-membership');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile-and-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Sticky Header with Search Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                toolbarHeight: 8.h,
                flexibleSpace: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(
                          onTap: () {
                            Navigator.pushNamed(context, '/product-catalog');
                          },
                          hintText: 'Cari produk dental...',
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: () {
                          // Handle notifications
                        },
                        child: Container(
                          width: 12.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                CustomIconWidget(
                                  iconName: 'notifications',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  size: 24,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 2.w,
                                    height: 1.h,
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Welcome Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Pagi,',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Dr. Ahmad Wijaya',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Promotional Carousel
                    PromotionalCarouselWidget(),

                    SizedBox(height: 4.h),

                    // Quick Access Shortcuts
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Akses Cepat',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    QuickAccessShortcutsWidget(),

                    SizedBox(height: 4.h),

                    // Membership Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Status Membership',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    MembershipCardWidget(),

                    SizedBox(height: 4.h),

                    // Product Highlights
                    ProductHighlightsWidget(),

                    SizedBox(height: 4.h),

                    // Recent Orders
                    RecentOrdersWidget(),

                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8.0,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentBottomIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'inventory_2',
              color: _currentBottomIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: _currentBottomIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Keuangan',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'local_offer',
              color: _currentBottomIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Promo',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
