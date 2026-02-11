class ApiConfig {
  // Base URL for the PHP backend API
  static const String baseUrl = 'https://your-domain.com/transit_admin/api.php';
  
  // API Endpoints
  static const String login = '$baseUrl?resource=user&action=login';
  static const String register = '$baseUrl?resource=user&action=create';
  static const String getProfile = '$baseUrl?resource=user&action=getById';
  static const String updateProfile = '$baseUrl?resource=user&action=update';
  
  // Booking endpoints
  static const String createBooking = '$baseUrl?resource=booking&action=create';
  static const String getBookings = '$baseUrl?resource=booking&action=getAll';
  static const String getBookingById = '$baseUrl?resource=booking&action=getById';
  static const String updateBooking = '$baseUrl?resource=booking&action=update';
  static const String cancelBooking = '$baseUrl?resource=booking&action=delete';
  
  // Truck endpoints
  static const String getTrucks = '$baseUrl?resource=truck&action=getAll';
  static const String getTruckById = '$baseUrl?resource=truck&action=getById';
  
  // Location endpoints
  static const String getLocations = '$baseUrl?resource=location&action=getAll';
  
  // Transaction endpoints
  static const String getTransactions = '$baseUrl?resource=transaction&action=getAll';
  static const String createTransaction = '$baseUrl?resource=transaction&action=create';
  
  // Payout endpoints
  static const String getPayouts = '$baseUrl?resource=payout&action=getAll';
  static const String requestPayout = '$baseUrl?resource=payout&action=create';
  
  // Rate card endpoints
  static const String getRateCards = '$baseUrl?resource=ratecard&action=getAll';
  
  // Timeout settings
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
