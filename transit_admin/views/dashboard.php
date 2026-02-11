<!-- Dashboard View -->
<div class="stats">
    <div class="stat-card">
        <div class="stat-hdr"><div class="stat-icon primary">📦</div><div class="stat-trend up">↑ 12%</div></div>
        <div class="stat-val" id="totalBookings">0</div><div class="stat-lbl">Total Bookings</div>
    </div>
    <div class="stat-card">
        <div class="stat-hdr"><div class="stat-icon blue">🚛</div><div class="stat-trend up">↑ 8%</div></div>
        <div class="stat-val" id="activeTrucks">0</div><div class="stat-lbl">Active Trucks</div>
    </div>
    <div class="stat-card">
        <div class="stat-hdr"><div class="stat-icon green">💰</div><div class="stat-trend up">↑ 23%</div></div>
        <div class="stat-val" id="totalRevenue">0</div><div class="stat-lbl">Revenue (TZS)</div>
    </div>
    <div class="stat-card">
        <div class="stat-hdr"><div class="stat-icon purple">⭐</div></div>
        <div class="stat-val">4.7</div><div class="stat-lbl">Avg Rating</div>
    </div>
</div>

<div class="chart-row">
    <div class="card">
        <div class="card-hdr"><h3 class="card-title">📈 Revenue Overview</h3></div>
        <div class="chart-box"><canvas id="revenueChart"></canvas></div>
    </div>
    <div class="card">
        <div class="card-hdr"><h3 class="card-title">📊 Booking Status</h3></div>
        <div class="chart-box"><canvas id="statusChart"></canvas></div>
    </div>
</div>

<div class="grid-2">
    <div class="card">
        <div class="card-hdr"><h3 class="card-title">⏰ Recent Activity</h3></div>
        <div class="activity" id="activityList">
            <div class="act-item"><div class="act-icon booking">📦</div><div class="act-content"><div class="act-title">Loading...</div></div></div>
        </div>
    </div>
    <div class="card">
        <div class="card-hdr"><h3 class="card-title">🔔 Quick Actions</h3></div>
        <div class="activity">
            <div class="act-item"><div class="act-icon booking">📋</div><div class="act-content"><div class="act-title">Manage Bookings</div><div class="act-desc">View and assign trucks to bookings</div></div><a href="?page=bookings" class="btn btn-primary btn-sm">Go</a></div>
            <div class="act-item"><div class="act-icon truck">🔍</div><div class="act-content"><div class="act-title">Fleet Management</div><div class="act-desc">Verify trucks and manage fleet</div></div><a href="?page=fleet" class="btn btn-secondary btn-sm">Go</a></div>
            <div class="act-item"><div class="act-icon payment">💸</div><div class="act-content"><div class="act-title">Process Payouts</div><div class="act-desc">Pay drivers for completed trips</div></div><a href="?page=payouts" class="btn btn-secondary btn-sm">Go</a></div>
        </div>
    </div>
</div>
