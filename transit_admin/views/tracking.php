<!-- Tracking View -->
<div class="grid-2">
    <div class="card" style="height:480px;">
        <div class="card-hdr"><h3 class="card-title">🗺️ Live Fleet Map</h3><button class="btn btn-secondary btn-sm">⟳ Refresh</button></div>
        <div class="map-box">
            <div class="map-dots">
                <div class="map-dot" style="top:28%;left:22%;"></div>
                <div class="map-dot" style="top:42%;left:58%;"></div>
                <div class="map-dot" style="top:68%;left:38%;"></div>
                <div class="map-dot" style="top:52%;left:72%;"></div>
                <div class="map-dot" style="top:22%;left:48%;"></div>
            </div>
            <div class="map-label">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="10" r="3"/><path d="M12 2a8 8 0 018 8c0 5.4-8 12-8 12S4 15.4 4 10a8 8 0 018-8z"/></svg>
                <div style="font-weight:600;font-size:1rem;">Tanzania Fleet Overview</div>
                <div style="font-size:0.85rem;margin-top:0.5rem;">Active trucks shown on map</div>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-hdr"><h3 class="card-title">🚛 Active Trips</h3></div>
        <div class="activity" id="activeTrips" style="max-height:400px;">
            <div class="act-item" style="cursor:pointer;border-radius:10px;padding:1rem;background:var(--bg);border:1px solid var(--border);">
                <div class="act-icon booking">🚛</div>
                <div class="act-content">
                    <div class="act-title">Loading active trips...</div>
                </div>
            </div>
        </div>
    </div>
</div>
