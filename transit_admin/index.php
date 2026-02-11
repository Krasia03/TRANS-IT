<?php
// TRANSIT Admin Dashboard - Main Entry Point
session_start();
$page = $_GET['page'] ?? 'dashboard';
$validPages = ['dashboard', 'bookings', 'fleet', 'tracking', 'payments', 'payouts', 'rates', 'users', 'reports'];
if (!in_array($page, $validPages)) $page = 'dashboard';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRANSIT Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <link rel="stylesheet" href="public/css/style.css">
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-hdr">
            <div class="logo"><div class="logo-icon">🚛</div>TRANSIT</div>
            <div class="logo-sub">Admin Dashboard</div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-sec">Main</div>
            <a class="nav-item <?= $page === 'dashboard' ? 'active' : '' ?>" href="?page=dashboard">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Dashboard
            </a>
            <a class="nav-item <?= $page === 'bookings' ? 'active' : '' ?>" href="?page=bookings">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg>
                Bookings<span class="nav-badge" id="bookingCount">0</span>
            </a>
            <a class="nav-item <?= $page === 'fleet' ? 'active' : '' ?>" href="?page=fleet">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13" rx="2"/><path d="M16 8h4l3 3v5a2 2 0 01-2 2h-1M6 19a2 2 0 100-4 2 2 0 000 4zm12 0a2 2 0 100-4 2 2 0 000 4z"/></svg>
                Fleet
            </a>
            <a class="nav-item <?= $page === 'tracking' ? 'active' : '' ?>" href="?page=tracking">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="10" r="3"/><path d="M12 2a8 8 0 018 8c0 5.4-8 12-8 12S4 15.4 4 10a8 8 0 018-8z"/></svg>
                Live Tracking
            </a>
            <div class="nav-sec">Finance</div>
            <a class="nav-item <?= $page === 'payments' ? 'active' : '' ?>" href="?page=payments">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2"/><path d="M1 10h22"/></svg>
                Payments
            </a>
            <a class="nav-item <?= $page === 'payouts' ? 'active' : '' ?>" href="?page=payouts">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20m5-17H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
                Payouts
            </a>
            <div class="nav-sec">Settings</div>
            <a class="nav-item <?= $page === 'rates' ? 'active' : '' ?>" href="?page=rates">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                Rate Cards
            </a>
            <a class="nav-item <?= $page === 'users' ? 'active' : '' ?>" href="?page=users">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87m-4-12a4 4 0 010 7.75"/></svg>
                Users
            </a>
            <a class="nav-item <?= $page === 'reports' ? 'active' : '' ?>" href="?page=reports">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><path d="M14 2v6h6m-4 5H8m8 4H8m2-8H8"/></svg>
                Reports
            </a>
        </nav>
        <div class="sidebar-ftr">
            <div class="user-info">
                <div class="user-avatar">JM</div>
                <div><div class="user-name">John Mwamba</div><div class="user-role">Super Admin</div></div>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main">
        <header class="header">
            <div class="header-left">
                <button class="menu-btn" onclick="toggleSidebar()">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
                </button>
                <div>
                    <h1 class="page-title" id="pageTitle"><?= ucfirst($page) ?></h1>
                    <div class="breadcrumb"><a href="?page=dashboard">Home</a><span>/</span><span><?= ucfirst($page) ?></span></div>
                </div>
            </div>
            <div class="header-right">
                <div class="search-box">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                    <input type="text" placeholder="Search bookings, trucks..." id="searchInput">
                </div>
                <button class="hdr-btn hide-mob"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9m-4.27 13a2 2 0 01-3.46 0"/></svg><span class="notif-dot"></span></button>
            </div>
        </header>

        <div class="content">
            <?php include "views/{$page}.php"; ?>
        </div>
    </main>

    <!-- Modals -->
    <?php include "views/partials/modals.php"; ?>

    <!-- Toast Container -->
    <div class="toast-box" id="toastBox"></div>

    <script src="public/js/app.js"></script>
    <script>
        const currentPage = '<?= $page ?>';
        document.addEventListener('DOMContentLoaded', () => initPage(currentPage));
    </script>
</body>
</html>
