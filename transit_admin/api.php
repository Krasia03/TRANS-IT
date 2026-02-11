<?php
// TRANSIT Admin Dashboard - API Router
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = str_replace('/api.php', '', $uri);
$uri = trim($uri, '/');
$method = $_SERVER['REQUEST_METHOD'];

// Routes
$routes = [
    'GET' => [
        '' => ['DashboardController', 'index'],
        'dashboard' => ['DashboardController', 'index'],
        'users' => ['UserController', 'index'],
        'users/stats' => ['UserController', 'stats'],
        'users/(\d+)' => ['UserController', 'show'],
        'bookings' => ['BookingController', 'index'],
        'bookings/stats' => ['BookingController', 'stats'],
        'bookings/(\d+)' => ['BookingController', 'show'],
        'trucks' => ['TruckController', 'index'],
        'trucks/available' => ['TruckController', 'available'],
        'trucks/stats' => ['TruckController', 'stats'],
        'trucks/(\d+)' => ['TruckController', 'show'],
        'transactions' => ['TransactionController', 'index'],
        'transactions/stats' => ['TransactionController', 'stats'],
        'payouts' => ['PayoutController', 'index'],
        'payouts/stats' => ['PayoutController', 'stats'],
        'rates' => ['RateCardController', 'index'],
        'rates/(\d+)' => ['RateCardController', 'show'],
    ],
    'POST' => [
        'users' => ['UserController', 'store'],
        'bookings' => ['BookingController', 'store'],
        'bookings/(\d+)/assign' => ['BookingController', 'assign'],
        'trucks' => ['TruckController', 'store'],
        'trucks/(\d+)/verify' => ['TruckController', 'verify'],
        'transactions' => ['TransactionController', 'store'],
        'payouts' => ['PayoutController', 'store'],
        'payouts/process-all' => ['PayoutController', 'processAll'],
        'payouts/(\d+)/process' => ['PayoutController', 'process'],
        'rates' => ['RateCardController', 'store'],
        'rates/calculate' => ['RateCardController', 'calculate'],
    ],
    'PUT' => [
        'users/(\d+)' => ['UserController', 'update'],
        'bookings/(\d+)' => ['BookingController', 'update'],
        'trucks/(\d+)' => ['TruckController', 'update'],
        'rates/(\d+)' => ['RateCardController', 'update'],
    ],
    'DELETE' => [
        'users/(\d+)' => ['UserController', 'delete'],
        'bookings/(\d+)' => ['BookingController', 'delete'],
        'trucks/(\d+)' => ['TruckController', 'delete'],
        'rates/(\d+)' => ['RateCardController', 'delete'],
    ]
];

// Match route
$matched = false;
if (isset($routes[$method])) {
    foreach ($routes[$method] as $pattern => $handler) {
        $regex = '/^' . str_replace('/', '\/', $pattern) . '$/';
        if (preg_match($regex, $uri, $matches)) {
            array_shift($matches);
            require_once __DIR__ . "/controllers/{$handler[0]}.php";
            $controller = new $handler[0]();
            call_user_func_array([$controller, $handler[1]], $matches);
            $matched = true;
            break;
        }
    }
}

if (!$matched) {
    http_response_code(404);
    echo json_encode(['success' => false, 'error' => 'Route not found']);
}
