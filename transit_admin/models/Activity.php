<?php
require_once __DIR__ . '/BaseModel.php';

class Activity extends BaseModel {
    protected $table = 'activity_log';

    public function create($type, $title, $description, $userId = null) {
        $stmt = $this->db->prepare("INSERT INTO activity_log (user_id, action_type, title, description) VALUES (?, ?, ?, ?)");
        return $stmt->execute([$userId, $type, $title, $description]);
    }

    public function getRecent($limit = 10) {
        return $this->db->query("SELECT * FROM activity_log ORDER BY created_at DESC LIMIT {$limit}")->fetchAll();
    }
}
