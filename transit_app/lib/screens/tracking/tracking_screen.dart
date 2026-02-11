import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/booking_provider.dart';
import 'live_tracking_screen.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _trackingController = TextEditingController();

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Shipment'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Tracking Number',
                      style: AppTheme.headingSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Track your shipment using the booking number',
                      style: AppTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _trackingController,
                      decoration: InputDecoration(
                        hintText: 'e.g., TRN202402001',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () {
                            // Scan QR code
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _searchBooking,
                        child: const Text('Track'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Active shipments
            const Text(
              'Active Shipments',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: 16),
            _buildActiveShipments(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveShipments() {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final activeBookings = provider.bookings
            .where((b) => b.status == 'in_transit' || b.status == 'confirmed')
            .toList();

        if (activeBookings.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 64,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No active shipments',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your in-transit bookings will appear here',
                      style: AppTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Column(
          children: activeBookings.map((booking) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveTrackingScreen(booking: booking),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.bookingNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${booking.pickupLocation.split(',').first} → ${booking.deliveryLocation.split(',').first}',
                              style: AppTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppTheme.textLight,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _searchBooking() {
    final trackingNumber = _trackingController.text.trim();
    if (trackingNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a tracking number'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final provider = Provider.of<BookingProvider>(context, listen: false);
    final booking = provider.bookings.firstWhere(
      (b) => b.bookingNumber.toLowerCase() == trackingNumber.toLowerCase(),
      orElse: () => throw Exception('Not found'),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTrackingScreen(booking: booking),
      ),
    );
  }
}
