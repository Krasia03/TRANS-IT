<!-- Assign Truck Modal -->
<div class="modal-bg" id="assignModal">
    <div class="modal">
        <div class="modal-hdr"><h3 class="modal-title">🚛 Assign Truck to Booking</h3><button class="modal-close" onclick="closeModal('assignModal')">✕</button></div>
        <div class="modal-body">
            <div class="form-grp"><label class="form-lbl">Select Available Truck</label><select id="truckSelect" class="form-sel"><option value="">Choose a truck...</option></select></div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Pickup Date</label><input type="date" id="pickupDate" class="form-input"></div>
                <div class="form-grp"><label class="form-lbl">Pickup Time</label><input type="time" id="pickupTime" class="form-input"></div>
            </div>
            <div class="form-grp"><label class="form-lbl">Assignment Notes</label><textarea id="assignNotes" class="form-input" rows="3" placeholder="Add any special instructions..."></textarea></div>
        </div>
        <div class="modal-ftr"><button class="btn btn-secondary" onclick="closeModal('assignModal')">Cancel</button><button class="btn btn-primary" onclick="assignTruck()">Assign Truck</button></div>
    </div>
</div>

<!-- New Booking Modal -->
<div class="modal-bg" id="bookingModal">
    <div class="modal">
        <div class="modal-hdr"><h3 class="modal-title">📦 Create New Booking</h3><button class="modal-close" onclick="closeModal('bookingModal')">✕</button></div>
        <div class="modal-body">
            <div class="form-grp"><label class="form-lbl">Customer ID</label><input type="number" id="newCustomerId" class="form-input" placeholder="Enter customer ID"></div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Origin</label><input type="text" id="newOrigin" class="form-input" placeholder="e.g. Dar es Salaam"></div>
                <div class="form-grp"><label class="form-lbl">Destination</label><input type="text" id="newDestination" class="form-input" placeholder="e.g. Arusha"></div>
            </div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Distance (km)</label><input type="number" id="newDistance" class="form-input" placeholder="635"></div>
                <div class="form-grp"><label class="form-lbl">Weight (kg)</label><input type="number" id="newWeight" class="form-input" placeholder="5000"></div>
            </div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Cargo Type</label><select id="newCargoType" class="form-sel"><option>General</option><option>Perishable</option><option>Fragile</option><option>High Value</option></select></div>
                <div class="form-grp"><label class="form-lbl">Amount (TZS)</label><input type="number" id="newAmount" class="form-input" placeholder="850000"></div>
            </div>
        </div>
        <div class="modal-ftr"><button class="btn btn-secondary" onclick="closeModal('bookingModal')">Cancel</button><button class="btn btn-primary" onclick="createBooking()">Create Booking</button></div>
    </div>
</div>

<!-- New Truck Modal -->
<div class="modal-bg" id="truckModal">
    <div class="modal">
        <div class="modal-hdr"><h3 class="modal-title">🚛 Add New Truck</h3><button class="modal-close" onclick="closeModal('truckModal')">✕</button></div>
        <div class="modal-body">
            <div class="form-grp"><label class="form-lbl">Plate Number</label><input type="text" id="newPlate" class="form-input" placeholder="e.g. T 123 ABC"></div>
            <div class="form-grp"><label class="form-lbl">Owner/Driver ID</label><input type="number" id="newOwnerId" class="form-input" placeholder="Enter driver user ID"></div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Truck Type</label><select id="newTruckType" class="form-sel"><option>Fuso</option><option>Semi Trailer</option><option>Trailer</option><option>Pickup</option></select></div>
                <div class="form-grp"><label class="form-lbl">Capacity (kg)</label><input type="number" id="newCapacity" class="form-input" placeholder="8000"></div>
            </div>
        </div>
        <div class="modal-ftr"><button class="btn btn-secondary" onclick="closeModal('truckModal')">Cancel</button><button class="btn btn-primary" onclick="createTruck()">Add Truck</button></div>
    </div>
</div>

<!-- New Rate Card Modal -->
<div class="modal-bg" id="rateModal">
    <div class="modal">
        <div class="modal-hdr"><h3 class="modal-title">💵 Add Rate Card</h3><button class="modal-close" onclick="closeModal('rateModal')">✕</button></div>
        <div class="modal-body">
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Truck Type</label><select id="newRateTruckType" class="form-sel"><option>Fuso</option><option>Semi Trailer</option><option>Trailer</option><option>Pickup</option></select></div>
                <div class="form-grp"><label class="form-lbl">Cargo Type</label><select id="newRateCargoType" class="form-sel"><option>General</option><option>Perishable</option><option>Fragile</option><option>High Value</option></select></div>
            </div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Base Rate (TZS)</label><input type="number" id="newBaseRate" class="form-input" placeholder="50000"></div>
                <div class="form-grp"><label class="form-lbl">Per KM Rate (TZS)</label><input type="number" id="newPerKmRate" class="form-input" placeholder="1000"></div>
            </div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Per KG Rate (TZS)</label><input type="number" id="newPerKgRate" class="form-input" placeholder="20"></div>
                <div class="form-grp"><label class="form-lbl">Commission (%)</label><input type="number" id="newCommission" class="form-input" placeholder="15" step="0.01"></div>
            </div>
        </div>
        <div class="modal-ftr"><button class="btn btn-secondary" onclick="closeModal('rateModal')">Cancel</button><button class="btn btn-primary" onclick="createRate()">Add Rate Card</button></div>
    </div>
</div>

<!-- New User Modal -->
<div class="modal-bg" id="userModal">
    <div class="modal">
        <div class="modal-hdr"><h3 class="modal-title">👤 Add New User</h3><button class="modal-close" onclick="closeModal('userModal')">✕</button></div>
        <div class="modal-body">
            <div class="form-grp"><label class="form-lbl">Full Name</label><input type="text" id="newUserName" class="form-input" placeholder="e.g. John Mwamba"></div>
            <div class="form-grp"><label class="form-lbl">Email</label><input type="email" id="newUserEmail" class="form-input" placeholder="e.g. john@example.com"></div>
            <div class="form-row">
                <div class="form-grp"><label class="form-lbl">Phone</label><input type="text" id="newUserPhone" class="form-input" placeholder="+255 712 345 678"></div>
                <div class="form-grp"><label class="form-lbl">Role</label><select id="newUserRole" class="form-sel"><option value="cargo_owner">Cargo Owner</option><option value="driver">Driver</option><option value="admin">Admin</option></select></div>
            </div>
            <div class="form-grp"><label class="form-lbl">Password</label><input type="password" id="newUserPassword" class="form-input" placeholder="Enter password"></div>
        </div>
        <div class="modal-ftr"><button class="btn btn-secondary" onclick="closeModal('userModal')">Cancel</button><button class="btn btn-primary" onclick="createUser()">Create User</button></div>
    </div>
</div>
