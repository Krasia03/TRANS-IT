<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/Transaction.php';

class TransactionController extends BaseController {
    private $model;

    public function __construct() {
        $this->model = new Transaction();
    }

    public function index() {
        $this->json(['success' => true, 'data' => $this->model->getAllWithDetails()]);
    }

    public function store() {
        $data = $this->getInput();
        if (empty($data['booking_id']) || empty($data['amount']) || empty($data['method'])) {
            $this->json(['success' => false, 'error' => 'Missing required fields'], 400);
        }
        if ($this->model->create($data)) {
            $this->json(['success' => true, 'message' => 'Transaction recorded']);
        }
        $this->json(['success' => false, 'error' => 'Failed to record transaction'], 500);
    }

    public function stats() {
        $this->json(['success' => true, 'data' => $this->model->getStats()]);
    }
}
