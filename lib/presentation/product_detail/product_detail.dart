import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/product_image_gallery.dart';
import './widgets/product_info_section.dart';
import './widgets/product_tabs_section.dart';
import './widgets/related_products_section.dart';
import './widgets/sticky_bottom_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;

  // Mock product data - Updated with new dental products
  final Map<String, dynamic> productData = {
    "id": 100,
    "name": "C-Puma Dental Micromotor",
    "sku": "1555",
    "price": "Rp 15.500.000",
    "originalPrice": "Rp 18.000.000",
    "discount": 14,
    "rating": 4.9,
    "reviewCount": 18,
    "images": [
      "https://www.cobradental.co.id/userfiles/product/6805fcb91d473.jpg",
      "https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=800&h=600&fit=crop",
    ],
    "description":
        """Dental micromotor C-Puma dengan teknologi canggih untuk berbagai prosedur dental. Dilengkapi dengan power 120W yang memberikan tenaga optimal, kecepatan variabel 100–200.000 rpm yang dapat disesuaikan dengan kebutuhan prosedur.

Fitur LED dengan intensitas >25.000 lux memberikan pencahayaan yang sempurna untuk visibilitas maksimal selama prosedur. Torsi 3.5 N·cm memastikan performa yang stabil dan konsisten. Dengan berat hanya 87 g, memberikan kenyamanan optimal bagi dokter selama penggunaan jangka panjang.

Desain ergonomis dan material berkualitas tinggi menjadikan C-Puma pilihan ideal untuk klinik dental modern. Kompatibel dengan berbagai attachment dan mudah untuk maintenance.""",
    "specifications": [
      {"label": "SKU", "value": "1555"},
      {"label": "Power", "value": "120W"},
      {"label": "Kecepatan", "value": "100–200.000 rpm"},
      {"label": "LED Intensity", "value": ">25.000 lux"},
      {"label": "Torsi", "value": "3.5 N·cm"},
      {"label": "Berat", "value": "87 g"},
      {"label": "Kategori", "value": "Dental Equipment"},
      {"label": "Brand", "value": "Woodpecker"},
      {"label": "Garansi", "value": "2 tahun"},
      {"label": "Asal", "value": "Import"},
    ],
    "reviews": [
      {
        "customerName": "Dr. Andi Wijaya",
        "rating": 5,
        "date": "12 Oct 2024",
        "comment":
            "C-Puma sangat membantu dalam prosedur dental. Power yang kuat dan LED yang terang membuat pekerjaan menjadi lebih mudah dan presisi.",
      },
      {
        "customerName": "Dr. Maya Sari",
        "rating": 5,
        "date": "08 Oct 2024",
        "comment":
            "Kualitas build yang sangat baik, ringan di tangan, dan performa motor yang sangat stabil. Highly recommended untuk praktik dental.",
      },
      {
        "customerName": "Dr. Budi Hartono",
        "rating": 4,
        "date": "05 Oct 2024",
        "comment":
            "Produk berkualitas dengan harga yang reasonable. LED sangat membantu untuk pencahayaan area kerja. Overall sangat puas dengan performa.",
      },
    ],
  };

  final List<Map<String, dynamic>> relatedProducts = [
    {
      "id": 101,
      "name": "Light Curing Woodpecker LED D",
      "price": "Rp 8.500.000",
      "rating": 4.8,
      "image":
          "https://www.cobradental.co.id/userfiles/product/6805f9e653f38.png",
    },
    {
      "id": 102,
      "name": "Ultrasonic Scaller UDS-K LED",
      "price": "Rp 12.000.000",
      "rating": 4.9,
      "image":
          "https://www.cobradental.co.id/userfiles/product/6805f5233b133.png",
    },
    {
      "id": 103,
      "name": "Dental Diode Laser LX 16 PLUS",
      "price": "Rp 35.000.000",
      "rating": 4.7,
      "image":
          "https://www.cobradental.co.id/userfiles/product/6805fb6add478.png",
    },
    {
      "id": 104,
      "name": "Light Curing LED B Woodpecker",
      "price": "Rp 7.200.000",
      "rating": 4.6,
      "image":
          "https://www.cobradental.co.id/userfiles/product/6805f699819c3.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky bottom bar when scrolled past product info section
    final shouldShow = _scrollController.offset > 60.h;
    if (shouldShow != _showStickyBar) {
      setState(() {
        _showStickyBar = shouldShow;
      });
    }
  }

  void _onSharePressed() {
    HapticFeedback.selectionClick();
    // Share functionality would generate product links for B2B communication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link produk telah disalin ke clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onOrderPressed() {
    HapticFeedback.lightImpact();
    // Navigate directly to checkout process with product data
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'product': {
          'id': productData['id'],
          'name': productData['name'],
          'price': productData['price'],
          'image': (productData['images'] as List).first,
        },
        'quantity': 1,
      },
    );
  }

  void _onAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk ditambahkan ke keranjang'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBuyNow() {
    HapticFeedback.lightImpact();
    // Navigate directly to checkout process with product data and quantity
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'product': {
          'id': productData['id'],
          'name': productData['name'],
          'price': productData['price'],
          'image': (productData['images'] as List).first,
        },
        'quantity': 1, // Default quantity, will be updated by sticky bar
        'directCheckout': true, // Flag to indicate direct checkout
      },
    );
  }

  void _onRelatedProductTap(Map<String, dynamic> product) {
    // Navigate to another product detail (would maintain catalog scroll position)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka detail ${product['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 50.h,
                pinned: true,
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _onSharePressed,
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageGallery(
                    images: (productData['images'] as List).cast<String>(),
                    productName: productData['name'] as String,
                  ),
                ),
              ),

              // Product Info Section
              SliverToBoxAdapter(
                child: ProductInfoSection(
                  productName: productData['name'] as String,
                  price: productData['price'] as String,
                  originalPrice: productData['originalPrice'] as String,
                  discount: productData['discount'] as int,
                  rating: productData['rating'] as double,
                  reviewCount: productData['reviewCount'] as int,
                  onOrderPressed: _onOrderPressed,
                ),
              ),

              // Product Tabs Section
              SliverToBoxAdapter(
                child: ProductTabsSection(
                  description: productData['description'] as String,
                  specifications:
                      (productData['specifications'] as List)
                          .cast<Map<String, String>>(),
                  reviews:
                      (productData['reviews'] as List)
                          .cast<Map<String, dynamic>>(),
                ),
              ),

              // Related Products Section
              SliverToBoxAdapter(
                child: RelatedProductsSection(
                  relatedProducts: relatedProducts,
                  onProductTap: _onRelatedProductTap,
                ),
              ),

              // Bottom spacing for sticky bar
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            ],
          ),

          // Sticky Bottom Bar
          if (_showStickyBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StickyBottomBar(
                price: productData['price'] as String,
                onAddToCart: _onAddToCart,
                onBuyNow: _onBuyNow,
              ),
            ),
        ],
      ),
    );
  }
}
