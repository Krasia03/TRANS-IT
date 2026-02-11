<?php
require_once __DIR__ . '/BaseModel.php';

class Transaction extends BaseModel {
    protected $table = 'transactions';

    public function create($data) {
        $txnId = 'TXN-' . date('Ymd') . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT);
        $stmt = $this->db->prepare("INSERT INTO transactions (transaction_id, booking_id, amount, method, status) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([$txnId, $data['booking_id'], $data['amount'], $data['method'], $data['status'] ?? 'pending']);
    }

    public function getAllWithDetails() {
        return $this->db->query("SELECT t.*, b.booking_id as booking_ref, u.name as customer_name
            FROM transactions t
            JOIN bookings b ON t.booking_id = b.id
            JOIN users u ON b.customer_id = u.id
            ORDER BY t.created_at DESC")->fetchAll();
    }

    public function getStats() {
        $row = $this->db->query("SELECT 
            SUM(amount) as total, 
            SUM(CASE WHEN status = 'in_escrow' THEN amount ELSE 0 END) as escrow
            FROM transactions WHERE status IN ('completed', 'in_escrow')")->fetch();
        return ['total' => $row['total'] ?? 0, 'escrow' => $row['escrow'] ?? 0];
    }
}
