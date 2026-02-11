<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/RateCard.php';

class RateCardController extends BaseController {
    private $model;

    public function __construct() {
        $this->model = new RateCard();
    }

    public function index() {
        $this->json(['success' => true, 'data' => $this->model->getAll()]);
    }

    public function show($id) {
        $rate = $this->model->find($id);
        if (!$rate) $this->json(['success' => false, 'error' => 'Rate card not found'], 404);
        $this->json(['success' => true, 'data' => $rate]);
    }

    public function store() {
        $data = $this->getInput();
        $required = ['truck_type', 'cargo_type', 'base_rate', 'per_km_rate', 'per_kg_rate', 'commission_percent'];
        foreach ($required as $f) {
            if (!isset($data[$f])) $this->json(['success' => false, 'error' => "Missing: $f"], 400);
        }
        if ($this->model->create($data)) {
            $this->json(['success' => true, 'message' => 'Rate card created']);
        }
        $this->json(['success' => false, 'error' => 'Failed to create rate card'], 500);
    }

    public function update($id) {
        $data = $this->getInput();
        if ($this->model->update($id, $data)) {
            $this->json(['success' => true, 'message' => 'Rate card updated']);
        }
        $this->json(['success' => false, 'error' => 'Failed to update rate card'], 500);
    }

    public function delete($id) {
        if ($this->model->delete($id)) {
            $this->json(['success' => true, 'message' => 'Rate card deleted']);
        }
        $this->json(['success' => false, 'error' => 'Failed to delete rate card'], 500);
    }

    public function calculate() {
        $data = $this->getInput();
        $result = $this->model->calculateRate($data['truck_type'], $data['cargo_type'], $data['distance_km'], $data['weight_kg']);
        if ($result) {
            $this->json(['success' => true, 'data' => $result]);
        }
        $this->json(['success' => false, 'error' => 'No matching rate card found'], 404);
    }
}
