<?php
require_once __DIR__ . '/BaseModel.php';

class Booking extends BaseModel {
    protected $table = 'bookings';

    public function create($data) {
        $bookingId = 'TRN-' . date('ymd') . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT);
        $stmt = $this->db->prepare("INSERT INTO bookings (booking_id, customer_id, origin, destination, distance_km, cargo_type, weight_kg, amount, status, pickup_date, pickup_time, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'requested', ?, ?, ?)");
        return $stmt->execute([
            $bookingId, $data['customer_id'], $data['origin'], $data['destination'],
            $data['distance_km'], $data['cargo_type'], $data['weight_kg'], $data['amount'],
            $data['pickup_date'] ?? null, $data['pickup_time'] ?? null, $data['notes'] ?? null
        ]);
    }

    public function update($id, $data) {
        $fields = []; $values = [];
        foreach (['truck_id', 'status', 'pickup_date', 'pickup_time', 'notes'] as $f) {
            if (isset($data[$f])) { $fields[] = "$f = ?"; $values[] = $data[$f]; }
        }
        $values[] = $id;
        return $this->db->prepare("UPDATE bookings SET " . implode(', ', $fields) . " WHERE id = ?")->execute($values);
    }

    public function getAllWithDetails($status = null, $limit = null) {
        $sql = "SELECT b.*, u.name as customer_name, u.phone as customer_phone, u.avatar,
                t.plate_number, t.truck_type
                FROM bookings b
                JOIN users u ON b.customer_id = u.id
                LEFT JOIN trucks t ON b.truck_id = t.id";
        if ($status) $sql .= " WHERE b.status = '{$status}'";
        $sql .= " ORDER BY b.created_at DESC";
        if ($limit) $sql .= " LIMIT {$limit}";
        return $this->db->query($sql)->fetchAll();
    }

    public function assign($id, $truckId, $pickupDate, $pickupTime, $notes = null) {
        $stmt = $this->db->prepare("UPDATE bookings SET truck_id = ?, status = 'assigned', pickup_date = ?, pickup_time = ?, notes = ? WHERE id = ?");
        return $stmt->execute([$truckId, $pickupDate, $pickupTime, $notes, $id]);
    }

    public function getStats() {
        return [
            'total' => $this->count(),
            'requested' => $this->count("status = 'requested'"),
            'assigned' => $this->count("status = 'assigned'"),
            'en_route' => $this->count("status = 'en_route'"),
            'completed' => $this->count("status = 'completed'")
        ];
    }
}
