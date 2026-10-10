# ByteSweep

Melegakan RAM di Windows dan Linux tanpa menutup aplikasi.

[![Verify builds](https://github.com/fel-gg/bytesweep/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/fel-gg/bytesweep/actions/workflows/verify.yml)
[![Release](https://img.shields.io/github/v/release/fel-gg/bytesweep?label=release)](https://github.com/fel-gg/bytesweep/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Aplikasi yang berjalan di background sering menahan memori yang sedang tidak
dipakainya. ByteSweep meminta sistem operasi mengambil kembali memori itu, lalu
menampilkan angka sebelum dan sesudahnya. Tidak ada aplikasi yang ditutup atau
dimatikan. Aplikasi memuat lagi datanya sendiri saat kamu membukanya.

ByteSweep tidak menjanjikan angka tertentu. Hasilnya tergantung aplikasi yang
sedang berjalan, dan yang ditampilkan hanya angka yang benar-benar terukur.

## Cara pakai

### Windows

1. Download ZIP Windows dari [Releases](https://github.com/fel-gg/bytesweep/releases/latest).
2. Ekstrak, dan biarkan semua file tetap di satu folder.
3. Jalankan `ByteSweep_x64.exe` (64-bit) atau `ByteSweep.exe` (32-bit).
4. Pilih mode, lalu klik **Optimize**.

Izin Administrator hanya diminta kalau mode yang dipilih membutuhkannya.

### Linux desktop

```bash
cd linux
chmod +x ByteSweep_Linux.sh native/bytesweep-native desktop/Install_Desktop.sh
./desktop/Install_Desktop.sh
```

Setelah itu buka **ByteSweep** dari menu aplikasi.

### Linux server / VPS

```bash
cd linux
chmod +x ByteSweep_Linux.sh native/bytesweep-native server/Install_Server.sh
sudo ./server/Install_Server.sh
sudo bytesweep-server smooth
```

Butuh kernel 5.10+, Python 3, dan Bash. Penjelasan lengkap ada di
[`linux/README.md`](linux/README.md).

## Mode

| Mode | Kapan dipakai | Admin |
| --- | --- | :---: |
| **Normal Optimize** | Pemakaian harian. Hanya menyentuh aplikasi background besar yang sedang diam. | tidak |
| **AI Shield** | Saat menjalankan AI/LLM lokal. Proses AI dan GPU dilindungi. | tidak |
| **Aggressive Smooth** | Lebih kuat dari Normal, tapi tetap berusaha tidak bikin lag. | ya |
| **Aggressive Release** | RAM sudah sesak. Melepas juga cache sistem. | ya |
| **Aggressive + Delete Temp** | Seperti Aggressive, lalu menawarkan hapus file sementara. | ya |
| **Emergency Release** | Sistem hampir macet. Jendela yang sedang aktif juga ikut dipangkas. | ya |

Di Linux modenya `normal`, `smooth`, `ai-shield`, `aggressive`, dan `status`
(hanya membaca, tidak mengubah apa pun).

## Yang perlu kamu tahu

- **Tidak ada proses yang dimatikan.** Jendela yang sedang kamu pakai, aplikasi
  yang sedang sibuk, dan proses inti sistem dilewati (kecuali di mode Emergency).
- **Mode yang kuat bisa terasa.** Aplikasi yang memorinya dilepas perlu memuat
  ulang datanya, jadi bisa sedikit lambat saat pertama dibuka lagi.
- **Delete Temp bersifat permanen.** Aplikasi selalu minta konfirmasi dulu, dan
  file yang sedang dipakai dilewati.
- **Tidak ada yang berjalan diam-diam.** Fitur startup bersifat opsional. Data
  yang disimpan hanya riwayat kecil di `%LOCALAPPDATA%\ByteSweep` dan satu file
  log di folder aplikasi.

## Peringatan antivirus

Beberapa antivirus menandai file `.exe` ini. Itu false positive: program ini
di-compile dengan AutoIt, belum ditandatangani, dan memakai API memori Windows
yang memang sering dicurigai heuristik antivirus.

Kalau ragu, kamu bisa scan sendiri di [VirusTotal](https://www.virustotal.com)
atau build sendiri dari source di repo ini.

## Build dari source

Butuh AutoIt 3.3.18.0 (portable) dan Zig 0.16.0.

```powershell
.\windows\build.ps1 `
  -AutoItRoot C:\toolchains\AutoIt3 `
  -ZigPath C:\toolchains\zig\zig.exe `
  -OutputDirectory C:\temp\ByteSweep-build
```

Tes:

```bash
python -m unittest discover -s tests/contracts -p "test_*.py"
python -m unittest discover -s tests/benchmark -p "test_*.py"
python tests/linux/test_native_unit.py
```

Setiap push ke `main` di-build dan dites otomatis di Windows dan Ubuntu
22.04/24.04.

## Isi repo

```
src/       Source utama (AutoIt): tampilan dan engine Windows
windows/   Script build dan source worker C (native/)
linux/     Launcher Bash, helper Python, installer desktop dan server
tests/     Tes Windows, Linux, dan benchmark
docs/      Riwayat versi, platform yang diuji, protokol worker
```

## Kredit dan lisensi

Terinspirasi dari **Reduce Memory v1.7** buatan Sordum Team. ByteSweep bukan
produk Sordum dan tidak berafiliasi dengan mereka. Sebelum versi 4.1, proyek ini
masih memakai nama lama.

Kode di repo ini dirilis dengan [MIT License](LICENSE).
