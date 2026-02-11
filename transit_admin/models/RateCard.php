<?php
require_once __DIR__ . '/BaseModel.php';

class RateCard extends BaseModel {
    protected $table = 'rate_cards';

    public function create($data) {
        $stmt = $this->db->prepare("INSERT INTO rate_cards (truck_type, cargo_type, base_rate, per_km_rate, per_kg_rate, commission_percent, status) VALUES (?, ?, ?, ?, ?, ?, 'active')");
        return $stmt->execute([$data['truck_type'], $data['cargo_type'], $data['base_rate'], $data['per_km_rate'], $data['per_kg_rate'], $data['commission_percent']]);
    }

    public function update($id, $data) {
        $fields = []; $values = [];
        foreach (['truck_type', 'cargo_type', 'base_rate', 'per_km_rate', 'per_kg_rate', 'commission_percent', 'status'] as $f) {
            if (isset($data[$f])) { $fields[] = "$f = ?"; $values[] = $data[$f]; }
        }
        $values[] = $id;
        return $this->db->prepare("UPDATE rate_cards SET " . implode(', ', $fields) . " WHERE id = ?")->execute($values);
    }

    public function calculateRate($truckType, $cargoType, $distanceKm, $weightKg) {
        $stmt = $this->db->prepare("SELECT * FROM rate_cards WHERE truck_type = ? AND cargo_type = ? AND status = 'active'");
        $stmt->execute([$truckType, $cargoType]);
        $rate = $stmt->fetch();
        if (!$rate) return null;
        $total = $rate['base_rate'] + ($rate['per_km_rate'] * $distanceKm) + ($rate['per_kg_rate'] * $weightKg);
        return ['total' => $total, 'commission' => $total * ($rate['commission_percent'] / 100)];
    }
}
