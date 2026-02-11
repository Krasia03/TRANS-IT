<!-- Reports View -->
<div class="grid-3">
    <div class="card" style="cursor:pointer;text-align:center;padding:2.5rem 1.5rem;" onclick="generateReport('operational')">
        <div style="width:70px;height:70px;background:rgba(25,41,124,0.1);border-radius:16px;display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;font-size:2rem;">📊</div>
        <h3 style="margin-bottom:0.5rem;">Operational Report</h3>
        <p style="color:var(--text-muted);font-size:0.85rem;">Trips, delivery times, performance metrics</p>
    </div>
    <div class="card" style="cursor:pointer;text-align:center;padding:2.5rem 1.5rem;" onclick="generateReport('financial')">
        <div style="width:70px;height:70px;background:rgba(16,185,129,0.1);border-radius:16px;display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;font-size:2rem;">💰</div>
        <h3 style="margin-bottom:0.5rem;">Financial Report</h3>
        <p style="color:var(--text-muted);font-size:0.85rem;">Revenue, commissions, payouts summary</p>
    </div>
    <div class="card" style="cursor:pointer;text-align:center;padding:2.5rem 1.5rem;" onclick="generateReport('fleet')">
        <div style="width:70px;height:70px;background:rgba(139,92,246,0.1);border-radius:16px;display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;font-size:2rem;">🚛</div>
        <h3 style="margin-bottom:0.5rem;">Fleet Report</h3>
        <p style="color:var(--text-muted);font-size:0.85rem;">Utilization, ratings, compliance status</p>
    </div>
</div>
