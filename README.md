# FIKTI Room — Aplikasi Ketersediaan Ruangan

**Mata Kuliah:** Pengembangan Mobile Apps  
**Dosen:** Mahardika Abdi Prawira Tanjung, M.Kom  
**Instansi:** FIKTI — Universitas Muhammadiyah Sumatera Utara  
**Tahun Akademik:** 2025/2026

---

## Deskripsi

FIKTI Room adalah aplikasi mobile berbasis Flutter yang memungkinkan monitoring ketersediaan ruangan dan status kehadiran dosen di FIKTI UMSU secara real-time. Dirancang dengan antarmuka dark futuristic modern untuk pengalaman pengguna yang optimal.

---

## Fitur Utama

- **Splash Screen** animatif dengan logo dan informasi universitas
- **Pemilihan Peran** antara Relator Kelas dan Mahasiswa
- **Dashboard Real-Time** dengan statistik ruangan (Aktif, Menunggu, Tidak Masuk, Kosong)
- **Tampilan Grid Ruangan** dikelompokkan per lantai (Lantai 6 & 7)
- **Detail Ruangan** lengkap dengan informasi jadwal dan dosen
- **Konfirmasi Kehadiran** khusus Relator Kelas (Dosen Masuk / Tidak Masuk)
- **Toast Notification** real-time saat status diperbarui
- **4 Status Ruangan** dengan indikator warna (Hijau, Kuning, Merah, Abu-abu)

---

## Arsitektur

Proyek ini menggunakan **MVVM (Model–View–ViewModel)** dengan Provider sebagai state management:

```
lib/
├── main.dart                    # Entry point
├── models/
│   └── room_model.dart          # Model: Room, Schedule, Lecturer, RoomStatus
├── providers/
│   ├── auth_provider.dart       # ViewModel: autentikasi & peran pengguna
│   └── room_provider.dart       # ViewModel: state & logika ruangan
├── screens/
│   ├── splash_screen.dart       # View: splash screen animatif
│   ├── role_selection_screen.dart # View: pemilihan peran
│   ├── dashboard_screen.dart    # View: dashboard utama
│   └── room_detail_screen.dart  # View: detail & konfirmasi ruangan
├── widgets/
│   └── room_card.dart           # Widget reusable kartu ruangan
└── theme/
    └── app_theme.dart           # Konfigurasi tema & warna global
```

---

## Data Ruangan

| Lantai | Ruangan |
|--------|---------|
| Lantai 6 | 601, 602, 603, 604 |
| Lantai 7 | 701, 702, 703, 704, 705, 706, 707, 708 |

**Total: 12 ruangan**

---

## Status Ruangan

| Status | Warna | Keterangan |
|--------|-------|------------|
| Dosen Masuk | 🟢 Hijau | Dosen telah hadir |
| Menunggu | 🟡 Kuning | Ada jadwal, belum dikonfirmasi |
| Dosen Tidak Masuk | 🔴 Merah | Dosen tidak hadir |
| Kosong | ⚪ Abu-abu | Tidak ada jadwal |

---

## Cara Menjalankan

### Prasyarat

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code dengan Flutter extension
- Android Emulator atau perangkat fisik Android (API 21+)

### Langkah Instalasi

```bash
# 1. Clone atau ekstrak proyek
cd fikti_room

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator/device
flutter run

# 4. Build APK (release)
flutter build apk --release
```

APK hasil build tersedia di:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Menjalankan di Web (untuk demo)

```bash
flutter run -d chrome
```

---

## Dependencies

| Package | Versi | Fungsi |
|---------|-------|--------|
| `provider` | ^6.1.1 | State management (MVVM) |
| `google_fonts` | ^6.1.0 | Tipografi Space Grotesk |
| `flutter_animate` | ^4.3.0 | Animasi micro-interaction |
| `shared_preferences` | ^2.2.2 | Penyimpanan lokal |
| `cupertino_icons` | ^1.0.6 | Ikon iOS-style |

---

## Desain UI

- **Tema:** Dark mode futuristik
- **Warna Utama:** Electric Blue (#00D4FF) + Cyan gradient
- **Tipografi:** Space Grotesk (Google Fonts)
- **Efek:** Glassmorphism cards, animated glow, smooth transitions
- **Layout:** Grid 2-kolom responsif dengan animasi stagger

---

## Kreativitas & Fitur Tambahan

1. **Animated Splash Screen** dengan grid background, pulse glow, dan loading dots
2. **Animated Room Cards** dengan stagger entry animation saat halaman dibuka
3. **Live Status Bar** di bagian atas setiap card menggunakan warna dinamis
4. **Glow Effect** pada kartu ruangan dengan status aktif
5. **Background Orb Animation** di splash dan role selection
6. **Smooth Page Transitions** dengan fade dan slide
7. **Toast Notification** dengan slide-in/out animation
8. **Role-based Access** — tombol konfirmasi hanya muncul untuk Relator Kelas

---

*Dibuat untuk memenuhi tugas Pengembangan Mobile Apps — FIKTI UMSU TA 2025/2026*
