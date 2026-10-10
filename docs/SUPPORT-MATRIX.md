# Platform yang sudah diuji

Tabel ini memisahkan yang sudah diuji otomatis di CI dari yang belum. Perilaku
di distro atau aplikasi lain bisa berbeda, jadi hasil tetap harus diukur.

| Platform | Sudah diuji | Belum diuji |
| --- | --- | --- |
| Windows x64 dan x86 | Build dari source, self-test, protokol worker, trim nyata ke proses uji, pemulihan rebound, engine Aggressive penuh | Variasi UAC dan izin di mesin nyata |
| Linux desktop | Ubuntu 22.04 dan 24.04: sintaks Bash, unit test helper, page-out nyata, semua mode, installer desktop, 10 jenis mapping memori | Distro lain, variasi swap dan namespace |
| Linux server / VPS | Installer server dan menu di Ubuntu 22.04 dan 24.04 | Akun service dan cgroup yang didelegasikan di server nyata |
| Git Bash / MSYS | Tidak didukung, karena bukan kernel Linux | |

## Catatan

- Mode Aggressive dan Emergency butuh Administrator/root dan bisa membuat
  aplikasi memuat ulang datanya.
- Delete Temp adalah penghapusan file permanen dan bukan pengganti antivirus.
- Penurunan working set/RSS dan kenaikan `MemAvailable` adalah dua angka yang
  berbeda. Hanya pasangan sebelum/sesudah yang valid yang disebut terukur.
