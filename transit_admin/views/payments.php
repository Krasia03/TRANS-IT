<!-- Payments View -->
<div class="stats">
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon green">💰</div></div><div class="stat-val" id="totalCollected">0</div><div class="stat-lbl">Total Collected (TZS)</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon blue">🔒</div></div><div class="stat-val" id="inEscrow">0</div><div class="stat-lbl">In Escrow (TZS)</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon primary">📊</div></div><div class="stat-val">15%</div><div class="stat-lbl">Platform Commission</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon purple">📱</div></div><div class="stat-val">78%</div><div class="stat-lbl">Mobile Money</div></div>
</div>

<div class="card">
    <div class="card-hdr"><h3 class="card-title">💳 Recent Transactions</h3>
        <button class="btn btn-secondary btn-sm">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4m4-5l5 5 5-5m-5 5V3"/></svg>
            Export CSV
        </button>
    </div>
    <div class="tbl-wrap">
        <table>
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Booking</th>
                    <th>Customer</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody id="paymentsTable">
                <tr><td colspan="7" style="text-align:center;padding:2rem;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>
