import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../tracking/live_tracking_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking.bookingNumber),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (booking.status == 'pending')
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
              onPressed: () => _showCancelDialog(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildLocationCard(),
            const SizedBox(height: 16),
            _buildCargoCard(),
            const SizedBox(height: 16),
            _buildScheduleCard(),
            const SizedBox(height: 16),
            if (booking.driverName != null) ...[
              _buildDriverCard(),
              const SizedBox(height: 16),
            ],
            _buildPriceCard(),
            const SizedBox(height: 24),
            if (booking.status == 'in_transit')
              _buildTrackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.statusDisplay,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusDescription(),
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (booking.status) {
      case 'pending':
        return AppTheme.warningColor;
      case 'confirmed':
        return AppTheme.infoColor;
      case 'in_transit':
        return AppTheme.primaryColor;
      case 'delivered':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (booking.status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'in_transit':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _getStatusDescription() {
    switch (booking.status) {
      case 'pending':
        return 'Waiting for driver confirmation';
      case 'confirmed':
        return 'Driver will pick up your cargo soon';
      case 'in_transit':
        return 'Your cargo is on the way';
      case 'delivered':
        return 'Successfully delivered';
      case 'cancelled':
        return 'This booking was cancelled';
      default:
        return '';
    }
  }

  Widget _buildLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 50,
                      color: AppTheme.borderColor,
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pickup Location',
                        style: AppTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.pickupLocation,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Delivery Location',
                        style: AppTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.deliveryLocation,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCargoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cargo Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _detailRow('Type', booking.cargoType),
            if (booking.cargoWeight != null)
              _detailRow('Weight', '${booking.cargoWeight} kg'),
            _detailRow('Vehicle', booking.truckType),
            if (booking.cargoDescription != null && booking.cargoDescription!.isNotEmpty)
              _detailRow('Description', booking.cargoDescription!),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _detailRow(
              'Pickup Date',
              booking.pickupDate != null
                  ? DateFormat('EEE, dd MMM yyyy').format(booking.pickupDate!)
                  : 'Not scheduled',
            ),
            if (booking.pickupTime != null)
              _detailRow('Pickup Time', booking.pickupTime!),
            _detailRow(
              'Created',
              booking.createdAt != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(booking.createdAt!)
                  : '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.driverName ?? 'Driver',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (booking.truckNumber != null)
                        Text(
                          booking.truckNumber!,
                          style: AppTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (booking.driverPhone != null)
                  IconButton(
                    icon: const Icon(Icons.phone, color: AppTheme.primaryColor),
                    onPressed: () {
                      // Launch phone dialer
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _detailRow(
              'Estimated Price',
              '₹${(booking.estimatedPrice ?? 0).toStringAsFixed(2)}',
            ),
            if (booking.finalPrice != null)
              _detailRow(
                'Final Price',
                '₹${booking.finalPrice!.toStringAsFixed(2)}',
                valueStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveTrackingScreen(booking: booking),
            ),
          );
        },
        icon: const Icon(Icons.location_on),
        label: const Text('Track Shipment'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await Provider.of<BookingProvider>(
                context,
                listen: false,
              ).cancelBooking(booking.id!);
              
              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
