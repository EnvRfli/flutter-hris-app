# Struktur Folder dan File HRIS App

## 📁 Core
**Path**: `lib/core/`

### Theme
- `app_colors.dart` - Definisi semua warna yang digunakan dalam aplikasi (kuning, biru, merah, hijau)
- `app_text_styles.dart` - Text styles yang konsisten (h1-h5, body, button, caption)
- `app_theme.dart` - Material Theme configuration dengan Material 3

### Widgets (Reusable Components)
- `primary_button.dart` - Button utama dengan loading state dan icon support
- `app_card.dart` - Card component dengan border dan shadow
- `status_badge.dart` - Badge untuk menampilkan status (success, warning, error, info)
- `loading_view.dart` - Loading indicator dengan optional message

---

## 📊 Data Layer
**Path**: `lib/data/`

### Models
- `user.dart` - Model untuk data user (id, name, email, position, department)
- `clock_record.dart` - Model untuk data clock in/out record

### Repositories (Fake)
- `auth_repository.dart` - Fake authentication repository
  - Login dengan email/password
  - Logout
  - Get current user
  
- `clock_repository.dart` - Fake clock repository
  - Get today's record
  - Get history
  - Clock in
  - Clock out
  - Dummy data untuk testing

---

## 🔄 State Management
**Path**: `lib/state/providers/`

### Providers (using Provider package)
- `auth_provider.dart` - Mengelola state authentication
  - Login/logout
  - Current user
  - Auth status (authenticated/unauthenticated)
  
- `clock_provider.dart` - Mengelola state clock in/out
  - Today's record
  - History
  - Clock in/out actions

---

## 🛣️ Routing
**Path**: `lib/routes/`

- `app_router.dart` - GoRouter configuration
  - Route definitions
  - Auth guard
  - Shell route untuk bottom navigation
  - Named routes

---

## 🎯 Features
**Path**: `lib/features/`

### Auth Feature
`features/auth/pages/`
- `login_page.dart` - Halaman login dengan form validation

### Main Feature
`features/main/pages/`
- `main_shell.dart` - Bottom navigation shell dengan 4 tabs

### Home Feature
`features/home/pages/`
- `home_page.dart` - Dashboard utama
  - Welcome card
  - Today's status
  - Quick actions

### Clock Feature
`features/clock/pages/`
- `clock_page.dart` - Halaman clock in/out
  - Status hari ini
  - Clock in/out buttons
  - Work duration
  
- `liveness_page.dart` - Placeholder liveness check
  - Simulasi 3 detik
  - Auto process clock in/out
  - Success/error feedback

### History Feature
`features/history/pages/`
- `history_page.dart` - Riwayat kehadiran
  - List semua clock records
  - Detail per record
  - Work duration

### Profile Feature
`features/profile/pages/`
- `profile_page.dart` - Profil user
  - User information
  - Settings menu
  - About section
  - Logout

---

## 🔧 Entry Point

- `main.dart` - Entry point aplikasi
  - MultiProvider setup
  - GoRouter initialization
  - Theme configuration

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2        # State management
  go_router: ^14.6.2      # Routing
  intl: ^0.19.0          # Formatting (date, time)
  cupertino_icons: ^1.0.8
```

---

## 🎨 Design System

### Colors
- **Primary**: Blue (#2196F3)
- **Secondary**: Yellow (#FFC107)
- **Error**: Red (#E53935)
- **Success**: Green (#4CAF50)
- **Background**: Light Grey (#F5F5F5)

### Typography
- **Headlines**: h1 (32px) - h5 (18px)
- **Body**: Large (16px), Medium (14px), Small (12px)
- **Button**: 16px, semi-bold
- **Caption**: 12px

### Components
- **Border Radius**: 12-16px (cards), 8px (badges)
- **Spacing**: Multiples of 4px (4, 8, 12, 16, 20, 24)
- **Elevation**: Minimal (Material 3 style)

---

## 🚦 Navigation Flow

```
Login Page
    ↓ (after login)
Main Shell (Bottom Navigation)
    ├── Home Page
    ├── Clock Page → Liveness Page → Back to Clock
    ├── History Page
    └── Profile Page → Logout → Login Page
```

---

## 📝 State Flow

### Authentication Flow
```
1. User input email/password
2. AuthProvider.login() called
3. AuthRepository validates credentials
4. Update auth state
5. Router redirects to home
```

### Clock In/Out Flow
```
1. User clicks Clock In/Out button
2. Navigate to Liveness Page
3. Simulate liveness check (3s)
4. ClockProvider.clockIn/Out() called
5. ClockRepository updates data
6. Update clock state
7. Navigate back to Clock Page
```

---

## 🔐 Dummy Credentials

```
Email: user@example.com
Password: password123

User Data:
- ID: 1
- Name: John Doe
- Position: Software Engineer
- Department: Engineering
```

---

## ✨ Best Practices Applied

1. **Separation of Concerns**: Data, State, UI dipisahkan
2. **Feature-First Structure**: Code diorganisir per feature
3. **Reusable Components**: Widget yang dapat digunakan kembali
4. **Type Safety**: Strong typing dengan models
5. **State Management**: Provider pattern yang clean
6. **Routing**: Declarative routing dengan GoRouter
7. **Material Design 3**: Modern UI guidelines
8. **Responsive**: Adaptif untuk berbagai ukuran layar
