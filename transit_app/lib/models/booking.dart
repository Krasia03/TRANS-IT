class Booking {
  final int? id;
  final int? userId;
  final String bookingNumber;
  final String pickupLocation;
  final String deliveryLocation;
  final double? pickupLat;
  final double? pickupLng;
  final double? deliveryLat;
  final double? deliveryLng;
  final String cargoType;
  final double? cargoWeight;
  final String? cargoDescription;
  final String truckType;
  final DateTime? pickupDate;
  final String? pickupTime;
  final double? estimatedPrice;
  final double? finalPrice;
  final String status;
  final String? driverName;
  final String? driverPhone;
  final String? truckNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    this.id,
    this.userId,
    required this.bookingNumber,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.pickupLat,
    this.pickupLng,
    this.deliveryLat,
    this.deliveryLng,
    required this.cargoType,
    this.cargoWeight,
    this.cargoDescription,
    required this.truckType,
    this.pickupDate,
    this.pickupTime,
    this.estimatedPrice,
    this.finalPrice,
    this.status = 'pending',
    this.driverName,
    this.driverPhone,
    this.truckNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      bookingNumber: json['booking_number'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      deliveryLocation: json['delivery_location'] ?? '',
      pickupLat: json['pickup_lat']?.toDouble(),
      pickupLng: json['pickup_lng']?.toDouble(),
      deliveryLat: json['delivery_lat']?.toDouble(),
      deliveryLng: json['delivery_lng']?.toDouble(),
      cargoType: json['cargo_type'] ?? '',
      cargoWeight: json['cargo_weight']?.toDouble(),
      cargoDescription: json['cargo_description'],
      truckType: json['truck_type'] ?? '',
      pickupDate: json['pickup_date'] != null 
          ? DateTime.parse(json['pickup_date']) 
          : null,
      pickupTime: json['pickup_time'],
      estimatedPrice: json['estimated_price']?.toDouble(),
      finalPrice: json['final_price']?.toDouble(),
      status: json['status'] ?? 'pending',
      driverName: json['driver_name'],
      driverPhone: json['driver_phone'],
      truckNumber: json['truck_number'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'booking_number': bookingNumber,
      'pickup_location': pickupLocation,
      'delivery_location': deliveryLocation,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'delivery_lat': deliveryLat,
      'delivery_lng': deliveryLng,
      'cargo_type': cargoType,
      'cargo_weight': cargoWeight,
      'cargo_description': cargoDescription,
      'truck_type': truckType,
      'pickup_date': pickupDate?.toIso8601String(),
      'pickup_time': pickupTime,
      'estimated_price': estimatedPrice,
      'final_price': finalPrice,
      'status': status,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'truck_number': truckNumber,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
