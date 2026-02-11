import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import 'booking_details_screen.dart';
import 'create_booking_screen.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _refreshBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      await Provider.of<BookingProvider>(context, listen: false)
          .fetchBookings(authProvider.user!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBookings,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _selectedFilter = 'all';
                  break;
                case 1:
                  _selectedFilter = 'active';
                  break;
                case 2:
                  _selectedFilter = 'delivered';
                  break;
                case 3:
                  _selectedFilter = 'cancelled';
                  break;
              }
            });
          },
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Booking> filteredBookings = _getFilteredBookings(provider.bookings);

          if (filteredBookings.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshBookings,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(filteredBookings[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBookingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
      ),
    );
  }

  List<Booking> _getFilteredBookings(List<Booking> bookings) {
    switch (_selectedFilter) {
      case 'active':
        return bookings.where((b) => 
          b.status == 'pending' || b.status == 'confirmed' || b.status == 'in_transit'
        ).toList();
      case 'delivered':
        return bookings.where((b) => b.status == 'delivered').toList();
      case 'cancelled':
        return bookings.where((b) => b.status == 'cancelled').toList();
      default:
        return bookings;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          const Text(
            'No bookings found',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first booking to get started',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateBookingScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Booking'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsScreen(booking: booking),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusBadge(booking.status),
                ],
              ),
              const SizedBox(height: 16),
              
              // Locations
              Row(
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
                        height: 30,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.pickupLocation,
                          style: AppTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          booking.deliveryLocation,
                          style: AppTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_shipping, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(booking.truckType, style: AppTheme.bodySmall),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        booking.pickupDate != null
                            ? DateFormat('dd MMM yyyy').format(booking.pickupDate!)
                            : 'Not scheduled',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    '₹${(booking.estimatedPrice ?? 0).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'pending':
        color = AppTheme.warningColor;
        label = 'Pending';
        break;
      case 'confirmed':
        color = AppTheme.infoColor;
        label = 'Confirmed';
        break;
      case 'in_transit':
        color = AppTheme.primaryColor;
        label = 'In Transit';
        break;
      case 'delivered':
        color = AppTheme.successColor;
        label = 'Delivered';
        break;
      case 'cancelled':
        color = AppTheme.errorColor;
        label = 'Cancelled';
        break;
      default:
        color = AppTheme.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
