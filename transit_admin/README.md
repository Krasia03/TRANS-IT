# TRANSIT Admin Dashboard - PHP MVC

A comprehensive admin dashboard for managing a transit/logistics business built with PHP MVC architecture and MySQL database.

## Features

- **Dashboard**: Overview with stats, charts, and recent activity
- **Bookings**: Create, view, assign trucks, update status (CRUD)
- **Fleet Management**: Add trucks, verify, track availability (CRUD)
- **Payments**: View all transactions
- **Payouts**: Process driver payouts (single or batch)
- **Rate Cards**: Configure pricing for different truck/cargo types (CRUD)
- **User Management**: Manage cargo owners, drivers, admins (CRUD)
- **Reports**: Generate operational, financial, and fleet reports

## Requirements

- PHP 7.4+ with PDO MySQL extension
- MySQL 5.7+ or MariaDB 10.3+
- Apache/Nginx web server

## Installation

### 1. Database Setup

```bash
# Login to MySQL
mysql -u root -p

# Run the schema file
source /path/to/transit_admin/config/schema.sql
```

Or import directly:
```bash
mysql -u root -p < config/schema.sql
```

### 2. Configure Database Connection

Edit `config/database.php` and update credentials:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'transit_admin');
define('DB_USER', 'your_username');
define('DB_PASS', 'your_password');
```

### 3. Web Server Configuration

#### Apache (.htaccess)

Create `.htaccess` in project root:
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^api/(.*)$ api.php/$1 [QSA,L]
```

#### Nginx

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/transit_admin;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location /api.php {
        try_files $uri $uri/ /api.php?$query_string;
    }
}
```

### 4. File Permissions

```bash
chmod -R 755 /path/to/transit_admin
chmod -R 777 /path/to/transit_admin/public  # If uploads needed
```

## Project Structure

```
transit_admin/
├── config/
│   ├── database.php      # Database connection
│   └── schema.sql        # MySQL schema + sample data
├── controllers/
│   ├── BaseController.php
│   ├── BookingController.php
│   ├── DashboardController.php
│   ├── PayoutController.php
│   ├── RateCardController.php
│   ├── TransactionController.php
│   ├── TruckController.php
│   └── UserController.php
├── models/
│   ├── BaseModel.php
│   ├── Activity.php
│   ├── Booking.php
│   ├── Payout.php
│   ├── RateCard.php
│   ├── Transaction.php
│   ├── Truck.php
│   └── User.php
├── views/
│   ├── partials/
│   │   └── modals.php
│   ├── bookings.php
│   ├── dashboard.php
│   ├── fleet.php
│   ├── payments.php
│   ├── payouts.php
│   ├── rates.php
│   ├── reports.php
│   ├── tracking.php
│   └── users.php
├── public/
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── app.js
├── api.php               # REST API router
├── index.php             # Main entry point
└── README.md
```

## API Endpoints

### Dashboard
- `GET /api.php/dashboard` - Get dashboard stats

### Users
- `GET /api.php/users` - List all users
- `GET /api.php/users/{id}` - Get user by ID
- `POST /api.php/users` - Create user
- `PUT /api.php/users/{id}` - Update user
- `DELETE /api.php/users/{id}` - Delete user

### Bookings
- `GET /api.php/bookings` - List all bookings
- `GET /api.php/bookings/{id}` - Get booking by ID
- `POST /api.php/bookings` - Create booking
- `PUT /api.php/bookings/{id}` - Update booking
- `POST /api.php/bookings/{id}/assign` - Assign truck
- `DELETE /api.php/bookings/{id}` - Delete booking

### Trucks
- `GET /api.php/trucks` - List all trucks
- `GET /api.php/trucks/available` - List available trucks
- `POST /api.php/trucks` - Add truck
- `PUT /api.php/trucks/{id}` - Update truck
- `POST /api.php/trucks/{id}/verify` - Verify truck
- `DELETE /api.php/trucks/{id}` - Delete truck

### Transactions
- `GET /api.php/transactions` - List transactions
- `POST /api.php/transactions` - Record transaction

### Payouts
- `GET /api.php/payouts` - List pending payouts
- `POST /api.php/payouts/{id}/process` - Process single payout
- `POST /api.php/payouts/process-all` - Process all payouts

### Rate Cards
- `GET /api.php/rates` - List rate cards
- `POST /api.php/rates` - Create rate card
- `PUT /api.php/rates/{id}` - Update rate card
- `DELETE /api.php/rates/{id}` - Delete rate card
- `POST /api.php/rates/calculate` - Calculate rate

## Default Login

The schema includes sample data with the following admin:
- **Name**: John Mwamba
- **Email**: john@transit.co.tz
- **Role**: Super Admin

## Customization

### Adding New Pages

1. Create view file in `views/`
2. Add navigation link in `index.php`
3. Add page to `$validPages` array

### Adding New API Endpoints

1. Create controller in `controllers/`
2. Create model in `models/`
3. Add routes in `api.php`

## License

MIT License
