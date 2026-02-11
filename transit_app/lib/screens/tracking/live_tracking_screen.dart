import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/booking.dart';
import '../../services/tracking_service.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Booking booking;

  const LiveTrackingScreen({super.key, required this.booking});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final TrackingService _trackingService = TrackingService();
  StreamSubscription? _trackingSubscription;
  Map<String, dynamic>? _trackingData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrackingData();
    _startTracking();
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    _trackingService.stopTracking();
    super.dispose();
  }

  Future<void> _loadTrackingData() async {
    final data = await _trackingService.getTrackingInfo(widget.booking.id!);
    if (mounted) {
      setState(() {
        _trackingData = data['data'];
        _isLoading = false;
      });
    }
  }

  void _startTracking() {
    _trackingSubscription = _trackingService
        .startTracking(widget.booking.id!)
        .listen((data) {
      if (mounted) {
        setState(() {
          // Update real-time location data
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track ${widget.booking.bookingNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrackingData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Map placeholder
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppTheme.backgroundColor,
                    child: Stack(
                      children: [
                        // Map would go here
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 80,
                                color: AppTheme.textLight,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Live Map Tracking',
                                style: AppTheme.bodyMedium,
                              ),
                              const Text(
                                'Google Maps integration required',
                                style: AppTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        // ETA card
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.access_time,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Estimated Arrival',
                                        style: AppTheme.bodySmall,
                                      ),
                                      Text(
                                        _trackingData?['eta'] ?? '25 mins',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Distance',
                                        style: AppTheme.bodySmall,
                                      ),
                                      Text(
                                        _trackingData?['distance_remaining'] ?? '12 km',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
                
                // Bottom sheet
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.borderColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Driver info
                          if (_trackingData?['driver'] != null)
                            _buildDriverCard(),
                          const SizedBox(height: 20),
                          
                          // Tracking timeline
                          const Text(
                            'Shipment Progress',
                            style: AppTheme.headingSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildTrackingTimeline(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDriverCard() {
    final driver = _trackingData!['driver'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                    driver['name'] ?? 'Driver',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '${driver['rating'] ?? 4.5}',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: AppTheme.successColor, size: 20),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.message, color: AppTheme.primaryColor, size: 20),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final checkpoints = _trackingData?['checkpoints'] as List? ?? [];
    
    return Column(
      children: List.generate(checkpoints.length, (index) {
        final checkpoint = checkpoints[index];
        final isCompleted = checkpoint['completed'] ?? false;
        final isLast = index == checkpoints.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successColor
                        : AppTheme.borderColor,
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppTheme.successColor
                        : AppTheme.borderColor,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      checkpoint['name'] ?? '',
                      style: TextStyle(
                        fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                        color: isCompleted
                            ? AppTheme.textPrimary
                            : AppTheme.textLight,
                      ),
                    ),
                    if (checkpoint['time'] != null)
                      Text(
                        checkpoint['time'],
                        style: AppTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
