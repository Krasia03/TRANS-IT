<?php
require_once __DIR__ . '/BaseModel.php';

class User extends BaseModel {
    protected $table = 'users';

    public function create($data) {
        $stmt = $this->db->prepare("INSERT INTO users (name, email, phone, password, role, status, avatar) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $avatar = strtoupper(substr($data['name'], 0, 1) . substr(strrchr($data['name'], ' '), 1, 1));
        return $stmt->execute([
            $data['name'], $data['email'], $data['phone'],
            password_hash($data['password'], PASSWORD_DEFAULT),
            $data['role'] ?? 'cargo_owner', $data['status'] ?? 'active', $avatar
        ]);
    }

    public function update($id, $data) {
        $fields = []; $values = [];
        foreach (['name', 'email', 'phone', 'role', 'status'] as $f) {
            if (isset($data[$f])) { $fields[] = "$f = ?"; $values[] = $data[$f]; }
        }
        if (isset($data['password']) && !empty($data['password'])) {
            $fields[] = "password = ?"; $values[] = password_hash($data['password'], PASSWORD_DEFAULT);
        }
        $values[] = $id;
        return $this->db->prepare("UPDATE users SET " . implode(', ', $fields) . " WHERE id = ?")->execute($values);
    }

    public function getByRole($role) {
        $stmt = $this->db->prepare("SELECT * FROM users WHERE role = ? ORDER BY name");
        $stmt->execute([$role]);
        return $stmt->fetchAll();
    }

    public function authenticate($email, $password) {
        $stmt = $this->db->prepare("SELECT * FROM users WHERE email = ? AND status = 'active'");
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        if ($user && password_verify($password, $user['password'])) return $user;
        return false;
    }
}
