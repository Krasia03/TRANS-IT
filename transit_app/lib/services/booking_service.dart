import '../models/booking.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class BookingService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> createBooking(Booking booking) async {
    final response = await _api.post(
      ApiConfig.createBooking,
      data: booking.toJson(),
    );

    if (response['success'] && response['data'] != null) {
      return {
        'success': true,
        'booking': Booking.fromJson(response['data']),
        'message': 'Booking created successfully',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to create booking',
    };
  }

  Future<Map<String, dynamic>> getBookings({int? userId, String? status}) async {
    String url = ApiConfig.getBookings;
    if (userId != null) url += '&user_id=$userId';
    if (status != null) url += '&status=$status';

    final response = await _api.get(url);

    if (response['success'] && response['data'] != null) {
      final List<dynamic> bookingsJson = response['data'] is List 
          ? response['data'] 
          : [response['data']];
      final bookings = bookingsJson.map((b) => Booking.fromJson(b)).toList();
      return {
        'success': true,
        'bookings': bookings,
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to fetch bookings',
      'bookings': <Booking>[],
    };
  }

  Future<Map<String, dynamic>> getBookingById(int bookingId) async {
    final response = await _api.get('${ApiConfig.getBookingById}&id=$bookingId');

    if (response['success'] && response['data'] != null) {
      return {
        'success': true,
        'booking': Booking.fromJson(response['data']),
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to fetch booking',
    };
  }

  Future<Map<String, dynamic>> updateBooking(Booking booking) async {
    final response = await _api.put(
      '${ApiConfig.updateBooking}&id=${booking.id}',
      data: booking.toJson(),
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Booking updated successfully',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to update booking',
    };
  }

  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final response = await _api.delete('${ApiConfig.cancelBooking}&id=$bookingId');

    if (response['success']) {
      return {
        'success': true,
        'message': 'Booking cancelled successfully',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to cancel booking',
    };
  }

  // Calculate estimated price based on distance and truck type
  double calculateEstimatedPrice({
    required double distanceKm,
    required String truckType,
    double? weight,
  }) {
    // Base rates per truck type
    Map<String, Map<String, double>> rates = {
      'Mini Truck': {'base': 500, 'perKm': 15},
      'Light Truck': {'base': 800, 'perKm': 20},
      'Medium Truck': {'base': 1200, 'perKm': 25},
      'Heavy Truck': {'base': 2000, 'perKm': 35},
      'Container': {'base': 5000, 'perKm': 50},
    };

    final truckRates = rates[truckType] ?? rates['Mini Truck']!;
    double price = truckRates['base']! + (distanceKm * truckRates['perKm']!);

    // Add weight surcharge if applicable
    if (weight != null && weight > 5) {
      price += (weight - 5) * 50; // 50 per extra ton above 5 tons
    }

    return price;
  }

  // Generate unique booking number
  String generateBookingNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(7);
    return 'TRN${now.year}${now.month.toString().padLeft(2, '0')}$timestamp';
  }
}
