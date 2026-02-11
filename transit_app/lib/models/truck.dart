class Truck {
  final int? id;
  final String truckNumber;
  final String truckType;
  final double capacity;
  final String? driverName;
  final String? driverPhone;
  final String status;
  final double? currentLat;
  final double? currentLng;

  Truck({
    this.id,
    required this.truckNumber,
    required this.truckType,
    required this.capacity,
    this.driverName,
    this.driverPhone,
    this.status = 'available',
    this.currentLat,
    this.currentLng,
  });

  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      truckNumber: json['truck_number'] ?? '',
      truckType: json['truck_type'] ?? '',
      capacity: (json['capacity'] ?? 0).toDouble(),
      driverName: json['driver_name'],
      driverPhone: json['driver_phone'],
      status: json['status'] ?? 'available',
      currentLat: json['current_lat']?.toDouble(),
      currentLng: json['current_lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'truck_number': truckNumber,
      'truck_type': truckType,
      'capacity': capacity,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'status': status,
      'current_lat': currentLat,
      'current_lng': currentLng,
    };
  }
}

class TruckType {
  final String name;
  final String description;
  final double baseRate;
  final double ratePerKm;
  final String icon;

  TruckType({
    required this.name,
    required this.description,
    required this.baseRate,
    required this.ratePerKm,
    required this.icon,
  });

  static List<TruckType> getAvailableTypes() {
    return [
      TruckType(
        name: 'Mini Truck',
        description: '1-2 Tons capacity',
        baseRate: 500,
        ratePerKm: 15,
        icon: '🚚',
      ),
      TruckType(
        name: 'Light Truck',
        description: '3-5 Tons capacity',
        baseRate: 800,
        ratePerKm: 20,
        icon: '🚛',
      ),
      TruckType(
        name: 'Medium Truck',
        description: '6-10 Tons capacity',
        baseRate: 1200,
        ratePerKm: 25,
        icon: '🚐',
      ),
      TruckType(
        name: 'Heavy Truck',
        description: '11-20 Tons capacity',
        baseRate: 2000,
        ratePerKm: 35,
        icon: '🚜',
      ),
      TruckType(
        name: 'Container',
        description: '20-40 ft container',
        baseRate: 5000,
        ratePerKm: 50,
        icon: '📦',
      ),
    ];
  }
}
