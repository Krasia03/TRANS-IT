<!-- Payouts View -->
<div class="stats">
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon green">💸</div></div><div class="stat-val" id="totalPaidOut">0</div><div class="stat-lbl">Total Paid Out (TZS)</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon primary">⏳</div></div><div class="stat-val" id="pendingPayouts">0</div><div class="stat-lbl">Pending Payouts</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon blue">👥</div></div><div class="stat-val">89</div><div class="stat-lbl">Active Drivers</div></div>
</div>

<div class="card">
    <div class="card-hdr">
        <h3 class="card-title">💸 Pending Payouts</h3>
        <button class="btn btn-primary" onclick="processAllPayouts()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><path d="M22 4L12 14.01l-3-3"/></svg>
            Process All
        </button>
    </div>
    <div class="tbl-wrap">
        <table>
            <thead>
                <tr>
                    <th>Driver</th>
                    <th>Booking</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="payoutsTable">
                <tr><td colspan="6" style="text-align:center;padding:2rem;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>
