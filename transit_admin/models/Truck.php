<?php
require_once __DIR__ . '/BaseModel.php';

class Truck extends BaseModel {
    protected $table = 'trucks';

    public function create($data) {
        $stmt = $this->db->prepare("INSERT INTO trucks (plate_number, owner_id, truck_type, capacity_kg, status, availability) VALUES (?, ?, ?, ?, 'pending', 'offline')");
        return $stmt->execute([$data['plate_number'], $data['owner_id'], $data['truck_type'], $data['capacity_kg']]);
    }

    public function update($id, $data) {
        $fields = []; $values = [];
        foreach (['plate_number', 'truck_type', 'capacity_kg', 'status', 'availability', 'rating'] as $f) {
            if (isset($data[$f])) { $fields[] = "$f = ?"; $values[] = $data[$f]; }
        }
        $values[] = $id;
        return $this->db->prepare("UPDATE trucks SET " . implode(', ', $fields) . " WHERE id = ?")->execute($values);
    }

    public function getAllWithOwner($status = null) {
        $sql = "SELECT t.*, u.name as owner_name, u.phone as owner_phone, u.avatar
                FROM trucks t JOIN users u ON t.owner_id = u.id";
        if ($status) $sql .= " WHERE t.status = '{$status}'";
        $sql .= " ORDER BY t.created_at DESC";
        return $this->db->query($sql)->fetchAll();
    }

    public function getAvailable() {
        return $this->db->query("SELECT t.*, u.name as owner_name, u.avatar FROM trucks t 
            JOIN users u ON t.owner_id = u.id 
            WHERE t.status = 'verified' AND t.availability = 'available'")->fetchAll();
    }

    public function verify($id) {
        return $this->update($id, ['status' => 'verified', 'availability' => 'available']);
    }

    public function getStats() {
        return [
            'total' => $this->count(),
            'verified' => $this->count("status = 'verified'"),
            'pending' => $this->count("status = 'pending'"),
            'available' => $this->count("status = 'verified' AND availability = 'available'"),
            'en_route' => $this->count("availability = 'en_route'")
        ];
    }
}
