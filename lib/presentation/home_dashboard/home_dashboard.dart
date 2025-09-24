import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/membership_card_widget.dart';
import './widgets/notification_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          const NotificationWidget(),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileAndSettings);
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            SearchBarWidget(),

            SizedBox(height: 16),

            // Promotional carousel
            PromotionalCarouselWidget(),

            SizedBox(height: 20),

            // Membership card
            MembershipCardWidget(),

            SizedBox(height: 24),

            // Quick access shortcuts
            QuickAccessShortcutsWidget(),

            SizedBox(height: 24),

            // Product highlights
            ProductHighlightsWidget(),

            SizedBox(height: 24),

            // Recent orders
            RecentOrdersWidget(),

            SizedBox(height: 100), // Extra space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation tap
        },
      ),
    );
  }
}