import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/order_status_timeline.dart';
import './widgets/delivery_tracking_widget.dart';

/// Order Tracking screen for B2B dental customers to monitor comprehensive order status
class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late AnimationController _statusController;
  OrderData? currentOrder;
  bool isLoading = false;
  DateTime? lastSyncTime;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _statusController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadOrderData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  /// Load order data from external POS system integration
  Future<void> _loadOrderData() async {
    setState(() => isLoading = true);

    // Simulate API call to external POS system
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      currentOrder = _getMockOrderData();
      lastSyncTime = DateTime.now();
      isLoading = false;
    });

    _statusController.forward();
  }

  /// Refresh order tracking information with haptic feedback
  Future<void> _refreshTracking() async {
    _refreshController.forward();
    HapticFeedback.lightImpact();

    await _loadOrderData();
    _refreshController.reverse();

    // Show refresh confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.refresh, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Status pesanan telah diperbarui'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle order-specific actions based on current status
  void _handleOrderAction(OrderAction action) {
    switch (action) {
      case OrderAction.cancel:
        _showCancelDialog();
        break;
      case OrderAction.contactAdmin:
        _contactAdminSupport();
        break;
      case OrderAction.trackShipment:
        _showTrackingDetails();
        break;
      case OrderAction.rateOrder:
        _showRatingDialog();
        break;
      case OrderAction.reorder:
        _handleReorder();
        break;
      case OrderAction.downloadReceipt:
        _downloadReceipt();
        break;
    }
  }

  /// Show order cancellation dialog with confirmation
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Batalkan Pesanan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin membatalkan pesanan ini?',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pembatalan hanya dapat dilakukan dalam status Pending',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kembali'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            onPressed: () {
              // Handle cancellation
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Permintaan pembatalan telah dikirim'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            child: Text('Batalkan Pesanan'),
          ),
        ],
      ),
    );
  }

  /// Contact admin support for order inquiries
  void _contactAdminSupport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hubungi Admin',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              Icons.phone,
              'Telepon',
              '+62 21 1234 5678',
              () {
                Navigator.pop(context);
                // Handle phone call
              },
            ),
            _buildContactOption(
              Icons.email,
              'Email',
              'support@cobradental.co.id',
              () {
                Navigator.pop(context);
                // Handle email
              },
            ),
            _buildContactOption(
              Icons.chat,
              'Live Chat',
              'Chat dengan customer service',
              () {
                Navigator.pop(context);
                // Handle live chat
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
          ],
        ),
      ),
    );
  }

  /// Build contact option tile
  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryLight),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppTheme.textSecondaryLight,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// Show detailed shipment tracking with map view
  void _showTrackingDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Detail Pengiriman',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Order ID: ${currentOrder?.id ?? ''}',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kurir: Cobra Logistics',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estimasi Pengiriman: ${_formatDate(DateTime.now().add(const Duration(days: 2)))}',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DeliveryTrackingWidget(
                orderId: currentOrder?.id ?? '',
                courierName: 'Cobra Logistics',
                estimatedDelivery: DateTime.now().add(
                  const Duration(days: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show rating dialog for completed orders
  void _showRatingDialog() {
    int rating = 0;
    String feedback = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(
            'Beri Rating Pesanan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bagaimana pengalaman Anda dengan pesanan ini?',
                style: GoogleFonts.inter(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setStateDialog(() {
                        rating = index + 1;
                      });
                      HapticFeedback.selectionClick();
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: AppTheme.accentLight,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Berikan feedback (opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => feedback = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Terima kasih atas rating Anda!',
                          ),
                          backgroundColor: AppTheme.successLight,
                        ),
                      );
                    }
                  : null,
              child: Text('Kirim Rating'),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle reorder functionality
  void _handleReorder() {
    Navigator.pushNamed(context, AppRoutes.productCatalog);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item pesanan telah ditambahkan ke keranjang'),
      ),
    );
  }

  /// Download receipt for completed orders
  void _downloadReceipt() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Receipt berhasil diunduh'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String orderId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'ORD-2025-001';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lacak Pesanan',
        actions: [
          IconButton(
            onPressed: _refreshTracking,
            icon: AnimatedBuilder(
              animation: _refreshController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _refreshController.value * 2.0 * 3.14159,
                  child: Icon(Icons.refresh),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentOrder == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppTheme.textDisabledLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pesanan tidak ditemukan',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshTracking,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryLight,
                                AppTheme.primaryLight.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pesanan #${currentOrder!.orderNumber}',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.onPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(currentOrder!.orderDate),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color:
                                            AppTheme.onPrimaryLight.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(currentOrder!.status),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _getStatusText(currentOrder!.status),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Status Timeline
                        OrderStatusTimeline(
                          currentStatus: currentOrder!.status,
                          statusHistory: currentOrder!.statusHistory,
                          animation: _statusController,
                        ),

                        const SizedBox(height: 24),

                        // Order Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Pesanan',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...currentOrder!.items
                                  .map((item) => Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: item.imageUrl,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: AppTheme.surfaceLight,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: AppTheme.surfaceLight,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: AppTheme
                                                        .textDisabledLight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Qty: ${item.quantity}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: AppTheme
                                                          .textSecondaryLight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Order Actions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aksi Pesanan',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (currentOrder!.status ==
                                  OrderStatus.pending) ...[
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _handleOrderAction(OrderAction.cancel),
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Batalkan Pesanan'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.errorLight,
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              ElevatedButton.icon(
                                onPressed: () => _handleOrderAction(
                                    OrderAction.contactAdmin),
                                icon: const Icon(Icons.support_agent),
                                label: const Text('Hubungi Admin'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryLight,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                              ),
                              if (currentOrder!.status ==
                                  OrderStatus.shipping) ...[
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _handleOrderAction(
                                      OrderAction.trackShipment),
                                  icon: const Icon(Icons.local_shipping),
                                  label: const Text('Lacak Pengiriman'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.successLight,
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                  ),
                                ),
                              ],
                              if (currentOrder!.status ==
                                  OrderStatus.completed) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _handleOrderAction(
                                            OrderAction.rateOrder),
                                        icon: const Icon(Icons.star),
                                        label: const Text('Beri Rating'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.accentLight,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _handleOrderAction(
                                            OrderAction.reorder),
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Pesan Lagi'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.secondaryLight,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Last Sync Info
                        if (lastSyncTime != null) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sync,
                                    size: 12,
                                    color: AppTheme.textSecondaryLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Terakhir diperbarui ${_formatTime(lastSyncTime!)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: AppTheme.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  /// Get status color based on order status
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningLight;
      case OrderStatus.approved:
        return AppTheme.primaryLight;
      case OrderStatus.processing:
        return const Color(0xFFFF8C00);
      case OrderStatus.shipping:
        return AppTheme.successLight;
      case OrderStatus.completed:
        return AppTheme.secondaryLight;
      case OrderStatus.cancelled:
        return AppTheme.errorLight;
    }
  }

  /// Get status text in Indonesian
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.approved:
        return 'Disetujui Admin';
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.shipping:
        return 'Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Format time for sync display
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }

  /// Mock order data for demonstration
  OrderData _getMockOrderData() {
    return OrderData(
      id: 'ord_001',
      orderNumber: '2025-001-CBR',
      orderDate: DateTime.now().subtract(const Duration(hours: 6)),
      status: OrderStatus.processing,
      totalAmount: 45500000,
      items: [
        OrderItem(
          id: '1',
          productId: 'prod_001',
          name: 'Dental Unit Chair Premium',
          description: 'High-quality dental chair with LED light',
          quantity: 1,
          unitPrice: 25000000,
          imageUrl:
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
          supplierName: 'Cobra Medical Equipment',
          sku: 'DUC-PREM-001',
        ),
        OrderItem(
          id: '2',
          productId: 'prod_002',
          name: 'Autoclave Sterilizer 18L',
          description: 'Professional autoclave for dental instruments',
          quantity: 2,
          unitPrice: 8500000,
          imageUrl:
              'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
          supplierName: 'Sterilization Pro',
          sku: 'AUT-18L-002',
        ),
      ],
      statusHistory: [
        StatusHistoryItem(
          status: OrderStatus.pending,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          description: 'Pesanan diterima dan menunggu persetujuan admin',
        ),
        StatusHistoryItem(
          status: OrderStatus.approved,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          description: 'Pesanan disetujui oleh admin departemen',
        ),
        StatusHistoryItem(
          status: OrderStatus.processing,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          description: 'Pesanan sedang diproses dan disiapkan',
        ),
      ],
      shippingAddress: 'Jl. Dental Care No. 123, Jakarta Selatan',
      estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
    );
  }
}

/// Order status enum
enum OrderStatus {
  pending,
  approved,
  processing,
  shipping,
  completed,
  cancelled,
}

/// Order action enum
enum OrderAction {
  cancel,
  contactAdmin,
  trackShipment,
  rateOrder,
  reorder,
  downloadReceipt,
}

/// Order data model
class OrderData {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<StatusHistoryItem> statusHistory;
  final String shippingAddress;
  final DateTime? estimatedDelivery;

  const OrderData({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.statusHistory,
    required this.shippingAddress,
    this.estimatedDelivery,
  });
}

/// Order item model
class OrderItem {
  final String id;
  final String productId;
  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final String imageUrl;
  final String supplierName;
  final String sku;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.imageUrl,
    required this.supplierName,
    required this.sku,
  });

  double get totalPrice => unitPrice * quantity;
}

/// Status history item model
class StatusHistoryItem {
  final OrderStatus status;
  final DateTime timestamp;
  final String description;

  const StatusHistoryItem({
    required this.status,
    required this.timestamp,
    required this.description,
  });
}
