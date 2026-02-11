<?php
require_once __DIR__ . '/../config/database.php';

class BaseModel {
    protected $db;
    protected $table;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAll($orderBy = 'id DESC', $limit = null) {
        $sql = "SELECT * FROM {$this->table} ORDER BY {$orderBy}";
        if ($limit) $sql .= " LIMIT {$limit}";
        return $this->db->query($sql)->fetchAll();
    }

    public function find($id) {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE id = ?");
        return $stmt->execute([$id]);
    }

    public function count($where = '') {
        $sql = "SELECT COUNT(*) as total FROM {$this->table}";
        if ($where) $sql .= " WHERE {$where}";
        return $this->db->query($sql)->fetch()['total'];
    }
}
