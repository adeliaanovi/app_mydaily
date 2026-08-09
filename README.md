# MyDaily

MyDaily adalah aplikasi mobile berbasis Flutter untuk mencatat kegiatan dan mood harian. Aplikasi ini membantu pengguna menyimpan aktivitas, melihat riwayat catatan, serta memantau statistik mood mingguan secara sederhana.

## Fitur Utama

* Menambahkan catatan kegiatan harian
* Memilih waktu kegiatan
* Memilih mood menggunakan emoji
* Menampilkan kegiatan hari ini pada halaman Home
* Menampilkan riwayat kegiatan berdasarkan tanggal
* Menghapus catatan kegiatan
* Menampilkan statistik mood mingguan
* Mendukung light mode dan dark mode
* Menyimpan data secara lokal menggunakan Shared Preferences

## Teknologi yang Digunakan

* Flutter
* Dart
* Provider
* Shared Preferences
* Material Design
* Google Fonts

## Halaman Aplikasi

### Home

Menampilkan ringkasan kegiatan hari ini serta tombol navigasi menuju halaman Riwayat, Statistik, dan Tambah Catatan.

### Tambah Catatan

Digunakan untuk memasukkan nama aktivitas, memilih waktu, dan menentukan mood.

### Riwayat

Menampilkan seluruh catatan kegiatan yang dikelompokkan berdasarkan tanggal.

### Statistik

Menampilkan ringkasan dan persentase mood selama tujuh hari terakhir.

## Penyimpanan Data

MyDaily menggunakan `shared_preferences` sebagai penyimpanan lokal. Data akan tetap tersimpan setelah aplikasi ditutup dan dibuka kembali pada perangkat yang sama.

Data tidak tersinkronisasi antarperangkat karena aplikasi belum menggunakan database online atau cloud storage.

## Menjalankan Project

Pastikan Flutter SDK dan Android SDK telah terpasang.

1. Clone repository:

```bash
git clone https://github.com/adeliaanovi/app_mydaily.git
```

2. Masuk ke folder project:

```bash
cd app_mydaily
```

3. Instal seluruh dependency:

```bash
flutter pub get
```

4. Periksa project:

```bash
flutter analyze
```

5. Jalankan aplikasi:

```bash
flutter run
```

## Build APK Release

Untuk membuat APK versi release, jalankan:

```bash
flutter build apk --release
```

File APK akan tersimpan di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Status Project

Project telah berhasil:

* Dijalankan pada HP Android fisik
* Dibuild menjadi APK release
* Menyimpan data secara lokal
* Menjalankan light mode dan dark mode
* Lolos pemeriksaan `flutter analyze` tanpa masalah

## Tentang Project

Project ini dibuat sebagai Pre-Project Mobile Developer menggunakan Flutter dengan tema aplikasi pencatat kegiatan dan mood harian.
