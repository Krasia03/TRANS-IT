<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/Activity.php';
require_once __DIR__ . '/../models/Booking.php';
require_once __DIR__ . '/../models/Truck.php';
require_once __DIR__ . '/../models/Transaction.php';
require_once __DIR__ . '/../models/Payout.php';
require_once __DIR__ . '/../models/User.php';

class DashboardController extends BaseController {
    public function index() {
        $booking = new Booking();
        $truck = new Truck();
        $transaction = new Transaction();
        $payout = new Payout();
        $user = new User();
        $activity = new Activity();

        $txnStats = $transaction->getStats();
        $payoutStats = $payout->getStats();

        $this->json(['success' => true, 'data' => [
            'bookings' => $booking->getStats(),
            'trucks' => $truck->getStats(),
            'revenue' => $txnStats['total'],
            'escrow' => $txnStats['escrow'],
            'payouts' => $payoutStats,
            'users' => [
                'total' => $user->count(),
                'drivers' => $user->count("role = 'driver'")
            ],
            'activities' => $activity->getRecent(5)
        ]]);
    }
}
