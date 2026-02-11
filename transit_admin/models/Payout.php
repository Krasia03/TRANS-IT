<?php
require_once __DIR__ . '/BaseModel.php';

class Payout extends BaseModel {
    protected $table = 'payouts';

    public function create($data) {
        $stmt = $this->db->prepare("INSERT INTO payouts (driver_id, booking_id, amount, method, status) VALUES (?, ?, ?, ?, 'ready')");
        return $stmt->execute([$data['driver_id'], $data['booking_id'], $data['amount'], $data['method']]);
    }

    public function getAllPending() {
        return $this->db->query("SELECT p.*, u.name as driver_name, u.phone as driver_phone, u.avatar, b.booking_id as booking_ref
            FROM payouts p
            JOIN users u ON p.driver_id = u.id
            JOIN bookings b ON p.booking_id = b.id
            WHERE p.status IN ('pending', 'ready')
            ORDER BY p.created_at DESC")->fetchAll();
    }

    public function process($id) {
        $stmt = $this->db->prepare("UPDATE payouts SET status = 'processed', processed_at = NOW() WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function processAll() {
        return $this->db->exec("UPDATE payouts SET status = 'processed', processed_at = NOW() WHERE status IN ('pending', 'ready')");
    }

    public function getStats() {
        $row = $this->db->query("SELECT 
            SUM(CASE WHEN status = 'processed' THEN amount ELSE 0 END) as paid,
            SUM(CASE WHEN status IN ('pending', 'ready') THEN amount ELSE 0 END) as pending
            FROM payouts")->fetch();
        return ['paid' => $row['paid'] ?? 0, 'pending' => $row['pending'] ?? 0];
    }
}
