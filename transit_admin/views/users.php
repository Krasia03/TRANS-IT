<!-- Users View -->
<div class="tabs">
    <button class="tab active">All Users</button>
    <button class="tab">Cargo Owners</button>
    <button class="tab">Drivers</button>
    <button class="tab">Admins</button>
</div>

<div class="card">
    <div class="card-hdr">
        <h3 class="card-title">👥 User Management</h3>
        <button class="btn btn-primary" onclick="openModal('userModal')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><path d="M12 5v14m-7-7h14"/></svg>
            Add User
        </button>
    </div>
    <div class="tbl-wrap">
        <table>
            <thead>
                <tr>
                    <th>User</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Joined</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="usersTable">
                <tr><td colspan="6" style="text-align:center;padding:2rem;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>
