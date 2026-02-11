<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../models/User.php';

class UserController extends BaseController {
    private $model;

    public function __construct() {
        $this->model = new User();
    }

    public function index() {
        $role = $_GET['role'] ?? null;
        $users = $role ? $this->model->getByRole($role) : $this->model->getAll('name ASC');
        $this->json(['success' => true, 'data' => $users]);
    }

    public function show($id) {
        $user = $this->model->find($id);
        if (!$user) $this->json(['success' => false, 'error' => 'User not found'], 404);
        $this->json(['success' => true, 'data' => $user]);
    }

    public function store() {
        $data = $this->getInput();
        if (empty($data['name']) || empty($data['email']) || empty($data['phone']) || empty($data['password'])) {
            $this->json(['success' => false, 'error' => 'Missing required fields'], 400);
        }
        if ($this->model->create($data)) {
            $this->json(['success' => true, 'message' => 'User created']);
        }
        $this->json(['success' => false, 'error' => 'Failed to create user'], 500);
    }

    public function update($id) {
        $data = $this->getInput();
        if ($this->model->update($id, $data)) {
            $this->json(['success' => true, 'message' => 'User updated']);
        }
        $this->json(['success' => false, 'error' => 'Failed to update user'], 500);
    }

    public function delete($id) {
        if ($this->model->delete($id)) {
            $this->json(['success' => true, 'message' => 'User deleted']);
        }
        $this->json(['success' => false, 'error' => 'Failed to delete user'], 500);
    }

    public function stats() {
        $this->json(['success' => true, 'data' => [
            'total' => $this->model->count(),
            'cargo_owners' => $this->model->count("role = 'cargo_owner'"),
            'drivers' => $this->model->count("role = 'driver'"),
            'admins' => $this->model->count("role IN ('admin', 'super_admin')")
        ]]);
    }
}
