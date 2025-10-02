# HRIS App - Human Resource Information System

Aplikasi HRIS (Human Resource Information System) sederhana yang dibangun dengan Flutter. Aplikasi ini menyediakan fitur-fitur dasar untuk manajemen kehadiran karyawan dengan antarmuka yang modern dan minimalis.

## 🎨 Fitur Utama

### 1. **Authentication**
- Login dengan email dan password
- Logout dengan konfirmasi
- Dummy credentials:
  - Email: `user@example.com`
  - Password: `password123`

### 2. **Home Dashboard**
- Welcome card dengan informasi user
- Status kehadiran hari ini (Clock In/Out time, work duration)
- Quick actions untuk navigasi cepat

### 3. **Clock In/Out**
- Tampilan status kehadiran hari ini
- Tombol Clock In/Out dengan validasi
- Liveness check placeholder (simulasi 3 detik)
- Auto update state setelah clock in/out

### 4. **History**
- Daftar riwayat kehadiran
- Detail clock in/out time dan lokasi
- Total work duration per hari
- Status badge (Completed/Pending)

### 5. **Profile**
- Informasi user (nama, email, posisi, department)
- Menu settings (placeholder)
- About section (versi app)
- Tombol logout

## 🏗️ Struktur Project

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Definisi warna tema
│   │   ├── app_text_styles.dart  # Text styles
│   │   └── app_theme.dart        # Material Theme
│   └── widgets/
│       ├── app_card.dart         # Reusable card widget
│       ├── primary_button.dart   # Button widget
│       ├── status_badge.dart     # Badge untuk status
│       └── loading_view.dart     # Loading indicator
├── data/
│   ├── models/
│   │   ├── user.dart            # User model
│   │   └── clock_record.dart    # Clock record model
│   └── repos/
│       ├── auth_repository.dart  # Fake auth repository
│       └── clock_repository.dart # Fake clock repository
├── state/
│   └── providers/
│       ├── auth_provider.dart    # Auth state management
│       └── clock_provider.dart   # Clock state management
├── routes/
│   └── app_router.dart          # GoRouter configuration
├── features/
│   ├── auth/
│   │   └── pages/
│   │       └── login_page.dart
│   ├── main/
│   │   └── pages/
│   │       └── main_shell.dart  # Bottom navigation shell
│   ├── home/
│   │   └── pages/
│   │       └── home_page.dart
│   ├── clock/
│   │   └── pages/
│   │       ├── clock_page.dart
│   │       └── liveness_page.dart
│   ├── history/
│   │   └── pages/
│   │       └── history_page.dart
│   └── profile/
│       └── pages/
│           └── profile_page.dart
└── main.dart                    # Entry point
```

## 🎨 Tema Warna

Aplikasi menggunakan palet warna modern minimalis:

- **Kuning** (`#FFC107`): Secondary color, warnings
- **Biru** (`#2196F3`): Primary color, info
- **Merah** (`#E53935`): Error, clock out
- **Hijau** (`#4CAF50`): Success, clock in

## 📦 Dependencies

- **flutter**: Framework UI
- **provider**: State management
- **go_router**: Routing & navigation
- **intl**: Internationalization & formatting

## 🚀 Cara Menjalankan

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run aplikasi**
   ```bash
   flutter run
   ```

3. **Login dengan credentials dummy**
   - Email: `user@example.com`
   - Password: `password123`

## 📱 Navigasi

Aplikasi menggunakan **Bottom Navigation** dengan 4 tab:
1. **Home** - Dashboard utama
2. **Clock** - Clock In/Out
3. **History** - Riwayat kehadiran
4. **Profile** - Profil user & settings

## 🔧 State Management

Menggunakan **Provider** dengan pattern:
- `AuthProvider`: Mengelola state authentication
- `ClockProvider`: Mengelola state clock in/out dan history

## 🎯 Routing

Menggunakan **GoRouter** dengan:
- Redirect guard untuk authentication
- Shell route untuk bottom navigation
- Named routes untuk navigasi yang mudah

## 📝 Catatan

- Semua data masih **dummy** (fake repository)
- Liveness check adalah **placeholder** simulasi 3 detik
- Backend belum terintegrasi
- Tombol-tombol di profile masih placeholder

## 🔄 Next Steps (Future Development)

1. Integrasi dengan API backend
2. Implementasi face recognition untuk liveness
3. Fitur leave management
4. Payroll integration
5. Push notifications
6. Offline mode dengan local storage
7. Multi-language support

## 👨‍💻 Developer Notes

Aplikasi ini dibangun dengan:
- Clean Architecture principles
- Feature-first folder structure
- Reusable components
- Material Design 3
- Responsive design

---

**Version**: 1.0.0  
**Build**: 100  
**Environment**: Development  
**Made with** ❤️ **by Flutter**

