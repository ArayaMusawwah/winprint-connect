# WinPrint Connect

**WinPrint Connect** adalah aplikasi GUI native Qt6 (PySide6) untuk Linux (terintegrasi penuh dengan CUPS dan KDE Plasma) yang mempermudah pencarian, penemuan, dan penyambungan printer yang dibagikan oleh PC Windows (Windows 10/11) di jaringan lokal melalui protokol SMB/Samba.

Antarmuka dirancang dengan standar kenyamanan visual (*pixel-perfect*, simetris, OCD-friendly) dan mematuhi pedoman aksesibilitas **WCAG AA**.

---

## Fitur Utama

- **Pencarian Host Otomatis (Subnet Scan LAN):** Memindai subnet lokal (`/24`) secara cepat (< 1 detik) melalui koneksi soket non-blocking port 445 untuk menemukan PC Windows aktif.
- **Riwayat Host Terintegrasi:** Menyimpan riwayat IP atau hostname Windows yang pernah digunakan ke `~/.config/winprint-connect/history.json`.
- **Dukungan Autentikasi Windows:** Opsi memasukkan username dan password Windows jika PC target membatasi akses printer.
- **Deteksi Driver Otomatis dari Katalog CUPS:**
  - Saat aplikasi dibuka, seluruh PPD yang terpasang dibaca sekali lewat `lpinfo -m` (±8 detik, di latar belakang).
  - Nama share dicocokkan dengan merek + kode model (mis. `Brother HL-1201` → brlaser `br1200.ppd`,
    `HP LaserJet Professional P1102` → `hpcups`, `Samsung SCX-3200` → `splix`); hasil teratas ditandai ★.
  - Bila tidak ada PPD yang cocok, aplikasi **tidak** diam-diam memakai driver generic: kartu menampilkan
    peringatan dan tombol *Hubungkan* meminta konfirmasi lebih dulu.
  - Peringatan khusus untuk PPD yang butuh plugin proprietary (`hp-plugin -i`) dan untuk printer
    host-based (GDI) yang tidak akan mencetak lewat PostScript generic.
  - Fallback manual tetap tersedia: Epson Dot Matrix 9/24-pin, Generic PostScript, Generic PCL, Raw Passthrough.
***

- **Manajemen Antrean CUPS Sekali Klik:**
  - Daftarkan printer ke CUPS tanpa perlu mengetahui path URI SMB manual.
  - Cetak halaman pengujian (*Print Test Page*).
  - Tentukan printer utama (*Set as Default*).
  - Hapus antrean printer jika sudah tidak digunakan.
  - Tautan langsung ke antarmuka web CUPS (`http://localhost:631/printers/`) dan pengaturan printer KDE.
- **Integrasi PaperCut:** mendeteksi PaperCut Mobility Print (port 9163/9164) dan mendaftarkan
  semua antreannya ke CUPS sebagai *IPP Everywhere* driverless (tanpa driver PPD), mendeteksi
  server PaperCut NG/MF (share `PCClient`, console 9191/9192), dan menyediakan tombol
  **Akun PaperCut** untuk membuka halaman kuota pengguna.

---

## Kebutuhan Sistem

- **Python:** 3.10+
- **Pustaka Python:** `PySide6`
- **Sistem Service:** `cups`
- **Perangkat Lunak Pendukung:** `smbclient` (Samba client tools)

Di Arch Linux / CachyOS:
```bash
sudo pacman -S python-pyside6 smbclient cups
```

### Paket driver (opsional, sesuai printer)

Deteksi driver membaca katalog CUPS yang sudah terpasang. Tanpa paket tambahan, printer
vendor tertentu hanya akan mendapat driver generic dan hasil cetaknya tidak akan keluar.

| Printer | Paket | Sumber |
|---|---|---|
| Brother HL/DCP laser (mis. HL-1201) | `brlaser` | AUR |
| Samsung laser (mis. SCX-3200) | `splix` | AUR |
| HP LaserJet (mis. P1102) | `hplip` + plugin via `sudo hp-plugin -i` | repo + plugin manual |
| Epson inkjet L-series | `epson-inkjet-printer-escpr2` | AUR |
| Epson L3210 / L3200 / L1210 | `epson-inkjet-printer-202101w` | AUR |

Setelah memasang paket, jalankan ulang aplikasi agar katalog `lpinfo -m` dimuat lagi.

---

## Cara Instalasi

Jalankan skrip instalasi untuk memasang binary ke `~/.local/bin` dan mendaftarkan launcher desktop ke menu aplikasi:

```bash
git clone https://github.com/ArayaMusawwah/winprint-connect.git
cd winprint-connect
./install.sh
```

---

## Menjalankan Aplikasi

- Dari **Terminal**:
  ```bash
  winprint-connect
  ```
- Dari **Menu Aplikasi KDE / KRunner (`Alt+Space`)**:
  Ketik `WinPrint Connect`.

---

## Catatan PaperCut

- Antrean PaperCut dibuat dengan `auth-info-required=username,password`: saat mencetak pertama
  kali, CUPS meminta username/password PaperCut. Isi kolom akun Windows sebelum menekan
  "Hubungkan" agar kredensial ikut tertanam pada URI perangkat dan billing langsung tepat.
- Kuota/akun: tombol **Akun PaperCut** membuka `http(s)://<host>:9191|9192/user`.
- Batasan: finishing/staple tidak didukung Mobility Print. Bila server mengabaikan ukuran
  kertas/duplex dari dialog, paksa lewat
  `lp -d <antrean> -o media=ISO_A3 -o sides=two-sided-long-edge file.pdf`.
- PaperCut User Client (popup saldo/account selection) tidak dipasang otomatis oleh aplikasi
  ini; pasang manual dari `\\<server>\PCClient` bila diperlukan.

---

## Lisensi
MIT License.
