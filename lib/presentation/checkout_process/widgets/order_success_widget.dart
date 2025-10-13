import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Order success widget displaying confirmation and tracking information
class OrderSuccessWidget extends StatefulWidget {
  final String orderId;
  final double total;
  final DateTime estimatedDelivery;
  final VoidCallback onContinueShopping;
  final VoidCallback onTrackOrder;

  const OrderSuccessWidget({
    super.key,
    required this.orderId,
    required this.total,
    required this.estimatedDelivery,
    required this.onContinueShopping,
    required this.onTrackOrder,
  });

  @override
  State<OrderSuccessWidget> createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends State<OrderSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _contentController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();

    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkmarkAnimation = CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    );

    // Start animations
    _checkmarkController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Format price to Indonesian Rupiah
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  /// Format date to Indonesian format
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Checkmark Animation
                    ScaleTransition(
                      scale: _checkmarkAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.successLight.withAlpha(77),
                              offset: const Offset(0, 8),
                              blurRadius: 24,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Success Content
                    FadeTransition(
                      opacity: _contentAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_contentAnimation),
                        child: Column(
                          children: [
                            // Success Title
                            Text(
                              'Pesanan Berhasil!',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimaryLight,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Pesanan Anda telah diterima dan sedang diproses.\nNotifikasi akan dikirim untuk setiap update status.',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppTheme.textSecondaryLight,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),

                            // Order Summary Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.dividerLight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.shadowLight,
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Order ID
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'No. Pesanan',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppTheme.textSecondaryLight,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryLight
                                              .withAlpha(26),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          widget.orderId,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.primaryLight,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Container(
                                    height: 1,
                                    color: AppTheme.dividerLight,
                                  ),

                                  const SizedBox(height: 16),

                                  // Total Amount
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Pembayaran',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryLight,
                                        ),
                                      ),
                                      Text(
                                        _formatPrice(widget.total),
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Container(
                                    height: 1,
                                    color: AppTheme.dividerLight,
                                  ),

                                  const SizedBox(height: 16),

                                  // Estimated Delivery
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_shipping_outlined,
                                        size: 20,
                                        color: AppTheme.textSecondaryLight,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Estimasi Pengiriman: ',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppTheme.textSecondaryLight,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(widget.estimatedDelivery),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Order Status Timeline Preview
                            _buildStatusTimeline(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              FadeTransition(
                opacity: _contentAnimation,
                child: Column(
                  children: [
                    // Track Order Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.onTrackOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: Icon(Icons.track_changes, size: 20),
                        label: Text(
                          'Lacak Pesanan',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Continue Shopping Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: widget.onContinueShopping,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.primaryLight),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.shopping_bag_outlined, size: 20),
                        label: Text(
                          'Lanjut Belanja',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build order status timeline preview
  Widget _buildStatusTimeline() {
    final statuses = [
      {
        'label': 'Pesanan Diterima',
        'completed': true,
        'icon': Icons.receipt_long,
      },
      {
        'label': 'Approved Admin',
        'completed': false,
        'icon': Icons.admin_panel_settings,
      },
      {'label': 'Di Proses', 'completed': false, 'icon': Icons.settings},
      {'label': 'Dikirim', 'completed': false, 'icon': Icons.local_shipping},
      {'label': 'Selesai', 'completed': false, 'icon': Icons.check_circle},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Pesanan',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 16),

          Column(
            children:
                statuses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final status = entry.value;
                  final isLast = index == statuses.length - 1;
                  final isCompleted = status['completed'] as bool;

                  return Row(
                    children: [
                      // Status Icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              isCompleted
                                  ? AppTheme.successLight
                                  : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              isCompleted
                                  ? null
                                  : Border.all(
                                    color: AppTheme.dividerLight,
                                    width: 2,
                                  ),
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check
                              : status['icon'] as IconData,
                          size: 16,
                          color:
                              isCompleted
                                  ? Colors.white
                                  : AppTheme.textSecondaryLight,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Status Label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status['label'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight:
                                    isCompleted
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isCompleted
                                        ? AppTheme.textPrimaryLight
                                        : AppTheme.textSecondaryLight,
                              ),
                            ),

                            if (!isLast) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: 2,
                                height: 20,
                                margin: const EdgeInsets.only(left: 15),
                                color:
                                    isCompleted
                                        ? AppTheme.successLight.withAlpha(77)
                                        : AppTheme.dividerLight,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
