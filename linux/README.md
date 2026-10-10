# ByteSweep untuk Linux

ByteSweep di Linux meminta kernel memindahkan memori aplikasi yang sedang diam
keluar dari RAM. Aplikasinya tetap hidup dan memuat lagi datanya saat dipakai.

Yang dipakai adalah fitur kernel Linux sendiri:

- `process_madvise(MADV_PAGEOUT)` untuk memori aplikasi yang diam,
- `drop_caches` untuk cache file,
- `memory.reclaim` dari cgroup v2.

Aplikasi dipilih dari perilakunya (besar dan sedang diam), bukan dari daftar
nama. Jadi aplikasi yang baru di-install pun otomatis ikut.

## Install

Desktop (termasuk Linux Mint), dari folder `linux`:

```bash
chmod +x ByteSweep_Linux.sh native/bytesweep-native desktop/Install_Desktop.sh
./desktop/Install_Desktop.sh
```

Lalu buka **ByteSweep** dari menu aplikasi, atau jalankan `bytesweep` di
terminal. Installer hanya membuat tiga file:

```text
~/.local/bin/bytesweep
~/.local/bin/bytesweep-native
~/.local/share/applications/bytesweep.desktop
```

Server atau VPS:

```bash
chmod +x ByteSweep_Linux.sh native/bytesweep-native server/Install_Server.sh
sudo ./server/Install_Server.sh
sudo bytesweep-server smooth
```

Tanpa install juga bisa: `sudo ./ByteSweep_Linux.sh smooth`.

Tidak ada daemon, autostart, cron, atau service yang dibuat.

## Mode

| Mode | Yang dilakukan |
| --- | --- |
| `status` / `check` | Hanya membaca kondisi memori dan dukungan kernel. Tidak mengubah apa pun. |
| `normal` | Hanya aplikasi besar (256 MB ke atas) yang benar-benar diam. |
| `smooth` | Aplikasi diam mulai 128 MB, ditambah melepas cache ringan. |
| `ai-shield` | Aplikasi diam mulai 64 MB, tapi proses AI/GPU dan turunannya dilindungi. |
| `aggressive` | Paling kuat: aplikasi diam mulai 32 MB, cache, dan cgroup reclaim. |

Mode selain `status` butuh `sudo` supaya bisa bekerja penuh. Tanpa `sudo`,
`normal` hanya menjalankan `sync`.

## Yang selalu dilewati

- proses sistem, root, dan kernel thread,
- aplikasi yang sedang aktif atau sedang di depan (foreground),
- terminal, `sudo`, dan ByteSweep sendiri,
- memori yang dikunci (locked) dan mapping khusus kernel.

Di Wayland, deteksi jendela foreground tidak selalu tersedia. Perlindungan
berdasarkan aktivitas CPU tetap berjalan.

## Kebutuhan

- Kernel Linux 5.10 atau lebih baru, Python 3, Bash, `awk`, dan `sync`.
- Swap aktif. Tanpa swap, memori aplikasi tidak punya tempat untuk dipindahkan.
- WSL2 bisa dipakai, tapi pengembalian RAM ke Windows tetap diatur WSL2.
- Git Bash/MSYS bukan Linux dan sengaja ditolak.

## Pengaturan opsional

Diatur lewat environment variable, contohnya:

```bash
sudo BYTESWEEP_RECLAIM_MB=1024 ./ByteSweep_Linux.sh aggressive
sudo BYTESWEEP_AI_PATTERNS='my-ai-worker|model-server' ./ByteSweep_Linux.sh ai-shield
BYTESWEEP_TARGET_PID=1234 ./ByteSweep_Linux.sh aggressive
```

| Variabel | Fungsi |
| --- | --- |
| `BYTESWEEP_RECLAIM_MB` | Target cgroup reclaim dalam MB. |
| `BYTESWEEP_RECLAIM_SWAPPINESS` | `default`, `max`, atau 0-200. |
| `BYTESWEEP_AGGRESSIVE_MIN_RSS_MB` | Batas ukuran minimal aplikasi di mode aggressive. |
| `BYTESWEEP_AI_PATTERNS` | Pola nama proses AI yang dilindungi AI Shield. |
| `BYTESWEEP_ALL_USERS` | Ikutkan semua user, bukan hanya pemanggil. |
| `BYTESWEEP_INCLUDE_SERVICE_USERS` | Ikutkan akun service (UID di bawah 1000). |
| `BYTESWEEP_TARGET_PID` | Batasi ke satu proses saja. |

## Batasan

Tidak ada program yang bisa menjamin jumlah RAM tertentu. Memori yang aktif,
terkunci, atau langsung dipakai lagi tidak akan tetap kosong. Mode `aggressive`
bisa membuat aplikasi terasa lambat sebentar saat dibuka lagi.

Angka "bytes advised" di laporan adalah yang diterima kernel, bukan RAM yang
pasti lepas. Yang jadi patokan adalah perubahan `MemAvailable` dan RSS setelah
operasi.
