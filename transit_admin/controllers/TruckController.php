<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/Truck.php';
require_once __DIR__ . '/../models/Activity.php';

class TruckController extends BaseController {
    private $model;
    private $activity;

    public function __construct() {
        $this->model = new Truck();
        $this->activity = new Activity();
    }

    public function index() {
        $status = $_GET['status'] ?? null;
        $trucks = $this->model->getAllWithOwner($status);
        $this->json(['success' => true, 'data' => $trucks]);
    }

    public function available() {
        $this->json(['success' => true, 'data' => $this->model->getAvailable()]);
    }

    public function show($id) {
        $truck = $this->model->find($id);
        if (!$truck) $this->json(['success' => false, 'error' => 'Truck not found'], 404);
        $this->json(['success' => true, 'data' => $truck]);
    }

    public function store() {
        $data = $this->getInput();
        $required = ['plate_number', 'owner_id', 'truck_type', 'capacity_kg'];
        foreach ($required as $f) {
            if (empty($data[$f])) $this->json(['success' => false, 'error' => "Missing: $f"], 400);
        }
        if ($this->model->create($data)) {
            $this->json(['success' => true, 'message' => 'Truck added']);
        }
        $this->json(['success' => false, 'error' => 'Failed to add truck'], 500);
    }

    public function update($id) {
        $data = $this->getInput();
        if ($this->model->update($id, $data)) {
            $this->json(['success' => true, 'message' => 'Truck updated']);
        }
        $this->json(['success' => false, 'error' => 'Failed to update truck'], 500);
    }

    public function verify($id) {
        if ($this->model->verify($id)) {
            $truck = $this->model->find($id);
            $this->activity->create('truck', 'Truck verified', "{$truck['plate_number']} verified and activated");
            $this->json(['success' => true, 'message' => 'Truck verified']);
        }
        $this->json(['success' => false, 'error' => 'Failed to verify truck'], 500);
    }

    public function delete($id) {
        if ($this->model->delete($id)) {
            $this->json(['success' => true, 'message' => 'Truck deleted']);
        }
        $this->json(['success' => false, 'error' => 'Failed to delete truck'], 500);
    }

    public function stats() {
        $this->json(['success' => true, 'data' => $this->model->getStats()]);
    }
}
