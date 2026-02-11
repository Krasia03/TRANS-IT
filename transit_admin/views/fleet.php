<!-- Fleet View -->
<div class="stats">
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon blue">🚛</div></div><div class="stat-val" id="totalTrucks">0</div><div class="stat-lbl">Total Trucks</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon green">✓</div></div><div class="stat-val" id="verifiedTrucks">0</div><div class="stat-lbl">Verified</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon primary">📍</div></div><div class="stat-val" id="availableTrucks">0</div><div class="stat-lbl">Available Now</div></div>
    <div class="stat-card"><div class="stat-hdr"><div class="stat-icon purple">🔄</div></div><div class="stat-val" id="enrouteTrucks">0</div><div class="stat-lbl">En Route</div></div>
</div>

<div class="filter-bar">
    <div class="tabs" style="background:none;border:none;padding:0;">
        <button class="tab active">All Trucks</button>
        <button class="tab">Pending</button>
        <button class="tab">Available</button>
        <button class="tab">En Route</button>
    </div>
    <div style="margin-left:auto;">
        <button class="btn btn-primary" onclick="openModal('truckModal')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7h14"/></svg>
            Add Truck
        </button>
    </div>
</div>

<div class="card">
    <div class="tbl-wrap">
        <table>
            <thead>
                <tr>
                    <th>Plate Number</th>
                    <th>Owner / Driver</th>
                    <th>Type</th>
                    <th>Capacity</th>
                    <th>Status</th>
                    <th>Availability</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="fleetTable">
                <tr><td colspan="8" style="text-align:center;padding:2rem;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>
