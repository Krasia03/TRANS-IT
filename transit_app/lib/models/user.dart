class User {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String role;
  final String status;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.role = 'customer',
    this.status = 'active',
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profile_image'],
      role: json['role'] ?? 'customer',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'role': role,
      'status': status,
    };
  }
}
