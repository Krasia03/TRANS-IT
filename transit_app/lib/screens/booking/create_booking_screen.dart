import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../models/truck.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  int _currentStep = 0;
  final _pickupController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _cargoDescController = TextEditingController();
  final _weightController = TextEditingController();
  
  String? _selectedCargoType;
  String? _selectedTruckType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _cargoTypes = [
    'General Goods',
    'Electronics',
    'Furniture',
    'Machinery',
    'Perishables',
    'Fragile Items',
    'Chemicals',
    'Construction Materials',
  ];

  @override
  void dispose() {
    _pickupController.dispose();
    _deliveryController.dispose();
    _cargoDescController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: _currentStep == 3 ? 'Confirm Booking' : 'Continue',
                      onPressed: details.onStepContinue!,
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Location'),
              subtitle: const Text('Pickup & Delivery'),
              content: _buildLocationStep(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Cargo'),
              subtitle: const Text('What are you shipping?'),
              content: _buildCargoStep(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Vehicle'),
              subtitle: const Text('Select truck type'),
              content: _buildVehicleStep(),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Schedule'),
              subtitle: const Text('When to pickup?'),
              content: _buildScheduleStep(),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return Column(
      children: [
        CustomTextField(
          controller: _pickupController,
          label: 'Pickup Location',
          hint: 'Enter pickup address',
          prefixIcon: Icons.my_location,
          suffixIcon: IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: _getCurrentLocation,
          ),
          onChanged: (value) {
            Provider.of<BookingProvider>(context, listen: false)
                .setPickupLocation(value);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _deliveryController,
          label: 'Delivery Location',
          hint: 'Enter delivery address',
          prefixIcon: Icons.location_on,
          onChanged: (value) {
            Provider.of<BookingProvider>(context, listen: false)
                .setDeliveryLocation(value);
          },
        ),
        const SizedBox(height: 16),
        // Map preview placeholder
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: AppTheme.textLight),
                SizedBox(height: 8),
                Text(
                  'Map will show route preview',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCargoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCargoType,
          decoration: const InputDecoration(
            labelText: 'Cargo Type',
            prefixIcon: Icon(Icons.category),
          ),
          items: _cargoTypes.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedCargoType = value);
            Provider.of<BookingProvider>(context, listen: false)
                .setCargoDetails(type: value);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _weightController,
          label: 'Estimated Weight (kg)',
          hint: 'Enter cargo weight',
          prefixIcon: Icons.scale,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final weight = double.tryParse(value);
            if (weight != null) {
              Provider.of<BookingProvider>(context, listen: false)
                  .setCargoDetails(weight: weight);
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _cargoDescController,
          label: 'Description (Optional)',
          hint: 'Add details about your cargo',
          prefixIcon: Icons.description,
          maxLines: 3,
          onChanged: (value) {
            Provider.of<BookingProvider>(context, listen: false)
                .setCargoDetails(description: value);
          },
        ),
      ],
    );
  }

  Widget _buildVehicleStep() {
    final truckTypes = TruckType.getAvailableTypes();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select the type of vehicle for your shipment',
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ...truckTypes.map((truck) => _truckTypeCard(truck)),
      ],
    );
  }

  Widget _truckTypeCard(TruckType truck) {
    final isSelected = _selectedTruckType == truck.name;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTruckType = truck.name);
        Provider.of<BookingProvider>(context, listen: false)
            .setTruckType(truck.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(truck.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    truck.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    truck.description,
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${truck.baseRate.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  'Base fare',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStep() {
    return Consumer<BookingProvider>(
      builder: (context, booking, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                    const SizedBox(width: 16),
                    Text(
                      _selectedDate != null
                          ? DateFormat('EEE, dd MMM yyyy').format(_selectedDate!)
                          : 'Select Pickup Date',
                      style: TextStyle(
                        color: _selectedDate != null
                            ? AppTheme.textPrimary
                            : AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Time picker
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.primaryColor),
                    const SizedBox(width: 16),
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select Pickup Time',
                      style: TextStyle(
                        color: _selectedTime != null
                            ? AppTheme.textPrimary
                            : AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Price summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Estimate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Fare'),
                      Text('₹${(booking.estimatedPrice ?? 0) * 0.6}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Distance Charge'),
                      Text('₹${(booking.estimatedPrice ?? 0) * 0.3}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service Fee'),
                      Text('₹${(booking.estimatedPrice ?? 0) * 0.1}'),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${(booking.estimatedPrice ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _getCurrentLocation() {
    // Implement location fetching
    _pickupController.text = 'Current Location';
    Provider.of<BookingProvider>(context, listen: false)
        .setPickupLocation('Current Location', lat: 28.6139, lng: 77.2090);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (date != null) {
      setState(() => _selectedDate = date);
      _updateSchedule();
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() => _selectedTime = time);
      _updateSchedule();
    }
  }

  void _updateSchedule() {
    if (_selectedDate != null && _selectedTime != null) {
      Provider.of<BookingProvider>(context, listen: false).setPickupDateTime(
        _selectedDate!,
        _selectedTime!.format(context),
      );
    }
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_pickupController.text.isEmpty || _deliveryController.text.isEmpty) {
        _showError('Please enter both pickup and delivery locations');
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedCargoType == null) {
        _showError('Please select cargo type');
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedTruckType == null) {
        _showError('Please select a vehicle type');
        return;
      }
    } else if (_currentStep == 3) {
      if (_selectedDate == null || _selectedTime == null) {
        _showError('Please select pickup date and time');
        return;
      }
      _confirmBooking();
      return;
    }

    setState(() => _currentStep++);
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  Future<void> _confirmBooking() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    if (authProvider.user == null) {
      _showError('Please login to continue');
      return;
    }

    final success = await bookingProvider.createBooking(authProvider.user!.id!);

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Booking #${bookingProvider.currentBooking?.bookingNumber}',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'View Booking',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      _showError(bookingProvider.errorMessage ?? 'Failed to create booking');
    }
  }
}
