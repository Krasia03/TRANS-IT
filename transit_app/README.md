# TRANSIT Mobile App - Flutter

A complete Flutter mobile application for the TRANSIT logistics platform, ready for deployment.

## Features

- **User Authentication**: Login, Register, Password Recovery
- **Booking Management**: Create, View, Track, and Cancel bookings
- **Real-time Tracking**: Live location tracking of shipments
- **Wallet System**: Add money, make payments, view transactions
- **Profile Management**: Update profile, saved addresses, payment methods

## Project Structure

```
transit_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/
│   │   ├── api_config.dart       # API endpoints configuration
│   │   └── app_theme.dart        # App theme and styling
│   ├── models/
│   │   ├── user.dart             # User model
│   │   ├── booking.dart          # Booking model
│   │   ├── truck.dart            # Truck model
│   │   └── transaction.dart      # Transaction model
│   ├── services/
│   │   ├── api_service.dart      # Base API service
│   │   ├── auth_service.dart     # Authentication service
│   │   ├── booking_service.dart  # Booking operations
│   │   ├── tracking_service.dart # Real-time tracking
│   │   └── wallet_service.dart   # Wallet operations
│   ├── providers/
│   │   ├── auth_provider.dart    # Authentication state
│   │   ├── booking_provider.dart # Booking state
│   │   └── wallet_provider.dart  # Wallet state
│   ├── screens/
│   │   ├── auth/                 # Authentication screens
│   │   ├── home/                 # Home dashboard
│   │   ├── booking/              # Booking screens
│   │   ├── tracking/             # Tracking screens
│   │   ├── wallet/               # Wallet screens
│   │   └── profile/              # Profile screens
│   └── widgets/                  # Reusable widgets
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── android/                      # Android configuration
├── ios/                          # iOS configuration
└── pubspec.yaml                  # Dependencies
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode
- VS Code (recommended)

### Installation

1. **Clone the repository**
   ```bash
   cd transit_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   
   Edit `lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'https://your-domain.com/transit_admin/api.php';
   ```

4. **Add Google Maps API Key** (for tracking features)
   
   **Android**: Edit `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY"/>
   ```
   
   **iOS**: Edit `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## API Integration

The app connects to the PHP backend API created in `transit_admin/`. Ensure the backend is deployed and accessible.

### Required API Endpoints

| Endpoint | Description |
|----------|-------------|
| `POST /login` | User authentication |
| `POST /register` | User registration |
| `GET /bookings` | List user bookings |
| `POST /bookings` | Create new booking |
| `GET /bookings/:id` | Get booking details |
| `PUT /bookings/:id` | Update booking |
| `DELETE /bookings/:id` | Cancel booking |
| `GET /transactions` | List transactions |
| `POST /transactions` | Create transaction |
| `GET /trucks` | List available trucks |

## Dependencies

- **provider**: State management
- **dio**: HTTP client
- **flutter_secure_storage**: Secure credential storage
- **google_maps_flutter**: Map integration
- **geolocator**: Location services
- **intl**: Date/time formatting
- **cached_network_image**: Image caching
- **fl_chart**: Charts and graphs

## Customization

### Theme
Edit `lib/config/app_theme.dart` to customize:
- Primary colors
- Typography
- Component styles

### Fonts
Add custom fonts to `assets/fonts/` and update `pubspec.yaml`.

### Icons
Add app icons using `flutter_launcher_icons` package.

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Troubleshooting

### Common Issues

1. **API Connection Failed**
   - Verify `baseUrl` in `api_config.dart`
   - Check CORS settings on backend
   - Ensure backend is running

2. **Location Not Working**
   - Check location permissions in app settings
   - Verify Google Maps API key

3. **Build Errors**
   - Run `flutter clean && flutter pub get`
   - Check Flutter version compatibility

## Support

For issues or questions, contact the development team.

## License

Proprietary - All rights reserved.
