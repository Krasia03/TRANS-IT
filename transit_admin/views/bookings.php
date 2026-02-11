<!-- Bookings View -->
<div class="filter-bar">
    <div class="filter-grp"><span class="filter-lbl">Status:</span>
        <select class="filter-sel" onchange="loadBookings(this.value)">
            <option value="">All Status</option>
            <option value="requested">Requested</option>
            <option value="assigned">Assigned</option>
            <option value="en_route">En Route</option>
            <option value="delivered">Delivered</option>
            <option value="completed">Completed</option>
        </select>
    </div>
    <div class="filter-grp"><span class="filter-lbl">Cargo Type:</span>
        <select class="filter-sel">
            <option>All Types</option>
            <option>General</option>
            <option>Perishable</option>
            <option>Fragile</option>
            <option>High Value</option>
        </select>
    </div>
    <div style="margin-left:auto;">
        <button class="btn btn-primary" onclick="openModal('bookingModal')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7h14"/></svg>
            New Booking
        </button>
    </div>
</div>

<div class="card">
    <div class="tbl-wrap">
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer</th>
                    <th>Route</th>
                    <th>Cargo</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="bookingsTable">
                <tr><td colspan="8" style="text-align:center;padding:2rem;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>
