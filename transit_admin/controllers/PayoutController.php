<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/Payout.php';
require_once __DIR__ . '/../models/Activity.php';

class PayoutController extends BaseController {
    private $model;
    private $activity;

    public function __construct() {
        $this->model = new Payout();
        $this->activity = new Activity();
    }

    public function index() {
        $this->json(['success' => true, 'data' => $this->model->getAllPending()]);
    }

    public function store() {
        $data = $this->getInput();
        if (empty($data['driver_id']) || empty($data['booking_id']) || empty($data['amount']) || empty($data['method'])) {
            $this->json(['success' => false, 'error' => 'Missing required fields'], 400);
        }
        if ($this->model->create($data)) {
            $this->json(['success' => true, 'message' => 'Payout scheduled']);
        }
        $this->json(['success' => false, 'error' => 'Failed to schedule payout'], 500);
    }

    public function process($id) {
        if ($this->model->process($id)) {
            $this->activity->create('payment', 'Payout processed', "Payout #$id sent to driver");
            $this->json(['success' => true, 'message' => 'Payout processed']);
        }
        $this->json(['success' => false, 'error' => 'Failed to process payout'], 500);
    }

    public function processAll() {
        $count = $this->model->processAll();
        $this->activity->create('payment', 'All payouts processed', "$count payouts sent");
        $this->json(['success' => true, 'message' => "$count payouts processed"]);
    }

    public function stats() {
        $this->json(['success' => true, 'data' => $this->model->getStats()]);
    }
}
