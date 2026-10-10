# Riwayat versi

Sampai versi 4.0 proyek ini bernama "Reduce Memory". Mulai 4.1 namanya ByteSweep.

## 4.1

- Ganti nama menjadi ByteSweep: aplikasi, nama file, perintah Linux
  (`bytesweep`, `bytesweep-server`), dan environment variable (`BYTESWEEP_*`).
- Folder data Windows pindah ke `%LOCALAPPDATA%\ByteSweep`. Riwayat lama tidak
  dibawa; aplikasi mulai belajar lagi dari awal.
- Dokumentasi diringkas.

## 4.0

- Aggressive dan Emergency mem-flush modified list sebelum purge standby, jadi
  halaman "dirty" ikut dilepas.
- Normal, Smooth, dan AI Shield melewati aplikasi yang langsung mengambil lagi
  memorinya setelah dipangkas (jeda 30 menit).
- Scan lebih cepat, log dirotasi alih-alih dihapus.
- Linux diuji di Ubuntu 22.04 dan 24.04 dengan 10 jenis mapping memori.

## 3.0

- Hasil dihitung dari pasangan angka sebelum/sesudah yang benar-benar terukur.
  Yang tidak bisa diukur ditulis `unknown`, bukan dianggap berhasil.
- Proses yang sama tidak dihitung dua kali walau dipangkas di beberapa pass.
- Pengerasan keamanan: validasi cgroup di Linux, pemeriksaan reparse point
  sebelum Delete Temp, dan worker native yang tidak memblokir tampilan.

## 2.9

- Build Windows (x86 dan x64) bisa diulang dari source, dengan manifest berisi
  hash tiap file hasil build.

## 2.8

- Worker native C untuk Windows x64 dan x86, dengan fallback ke engine AutoIt.
- Deteksi rebound: kalau aplikasi langsung mengambil lagi memorinya, dilakukan
  paling banyak satu pass pemulihan, tanpa loop.
- Riwayat efektivitas per aplikasi (tanpa menyimpan path atau PID).

## 2.7

- Pengukuran working set per proses sebelum dan sesudah trim.
- Linux: page-out dikirim per batch dan dijalankan dua kali di mode Aggressive.

## 2.6

- Tiap mode punya profil sendiri. Perlindungan AI/GPU hanya ada di AI Shield.

## 2.5

- Mode AI Shield di Windows dan Linux.

## 2.4

- Opsi startup Windows: satu pass Normal setelah login, lalu hanya berjalan
  lagi saat RAM 95% ke atas, dengan jeda 5 menit.

## 2.3

- Linux Aggressive memakai `process_madvise(MADV_PAGEOUT)`, dengan deteksi
  proses lewat `/proc` tanpa daftar nama aplikasi.

## 2.2

- Satu nomor versi untuk Windows, Linux Desktop, dan Linux Server.
- Rilis otomatis lewat GitHub Actions, lengkap dengan checksum SHA-256.

## 2.0

Versi pertama proyek ini, terinspirasi dari Reduce Memory v1.7 buatan Sordum
Team.

- Lima mode optimasi, build Windows x64 dan x86, dan versi Linux.
- Perlindungan untuk jendela aktif dan aplikasi yang sedang sibuk.
- Opsi hapus file sementara, dengan konfirmasi.
