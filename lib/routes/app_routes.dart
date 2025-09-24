import 'package:flutter/material.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/promo_and_membership/promo_and_membership.dart';
import '../presentation/profile_and_settings/profile_and_settings.dart';
import '../presentation/finance_dashboard/finance_dashboard.dart';
import '../presentation/product_catalog/product_catalog.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/home-dashboard';
  static const String productDetail = '/product-detail';
  static const String homeDashboard = '/home-dashboard';
  static const String promoAndMembership = '/promo-and-membership';
  static const String profileAndSettings = '/profile-and-settings';
  static const String financeDashboard = '/finance-dashboard';
  static const String productCatalog = '/product-catalog';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ProductDetail(),
    productDetail: (context) => const ProductDetail(),
    homeDashboard: (context) => const HomeDashboard(),
    promoAndMembership: (context) => const PromoAndMembership(),
    profileAndSettings: (context) => const ProfileAndSettings(),
    financeDashboard: (context) => const FinanceDashboard(),
    productCatalog: (context) => const ProductCatalog(),
    // TODO: Add your other routes here
  };
}
