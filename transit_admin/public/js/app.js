// TRANSIT Admin Dashboard - JavaScript
const API_BASE = 'api.php/';

// API Helper
async function api(endpoint, method = 'GET', data = null) {
    const options = { method, headers: { 'Content-Type': 'application/json' } };
    if (data) options.body = JSON.stringify(data);
    try {
        const res = await fetch(API_BASE + endpoint, options);
        return await res.json();
    } catch (e) {
        console.error('API Error:', e);
        return { success: false, error: e.message };
    }
}

// Toast notifications
function showToast(type, title, message) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `<div class="toast-icon ${type}">${type === 'success' ? '✓' : '✕'}</div><div class="toast-content"><div class="toast-title">${title}</div><div class="toast-msg">${message}</div></div>`;
    document.getElementById('toastBox').appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
}

// Modal functions
function openModal(id) { document.getElementById(id)?.classList.add('active'); }
function closeModal(id) { document.getElementById(id)?.classList.remove('active'); }
function toggleSidebar() { document.getElementById('sidebar').classList.toggle('open'); }

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-TZ').format(amount);
}

// Format date
function formatDate(dateStr) {
    return new Date(dateStr).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

// Time ago
function timeAgo(dateStr) {
    const diff = Date.now() - new Date(dateStr).getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 60) return `${mins}m ago`;
    const hrs = Math.floor(mins / 60);
    if (hrs < 24) return `${hrs}h ago`;
    return `${Math.floor(hrs / 24)}d ago`;
}

// Initialize page
async function initPage(page) {
    switch (page) {
        case 'dashboard': await loadDashboard(); break;
        case 'bookings': await loadBookings(); break;
        case 'fleet': await loadFleet(); break;
        case 'payments': await loadPayments(); break;
        case 'payouts': await loadPayouts(); break;
        case 'rates': await loadRates(); break;
        case 'users': await loadUsers(); break;
    }
}

// Dashboard
async function loadDashboard() {
    const res = await api('dashboard');
    if (!res.success) return;
    const d = res.data;
    
    document.getElementById('totalBookings').textContent = d.bookings.total;
    document.getElementById('activeTrucks').textContent = d.trucks.available;
    document.getElementById('totalRevenue').textContent = formatCurrency(d.revenue / 1000000) + 'M';
    document.getElementById('bookingCount').textContent = d.bookings.requested;
    
    // Activity
    const activityHtml = d.activities.map(a => `
        <div class="act-item">
            <div class="act-icon ${a.action_type}">${getActionIcon(a.action_type)}</div>
            <div class="act-content">
                <div class="act-title">${a.title}</div>
                <div class="act-desc">${a.description}</div>
            </div>
            <div class="act-time">${timeAgo(a.created_at)}</div>
        </div>
    `).join('');
    document.getElementById('activityList').innerHTML = activityHtml;
    
    initCharts(d);
}

function getActionIcon(type) {
    const icons = { booking: '📦', payment: '💳', truck: '🚛', alert: '⚠️', delivery: '✅' };
    return icons[type] || '📋';
}

function initCharts(data) {
    // Revenue Chart
    if (document.getElementById('revenueChart')) {
        new Chart(document.getElementById('revenueChart'), {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Revenue (M TZS)',
                    data: [28, 32, 35, 38, 42, 45, 48, 52, 55, 58, 62, 68],
                    borderColor: '#19297C', backgroundColor: 'rgba(25,41,124,0.08)', fill: true, tension: 0.4, borderWidth: 3
                }]
            },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
        });
    }
    
    // Status Chart
    if (document.getElementById('statusChart')) {
        new Chart(document.getElementById('statusChart'), {
            type: 'doughnut',
            data: {
                labels: ['Completed', 'En Route', 'Assigned', 'Requested'],
                datasets: [{ data: [data.bookings.completed, data.bookings.en_route, data.bookings.assigned, data.bookings.requested], backgroundColor: ['#19297C', '#8b5cf6', '#3b82f6', '#f59e0b'], borderWidth: 0 }]
            },
            options: { responsive: true, maintainAspectRatio: false, cutout: '72%' }
        });
    }
}

// Bookings
async function loadBookings() {
    const res = await api('bookings');
    if (!res.success) return;
    
    const tbody = document.getElementById('bookingsTable');
    if (!tbody) return;
    
    tbody.innerHTML = res.data.map(b => `
        <tr>
            <td><span class="tbl-id">${b.booking_id}</span></td>
            <td><div class="tbl-user"><div class="tbl-avatar">${b.avatar || 'XX'}</div><div><div class="tbl-name">${b.customer_name}</div><div class="tbl-sub">${b.customer_phone}</div></div></div></td>
            <td><div class="tbl-name">${b.origin} → ${b.destination}</div><div class="tbl-sub">${b.distance_km} km</div></td>
            <td><div class="tbl-name">${b.cargo_type}</div><div class="tbl-sub">${formatCurrency(b.weight_kg)} kg</div></td>
            <td><strong style="color:var(--green)">TZS ${formatCurrency(b.amount)}</strong></td>
            <td><span class="badge badge-${b.status}"><span class="badge-dot"></span>${b.status}</span></td>
            <td>${formatDate(b.created_at)}</td>
            <td>
                ${b.status === 'requested' ? `<button class="btn btn-primary btn-sm" onclick="showAssignModal(${b.id})">Assign</button>` : ''}
                <button class="btn btn-secondary btn-sm btn-icon" onclick="editBooking(${b.id})">✏️</button>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="deleteBooking(${b.id})">🗑️</button>
            </td>
        </tr>
    `).join('');
}

async function showAssignModal(bookingId) {
    window.currentBookingId = bookingId;
    const trucks = await api('trucks/available');
    const select = document.getElementById('truckSelect');
    if (select && trucks.success) {
        select.innerHTML = '<option value="">Choose a truck...</option>' + 
            trucks.data.map(t => `<option value="${t.id}">${t.plate_number} — ${t.truck_type} (${formatCurrency(t.capacity_kg)} kg) — ${t.owner_name} ⭐${t.rating || 'N/A'}</option>`).join('');
    }
    openModal('assignModal');
}

async function assignTruck() {
    const data = {
        truck_id: document.getElementById('truckSelect').value,
        pickup_date: document.getElementById('pickupDate').value,
        pickup_time: document.getElementById('pickupTime').value,
        notes: document.getElementById('assignNotes').value
    };
    const res = await api(`bookings/${window.currentBookingId}/assign`, 'POST', data);
    closeModal('assignModal');
    if (res.success) {
        showToast('success', 'Truck Assigned', 'Booking has been assigned successfully');
        loadBookings();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function createBooking() {
    const data = {
        customer_id: document.getElementById('newCustomerId').value,
        origin: document.getElementById('newOrigin').value,
        destination: document.getElementById('newDestination').value,
        distance_km: document.getElementById('newDistance').value,
        cargo_type: document.getElementById('newCargoType').value,
        weight_kg: document.getElementById('newWeight').value,
        amount: document.getElementById('newAmount').value
    };
    const res = await api('bookings', 'POST', data);
    closeModal('bookingModal');
    if (res.success) {
        showToast('success', 'Booking Created', 'New booking has been created');
        loadBookings();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function deleteBooking(id) {
    if (!confirm('Are you sure you want to delete this booking?')) return;
    const res = await api(`bookings/${id}`, 'DELETE');
    if (res.success) {
        showToast('success', 'Deleted', 'Booking has been deleted');
        loadBookings();
    } else {
        showToast('error', 'Error', res.error);
    }
}

// Fleet
async function loadFleet() {
    const res = await api('trucks');
    const stats = await api('trucks/stats');
    
    if (stats.success) {
        document.getElementById('totalTrucks').textContent = stats.data.total;
        document.getElementById('verifiedTrucks').textContent = stats.data.verified;
        document.getElementById('availableTrucks').textContent = stats.data.available;
        document.getElementById('enrouteTrucks').textContent = stats.data.en_route;
    }
    
    if (!res.success) return;
    const tbody = document.getElementById('fleetTable');
    if (!tbody) return;
    
    tbody.innerHTML = res.data.map(t => `
        <tr>
            <td><span class="tbl-id">${t.plate_number}</span></td>
            <td><div class="tbl-user"><div class="tbl-avatar">${t.avatar || 'XX'}</div><div><div class="tbl-name">${t.owner_name}</div><div class="tbl-sub">${t.owner_phone}</div></div></div></td>
            <td>${t.truck_type}</td>
            <td>${formatCurrency(t.capacity_kg)} kg</td>
            <td><span class="badge badge-${t.status}"><span class="badge-dot"></span>${t.status}</span></td>
            <td><span class="badge badge-${t.availability}"><span class="badge-dot"></span>${t.availability}</span></td>
            <td>${t.rating ? '⭐ ' + t.rating : '—'}</td>
            <td>
                ${t.status === 'pending' ? `<button class="btn btn-primary btn-sm" onclick="verifyTruck(${t.id})">Verify</button>` : ''}
                <button class="btn btn-secondary btn-sm btn-icon" onclick="editTruck(${t.id})">✏️</button>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="deleteTruck(${t.id})">🗑️</button>
            </td>
        </tr>
    `).join('');
}

async function verifyTruck(id) {
    const res = await api(`trucks/${id}/verify`, 'POST');
    if (res.success) {
        showToast('success', 'Truck Verified', 'Truck has been verified and activated');
        loadFleet();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function createTruck() {
    const data = {
        plate_number: document.getElementById('newPlate').value,
        owner_id: document.getElementById('newOwnerId').value,
        truck_type: document.getElementById('newTruckType').value,
        capacity_kg: document.getElementById('newCapacity').value
    };
    const res = await api('trucks', 'POST', data);
    closeModal('truckModal');
    if (res.success) {
        showToast('success', 'Truck Added', 'New truck has been added');
        loadFleet();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function deleteTruck(id) {
    if (!confirm('Are you sure you want to delete this truck?')) return;
    const res = await api(`trucks/${id}`, 'DELETE');
    if (res.success) {
        showToast('success', 'Deleted', 'Truck has been deleted');
        loadFleet();
    } else {
        showToast('error', 'Error', res.error);
    }
}

// Payments
async function loadPayments() {
    const res = await api('transactions');
    const stats = await api('transactions/stats');
    
    if (stats.success) {
        document.getElementById('totalCollected').textContent = formatCurrency(stats.data.total / 1000000) + 'M';
        document.getElementById('inEscrow').textContent = formatCurrency(stats.data.escrow / 1000000) + 'M';
    }
    
    if (!res.success) return;
    const tbody = document.getElementById('paymentsTable');
    if (!tbody) return;
    
    tbody.innerHTML = res.data.map(t => `
        <tr>
            <td><span class="tbl-id">${t.transaction_id}</span></td>
            <td>${t.booking_ref}</td>
            <td>${t.customer_name}</td>
            <td><strong style="color:var(--green)">TZS ${formatCurrency(t.amount)}</strong></td>
            <td>${t.method}</td>
            <td><span class="badge badge-${t.status}"><span class="badge-dot"></span>${t.status}</span></td>
            <td>${formatDate(t.created_at)}</td>
        </tr>
    `).join('');
}

// Payouts
async function loadPayouts() {
    const res = await api('payouts');
    const stats = await api('payouts/stats');
    
    if (stats.success) {
        document.getElementById('totalPaidOut').textContent = formatCurrency(stats.data.paid / 1000000) + 'M';
        document.getElementById('pendingPayouts').textContent = formatCurrency(stats.data.pending / 1000000) + 'M';
    }
    
    if (!res.success) return;
    const tbody = document.getElementById('payoutsTable');
    if (!tbody) return;
    
    tbody.innerHTML = res.data.map(p => `
        <tr>
            <td><div class="tbl-user"><div class="tbl-avatar">${p.avatar || 'XX'}</div><div><div class="tbl-name">${p.driver_name}</div><div class="tbl-sub">${p.driver_phone}</div></div></div></td>
            <td>${p.booking_ref}</td>
            <td><strong style="color:var(--green)">TZS ${formatCurrency(p.amount)}</strong></td>
            <td>${p.method}</td>
            <td><span class="badge badge-${p.status}"><span class="badge-dot"></span>${p.status}</span></td>
            <td><button class="btn btn-primary btn-sm" onclick="processPayout(${p.id}, '${p.driver_name}', ${p.amount})">Pay Now</button></td>
        </tr>
    `).join('');
}

async function processPayout(id, name, amount) {
    const res = await api(`payouts/${id}/process`, 'POST');
    if (res.success) {
        showToast('success', 'Payout Processed', `TZS ${formatCurrency(amount)} sent to ${name}`);
        loadPayouts();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function processAllPayouts() {
    const res = await api('payouts/process-all', 'POST');
    if (res.success) {
        showToast('success', 'All Payouts Processed', res.message);
        loadPayouts();
    } else {
        showToast('error', 'Error', res.error);
    }
}

// Rate Cards
async function loadRates() {
    const res = await api('rates');
    if (!res.success) return;
    
    const container = document.getElementById('ratesContainer');
    if (!container) return;
    
    container.innerHTML = res.data.map(r => `
        <div class="rate-card">
            <div class="rate-hdr">
                <div class="rate-title">🚛 ${r.truck_type} — ${r.cargo_type} Cargo</div>
                <span class="badge badge-${r.status}"><span class="badge-dot"></span>${r.status}</span>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="editRate(${r.id})">✏️</button>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="deleteRate(${r.id})">🗑️</button>
            </div>
            <div class="rate-grid">
                <div class="rate-item"><div class="rate-val">${formatCurrency(r.base_rate)}</div><div class="rate-lbl">Base Rate (TZS)</div></div>
                <div class="rate-item"><div class="rate-val">${formatCurrency(r.per_km_rate)}</div><div class="rate-lbl">Per KM (TZS)</div></div>
                <div class="rate-item"><div class="rate-val">${formatCurrency(r.per_kg_rate)}</div><div class="rate-lbl">Per KG (TZS)</div></div>
                <div class="rate-item"><div class="rate-val">${r.commission_percent}%</div><div class="rate-lbl">Commission</div></div>
            </div>
        </div>
    `).join('');
}

async function createRate() {
    const data = {
        truck_type: document.getElementById('newRateTruckType').value,
        cargo_type: document.getElementById('newRateCargoType').value,
        base_rate: document.getElementById('newBaseRate').value,
        per_km_rate: document.getElementById('newPerKmRate').value,
        per_kg_rate: document.getElementById('newPerKgRate').value,
        commission_percent: document.getElementById('newCommission').value
    };
    const res = await api('rates', 'POST', data);
    closeModal('rateModal');
    if (res.success) {
        showToast('success', 'Rate Card Created', 'New rate card has been created');
        loadRates();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function deleteRate(id) {
    if (!confirm('Are you sure you want to delete this rate card?')) return;
    const res = await api(`rates/${id}`, 'DELETE');
    if (res.success) {
        showToast('success', 'Deleted', 'Rate card has been deleted');
        loadRates();
    } else {
        showToast('error', 'Error', res.error);
    }
}

// Users
async function loadUsers() {
    const res = await api('users');
    const stats = await api('users/stats');
    
    if (!res.success) return;
    const tbody = document.getElementById('usersTable');
    if (!tbody) return;
    
    tbody.innerHTML = res.data.map(u => `
        <tr>
            <td><div class="tbl-user"><div class="tbl-avatar">${u.avatar || 'XX'}</div><div><div class="tbl-name">${u.name}</div><div class="tbl-sub">${u.email}</div></div></div></td>
            <td>${u.phone}</td>
            <td><span class="badge badge-${u.role === 'driver' ? 'enroute' : u.role === 'cargo_owner' ? 'assigned' : 'completed'}"><span class="badge-dot"></span>${u.role.replace('_', ' ')}</span></td>
            <td><span class="badge badge-${u.status}"><span class="badge-dot"></span>${u.status}</span></td>
            <td>${formatDate(u.created_at)}</td>
            <td>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="editUser(${u.id})">✏️</button>
                <button class="btn btn-secondary btn-sm btn-icon" onclick="deleteUser(${u.id})">🗑️</button>
            </td>
        </tr>
    `).join('');
}

async function createUser() {
    const data = {
        name: document.getElementById('newUserName').value,
        email: document.getElementById('newUserEmail').value,
        phone: document.getElementById('newUserPhone').value,
        password: document.getElementById('newUserPassword').value,
        role: document.getElementById('newUserRole').value
    };
    const res = await api('users', 'POST', data);
    closeModal('userModal');
    if (res.success) {
        showToast('success', 'User Created', 'New user has been created');
        loadUsers();
    } else {
        showToast('error', 'Error', res.error);
    }
}

async function deleteUser(id) {
    if (!confirm('Are you sure you want to delete this user?')) return;
    const res = await api(`users/${id}`, 'DELETE');
    if (res.success) {
        showToast('success', 'Deleted', 'User has been deleted');
        loadUsers();
    } else {
        showToast('error', 'Error', res.error);
    }
}

// Reports
function generateReport(type) {
    const names = { operational: 'Operational', financial: 'Financial', fleet: 'Fleet' };
    showToast('success', 'Report Generated', `${names[type]} report is ready for download`);
}
