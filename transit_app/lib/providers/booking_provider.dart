import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  
  List<Booking> _bookings = [];
  Booking? _currentBooking;
  bool _isLoading = false;
  String? _errorMessage;

  // Form state
  String? _pickupLocation;
  String? _deliveryLocation;
  double? _pickupLat;
  double? _pickupLng;
  double? _deliveryLat;
  double? _deliveryLng;
  String? _cargoType;
  double? _cargoWeight;
  String? _cargoDescription;
  String? _selectedTruckType;
  DateTime? _pickupDate;
  String? _pickupTime;
  double? _estimatedPrice;

  // Getters
  List<Booking> get bookings => _bookings;
  Booking? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  String? get pickupLocation => _pickupLocation;
  String? get deliveryLocation => _deliveryLocation;
  String? get selectedTruckType => _selectedTruckType;
  DateTime? get pickupDate => _pickupDate;
  double? get estimatedPrice => _estimatedPrice;

  // Setters for form
  void setPickupLocation(String location, {double? lat, double? lng}) {
    _pickupLocation = location;
    _pickupLat = lat;
    _pickupLng = lng;
    _calculatePrice();
    notifyListeners();
  }

  void setDeliveryLocation(String location, {double? lat, double? lng}) {
    _deliveryLocation = location;
    _deliveryLat = lat;
    _deliveryLng = lng;
    _calculatePrice();
    notifyListeners();
  }

  void setCargoDetails({String? type, double? weight, String? description}) {
    _cargoType = type ?? _cargoType;
    _cargoWeight = weight ?? _cargoWeight;
    _cargoDescription = description ?? _cargoDescription;
    _calculatePrice();
    notifyListeners();
  }

  void setTruckType(String truckType) {
    _selectedTruckType = truckType;
    _calculatePrice();
    notifyListeners();
  }

  void setPickupDateTime(DateTime date, String time) {
    _pickupDate = date;
    _pickupTime = time;
    notifyListeners();
  }

  void _calculatePrice() {
    if (_pickupLat != null && _pickupLng != null && 
        _deliveryLat != null && _deliveryLng != null &&
        _selectedTruckType != null) {
      // Calculate distance (simplified)
      double distance = _calculateDistance();
      _estimatedPrice = _bookingService.calculateEstimatedPrice(
        distanceKm: distance,
        truckType: _selectedTruckType!,
        weight: _cargoWeight,
      );
    }
  }

  double _calculateDistance() {
    // Haversine formula simplified
    if (_pickupLat == null || _deliveryLat == null) return 0;
    
    const double earthRadius = 6371; // km
    double dLat = _toRadians(_deliveryLat! - _pickupLat!);
    double dLon = _toRadians(_deliveryLng! - _pickupLng!);
    
    double a = (dLat / 2).abs() * (dLat / 2).abs() +
        (_toRadians(_pickupLat!)).abs() * (_toRadians(_deliveryLat!)).abs() *
        (dLon / 2).abs() * (dLon / 2).abs();
    double c = 2 * a.abs();
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * 3.14159 / 180;

  // API calls
  Future<bool> createBooking(int userId) async {
    if (_pickupLocation == null || _deliveryLocation == null ||
        _cargoType == null || _selectedTruckType == null) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final booking = Booking(
      bookingNumber: _bookingService.generateBookingNumber(),
      userId: userId,
      pickupLocation: _pickupLocation!,
      deliveryLocation: _deliveryLocation!,
      pickupLat: _pickupLat,
      pickupLng: _pickupLng,
      deliveryLat: _deliveryLat,
      deliveryLng: _deliveryLng,
      cargoType: _cargoType!,
      cargoWeight: _cargoWeight,
      cargoDescription: _cargoDescription,
      truckType: _selectedTruckType!,
      pickupDate: _pickupDate,
      pickupTime: _pickupTime,
      estimatedPrice: _estimatedPrice,
      status: 'pending',
    );

    final result = await _bookingService.createBooking(booking);
    
    _isLoading = false;
    
    if (result['success']) {
      _currentBooking = result['booking'];
      _bookings.insert(0, _currentBooking!);
      _resetForm();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchBookings(int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _bookingService.getBookings(userId: userId);
    
    _isLoading = false;
    _bookings = result['bookings'] ?? [];
    notifyListeners();
  }

  Future<void> fetchBookingById(int bookingId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _bookingService.getBookingById(bookingId);
    
    _isLoading = false;
    
    if (result['success']) {
      _currentBooking = result['booking'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  Future<bool> cancelBooking(int bookingId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _bookingService.cancelBooking(bookingId);
    
    _isLoading = false;
    
    if (result['success']) {
      _bookings.removeWhere((b) => b.id == bookingId);
      if (_currentBooking?.id == bookingId) {
        _currentBooking = null;
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  void setCurrentBooking(Booking booking) {
    _currentBooking = booking;
    notifyListeners();
  }

  void _resetForm() {
    _pickupLocation = null;
    _deliveryLocation = null;
    _pickupLat = null;
    _pickupLng = null;
    _deliveryLat = null;
    _deliveryLng = null;
    _cargoType = null;
    _cargoWeight = null;
    _cargoDescription = null;
    _selectedTruckType = null;
    _pickupDate = null;
    _pickupTime = null;
    _estimatedPrice = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
