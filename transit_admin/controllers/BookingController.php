<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/Booking.php';
require_once __DIR__ . '/../models/Activity.php';

class BookingController extends BaseController {
    private $model;
    private $activity;

    public function __construct() {
        $this->model = new Booking();
        $this->activity = new Activity();
    }

    public function index() {
        $status = $_GET['status'] ?? null;
        $bookings = $this->model->getAllWithDetails($status);
        $this->json(['success' => true, 'data' => $bookings]);
    }

    public function show($id) {
        $booking = $this->model->find($id);
        if (!$booking) $this->json(['success' => false, 'error' => 'Booking not found'], 404);
        $this->json(['success' => true, 'data' => $booking]);
    }

    public function store() {
        $data = $this->getInput();
        $required = ['customer_id', 'origin', 'destination', 'distance_km', 'cargo_type', 'weight_kg', 'amount'];
        foreach ($required as $f) {
            if (empty($data[$f])) $this->json(['success' => false, 'error' => "Missing: $f"], 400);
        }
        if ($this->model->create($data)) {
            $this->activity->create('booking', 'New booking created', "{$data['origin']} → {$data['destination']}");
            $this->json(['success' => true, 'message' => 'Booking created']);
        }
        $this->json(['success' => false, 'error' => 'Failed to create booking'], 500);
    }

    public function update($id) {
        $data = $this->getInput();
        if ($this->model->update($id, $data)) {
            $this->json(['success' => true, 'message' => 'Booking updated']);
        }
        $this->json(['success' => false, 'error' => 'Failed to update booking'], 500);
    }

    public function assign($id) {
        $data = $this->getInput();
        if (empty($data['truck_id'])) $this->json(['success' => false, 'error' => 'Truck ID required'], 400);
        if ($this->model->assign($id, $data['truck_id'], $data['pickup_date'] ?? null, $data['pickup_time'] ?? null, $data['notes'] ?? null)) {
            $this->activity->create('booking', 'Truck assigned', "Booking #$id assigned to truck");
            $this->json(['success' => true, 'message' => 'Truck assigned']);
        }
        $this->json(['success' => false, 'error' => 'Failed to assign truck'], 500);
    }

    public function delete($id) {
        if ($this->model->delete($id)) {
            $this->json(['success' => true, 'message' => 'Booking deleted']);
        }
        $this->json(['success' => false, 'error' => 'Failed to delete booking'], 500);
    }

    public function stats() {
        $this->json(['success' => true, 'data' => $this->model->getStats()]);
    }
}
