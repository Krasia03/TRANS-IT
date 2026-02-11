import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/booking.dart';
import 'api_service.dart';

class TrackingService {
  final ApiService _api = ApiService();
  StreamController<Map<String, dynamic>>? _trackingController;

  // Get current device location
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) / 1000; // in km
  }

  // Start real-time tracking for a booking
  Stream<Map<String, dynamic>> startTracking(int bookingId) {
    _trackingController = StreamController<Map<String, dynamic>>();

    // Simulate real-time tracking updates
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_trackingController?.isClosed ?? true) {
        timer.cancel();
        return;
      }

      // In real implementation, this would fetch from backend
      // For now, we'll simulate truck movement
      _trackingController?.add({
        'booking_id': bookingId,
        'truck_lat': 28.6139 + (timer.tick * 0.001),
        'truck_lng': 77.2090 + (timer.tick * 0.001),
        'status': 'in_transit',
        'eta': '${30 - timer.tick} mins',
        'last_update': DateTime.now().toIso8601String(),
      });
    });

    return _trackingController!.stream;
  }

  // Stop tracking
  void stopTracking() {
    _trackingController?.close();
    _trackingController = null;
  }

  // Get tracking info for a booking
  Future<Map<String, dynamic>> getTrackingInfo(int bookingId) async {
    // This would call the backend API
    // Simulated response for now
    return {
      'success': true,
      'data': {
        'booking_id': bookingId,
        'truck_location': {
          'lat': 28.6139,
          'lng': 77.2090,
        },
        'driver': {
          'name': 'John Driver',
          'phone': '+91 9876543210',
          'rating': 4.5,
        },
        'eta': '25 mins',
        'distance_remaining': '12 km',
        'status': 'in_transit',
        'checkpoints': [
          {
            'name': 'Order Confirmed',
            'time': '10:00 AM',
            'completed': true,
          },
          {
            'name': 'Driver Assigned',
            'time': '10:05 AM',
            'completed': true,
          },
          {
            'name': 'Pickup Completed',
            'time': '10:30 AM',
            'completed': true,
          },
          {
            'name': 'In Transit',
            'time': '10:35 AM',
            'completed': true,
          },
          {
            'name': 'Delivered',
            'time': null,
            'completed': false,
          },
        ],
      },
    };
  }

  // Get estimated time of arrival
  String getETA(double distanceKm, {double avgSpeedKmh = 40}) {
    final hours = distanceKm / avgSpeedKmh;
    if (hours < 1) {
      return '${(hours * 60).round()} mins';
    } else if (hours < 24) {
      final h = hours.floor();
      final m = ((hours - h) * 60).round();
      return '$h hr${h > 1 ? 's' : ''} $m mins';
    } else {
      return '${(hours / 24).ceil()} day(s)';
    }
  }
}
