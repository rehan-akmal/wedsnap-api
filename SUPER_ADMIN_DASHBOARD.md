# Super Admin Dashboard Documentation

## Overview
The Super Admin Dashboard provides comprehensive analytics, user management, gig management, and system monitoring capabilities for the WedSnap platform. Only users with the `superadmin` role can access these endpoints.

## Authentication
All super admin endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Super Admin Login
- **Email**: `admin@admin.com`
- **Password**: `admin`

## API Endpoints

### 1. Dashboard Overview
**GET** `/api/v1/super_admin/dashboard/overview`

Returns a comprehensive overview of the entire platform.

**Response:**
```json
{
  "total_users": 15,
  "total_gigs": 6,
  "total_conversations": 3,
  "total_messages": 7,
  "total_categories": 10,
  "total_packages": 15,
  "total_features": 20,
  "total_faqs": 5,
  "total_availabilities": 30,
  "recent_activity": {
    "recent_users": [...],
    "recent_gigs": [...],
    "recent_conversations": [...]
  },
  "system_health": {
    "database_connected": true,
    "redis_connected": true,
    "storage_available": true,
    "last_backup": "2024-01-01",
    "uptime": "99.9%"
  }
}
```

### 2. User Analytics
**GET** `/api/v1/super_admin/analytics/users`

Provides detailed user analytics and statistics.

**Response:**
```json
{
  "user_stats": {
    "total_users": 15,
    "active_users": 12,
    "new_users_this_month": 8,
    "new_users_this_week": 3,
    "new_users_today": 1
  },
  "user_roles": {
    "regular_users": 12,
    "admins": 1,
    "super_admins": 1
  },
  "user_activity": {
    "users_with_gigs": 6,
    "users_with_conversations": 6,
    "users_with_availabilities": 3
  },
  "top_users": [...],
  "user_growth": [...]
}
```

### 3. Gig Analytics
**GET** `/api/v1/super_admin/analytics/gigs`

Provides detailed gig analytics and statistics.

**Response:**
```json
{
  "gig_stats": {
    "total_gigs": 6,
    "active_gigs": 6,
    "gigs_this_month": 4,
    "gigs_this_week": 2,
    "gigs_today": 1
  },
  "gig_categories": [...],
  "gig_locations": [...],
  "top_gigs": [...],
  "gig_growth": [...]
}
```

### 4. Communication Analytics
**GET** `/api/v1/super_admin/analytics/communications`

Provides communication and messaging analytics.

**Response:**
```json
{
  "conversation_stats": {
    "total_conversations": 3,
    "conversations_this_month": 2,
    "conversations_this_week": 1,
    "conversations_today": 0
  },
  "message_stats": {
    "total_messages": 7,
    "messages_this_month": 5,
    "messages_this_week": 2,
    "messages_today": 0,
    "unread_messages": 2
  },
  "communication_growth": [...]
}
```

### 5. System Analytics
**GET** `/api/v1/super_admin/analytics/system`

Provides system performance and health analytics.

**Response:**
```json
{
  "storage_stats": {
    "total_attachments": 25,
    "total_blobs": 25,
    "storage_size": 1048576
  },
  "performance_stats": {
    "average_response_time": "150ms",
    "requests_per_minute": "100",
    "error_rate": "0.1%"
  },
  "error_stats": {
    "total_errors_today": 0,
    "total_errors_this_week": 0,
    "total_errors_this_month": 0,
    "most_common_errors": []
  },
  "database_stats": {
    "total_tables": 12,
    "total_records": 85,
    "database_size": "50MB"
  }
}
```

### 6. User Management

#### List Users
**GET** `/api/v1/super_admin/users?page=1&per_page=20`

**Response:**
```json
{
  "users": [
    {
      "id": 1,
      "name": "Super Admin",
      "email": "admin@admin.com",
      "role": "superadmin",
      "phone": "+1234567890",
      "location": "System",
      "bio": "System Super Administrator",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z",
      "gigs_count": 0,
      "conversations_count": 0,
      "availabilities_count": 0
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 15
  }
}
```

#### User Details
**GET** `/api/v1/super_admin/users/:id`

**Response:**
```json
{
  "id": 1,
  "name": "Super Admin",
  "email": "admin@admin.com",
  "role": "superadmin",
  "phone": "+1234567890",
  "location": "System",
  "bio": "System Super Administrator",
  "created_at": "2024-01-01T00:00:00.000Z",
  "updated_at": "2024-01-01T00:00:00.000Z",
  "gigs_count": 0,
  "conversations_count": 0,
  "availabilities_count": 0,
  "gigs": [...],
  "conversations": [...],
  "availabilities": [...]
}
```

#### Update User Role
**PUT** `/api/v1/super_admin/users/:id/role`

**Request Body:**
```json
{
  "role": "admin"
}
```

**Response:**
```json
{
  "message": "User role updated successfully",
  "user": {...}
}
```

#### Delete User
**DELETE** `/api/v1/super_admin/users/:id`

**Response:**
```json
{
  "message": "User deleted successfully"
}
```

### 7. Gig Management

#### List Gigs
**GET** `/api/v1/super_admin/gigs?page=1&per_page=20`

**Response:**
```json
{
  "gigs": [
    {
      "id": 1,
      "title": "Professional Wedding Photography Package",
      "description": "Capture your special day with beautiful, timeless photos...",
      "location": "Karachi",
      "phone_number": "03001234567",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z",
      "user": {
        "id": 2,
        "name": "Ali Khan",
        "email": "ali@example.com"
      },
      "packages_count": 3,
      "features_count": 4,
      "faqs_count": 3,
      "categories": [
        {
          "id": 1,
          "name": "Wedding Photography"
        }
      ]
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 6
  }
}
```

#### Gig Details
**GET** `/api/v1/super_admin/gigs/:id`

**Response:**
```json
{
  "id": 1,
  "title": "Professional Wedding Photography Package",
  "description": "Capture your special day with beautiful, timeless photos...",
  "location": "Karachi",
  "phone_number": "03001234567",
  "created_at": "2024-01-01T00:00:00.000Z",
  "updated_at": "2024-01-01T00:00:00.000Z",
  "user": {
    "id": 2,
    "name": "Ali Khan",
    "email": "ali@example.com"
  },
  "packages_count": 3,
  "features_count": 4,
  "faqs_count": 3,
  "categories": [...],
  "packages": [...],
  "features": [...],
  "faqs": [...]
}
```

#### Delete Gig
**DELETE** `/api/v1/super_admin/gigs/:id`

**Response:**
```json
{
  "message": "Gig deleted successfully"
}
```

### 8. Category Management

#### List Categories
**GET** `/api/v1/super_admin/categories`

**Response:**
```json
{
  "categories": [
    {
      "id": 1,
      "name": "Wedding Photography",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z",
      "gigs_count": 2
    }
  ]
}
```

#### Create Category
**POST** `/api/v1/super_admin/categories`

**Request Body:**
```json
{
  "category": {
    "name": "New Category"
  }
}
```

**Response:**
```json
{
  "message": "Category created successfully",
  "category": {...}
}
```

#### Update Category
**PUT** `/api/v1/super_admin/categories/:id`

**Request Body:**
```json
{
  "category": {
    "name": "Updated Category Name"
  }
}
```

**Response:**
```json
{
  "message": "Category updated successfully",
  "category": {...}
}
```

#### Delete Category
**DELETE** `/api/v1/super_admin/categories/:id`

**Response:**
```json
{
  "message": "Category deleted successfully"
}
```

### 9. System Settings
**GET** `/api/v1/super_admin/system/settings`

**Response:**
```json
{
  "app_name": "WedSnap",
  "version": "1.0.0",
  "environment": "development",
  "database": "wedsnap_development",
  "redis_connected": true,
  "storage": "local"
}
```

## Features Included

### Analytics & Reporting
- **User Analytics**: User growth, role distribution, activity metrics
- **Gig Analytics**: Gig creation trends, category distribution, location analysis
- **Communication Analytics**: Conversation and message statistics
- **System Analytics**: Performance metrics, storage usage, error tracking

### User Management
- **User Listing**: Paginated list of all users with filtering
- **User Details**: Comprehensive user information including associated data
- **Role Management**: Update user roles (user, admin, superadmin)
- **User Deletion**: Remove users from the system

### Gig Management
- **Gig Listing**: Paginated list of all gigs with detailed information
- **Gig Details**: Complete gig information including packages, features, and FAQs
- **Gig Deletion**: Remove gigs from the system

### Category Management
- **Category Listing**: View all categories with gig counts
- **Category CRUD**: Create, update, and delete categories
- **Category Analytics**: See which categories are most popular

### System Monitoring
- **System Health**: Database connectivity, Redis status, storage availability
- **Performance Metrics**: Response times, request rates, error rates
- **Storage Analytics**: File attachments, storage usage
- **Database Statistics**: Table counts, record counts, database size

## Security Features
- **Role-based Access Control**: Only superadmin users can access these endpoints
- **Authentication Required**: All endpoints require valid JWT authentication
- **Input Validation**: All inputs are validated and sanitized
- **Error Handling**: Comprehensive error handling with appropriate HTTP status codes

## Usage Examples

### Getting Dashboard Overview
```bash
curl -X GET "http://localhost:3000/api/v1/super_admin/dashboard/overview" \
  -H "Authorization: Bearer <your_jwt_token>"
```

### Updating User Role
```bash
curl -X PUT "http://localhost:3000/api/v1/super_admin/users/2/role" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{"role": "admin"}'
```

### Creating a New Category
```bash
curl -X POST "http://localhost:3000/api/v1/super_admin/categories" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{"category": {"name": "Wedding Transportation"}}'
```

## Error Responses

### Unauthorized Access
```json
{
  "error": "Access denied. Super admin privileges required."
}
```
**Status Code**: 403 Forbidden

### User Not Found
```json
{
  "error": "User not found"
}
```
**Status Code**: 404 Not Found

### Validation Errors
```json
{
  "errors": {
    "name": ["can't be blank"]
  }
}
```
**Status Code**: 422 Unprocessable Entity

## Setup Instructions

1. **Run Database Migrations**:
   ```bash
   rails db:migrate
   ```

2. **Seed the Database**:
   ```bash
   rails db:seed
   ```

3. **Login as Super Admin**:
   - Email: `admin@admin.com`
   - Password: `admin`

4. **Access Super Admin Endpoints**:
   Use the JWT token from login to access all super admin endpoints.

## Notes
- All timestamps are in ISO 8601 format
- Pagination is handled using Kaminari gem
- File uploads are handled through Active Storage
- Redis is used for caching and session management
- All endpoints return JSON responses
- Error handling follows REST API best practices 