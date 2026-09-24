import 'package:flutter/material.dart';

void main() {
  // Widget MaterialApp: Root / inisialisasi aplikasi Flutter
  runApp(
    const MaterialApp(
      title: 'Manajemen Karyawan Rumah Makan',
      debugShowCheckedModeBanner: false,
      home: ManajemenKaryawanPage(),
    ),
  );
}

// Widget StatelessWidget: Menampilkan halaman utama manajemen karyawan
class ManajemenKaryawanPage extends StatelessWidget {
  const ManajemenKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Menyediakan kerangka dasar halaman aplikasi
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Memastikan konten berada di area aman layar (bebas notch / status bar)
      body: SafeArea(
        // Widget SingleChildScrollView: Membuat tata letak halaman bisa digulir secara vertikal
        child: SingleChildScrollView(
          // Widget Padding: Memberikan margin/jarak tepi luar untuk seluruh konten
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Menyusun hierarki tata letak secara vertikal dari atas ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER HALAMAN ---
                // Widget Container: Wadah untuk baris header dengan border bawah
                Container(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  // Widget Row: Menyusun ikon rumah makan dan teks judul secara horizontal
                  child: Row(
                    children: [
                      // Widget Icon: Ikon identitas rumah makan
                      const Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Color(0xFFD32F2F),
                      ),
                      // Widget SizedBox: Memberi jarak horizontal antar widget
                      const SizedBox(width: 10),
                      // Widget Column: Menyusun teks nama resto dan deskripsi secara vertikal
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Widget Text: Judul nama resto
                          Text(
                            'RM Harahap',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          // Widget SizedBox: Jarak vertikal kecil
                          SizedBox(height: 2),
                          // Widget Text: Subjudul modul aplikasi
                          Text(
                            'Sistem Manajemen & Presensi Staff',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Widget SizedBox: Jarak antar bagian header dan pencarian
                const SizedBox(height: 16),

                // --- FORM PENCARIAN KARYAWAN ---
                // Widget Container: Wadah kotak input teks pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCCCCCC)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Widget TextField: Input field bagi pengguna untuk mengetikkan nama staf
                  child: const TextField(
                    decoration: InputDecoration(
                      // Widget Icon: Ikon kaca pembesar pencarian
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Cari nama karyawan atau divisi...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ),

                // Widget SizedBox: Jarak vertikal
                const SizedBox(height: 16),

                // --- RINGKASAN DATA STAF (STATISTIK) ---
                // Widget Row: Menata dua kotak ringkasan secara horizontal berdampingan
                Row(
                  children: [
                    // Widget Expanded: Membagi lebar layar secara proporsional untuk kotak 1
                    Expanded(
                      // Widget Container: Kotak ringkasan total staf shift pagi
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        // Widget Column: Menyusun isi data statistik vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Label kategori
                            Text(
                              'Shift Aktif (Pagi)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            // Widget SizedBox: Jarak kecil
                            SizedBox(height: 6),
                            // Widget Text: Angka statistik
                            Text(
                              '3 Karyawan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Widget SizedBox: Jarak pemisah antara kedua kotak statistik
                    const SizedBox(width: 12),

                    // Widget Expanded: Membagi lebar layar secara proporsional untuk kotak 2
                    Expanded(
                      // Widget Container: Kotak ringkasan staf yang hadir
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        // Widget Column: Menyusun isi data statistik vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Label status kehadiran
                            Text(
                              'Kehadiran Hari Ini',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            // Widget SizedBox: Jarak kecil
                            SizedBox(height: 6),
                            // Widget Text: Nilai presensi hadir
                            Text(
                              '3 / 3 Hadir',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Widget SizedBox: Jarak pemisah sebelum daftar data
                const SizedBox(height: 20),

                // Widget Text: Judul tabel / daftar karyawan
                const Text(
                  'Daftar Staf Bertugas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // Widget SizedBox: Jarak kecil sebelum list item
                const SizedBox(height: 10),

                // --- DATA KARYAWAN 1 (CHEF / DAPUR) ---
                // Widget Container: Kartu pembungkus item karyawan ke-1
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Widget Row: Menata avatar ikon, rincian data, dan label status secara horizontal
                  child: Row(
                    children: [
                      // Widget Container: Bingkai kotak latar belakang ikon peran
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE9E7),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        // Widget Icon: Ikon profesi dapur / koki
                        child: const Icon(
                          Icons.soup_kitchen,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                      // Widget SizedBox: Jarak horizontal dari ikon ke teks
                      const SizedBox(width: 12),
                      // Widget Expanded: Memberi fleksibilitas teks mengambil ruang tengah
                      Expanded(
                        // Widget Column: Menyusun nama staf dan divisi secara vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Nama karyawan
                            Text(
                              'Azka',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            // Widget SizedBox: Jarak vertikal kecil
                            SizedBox(height: 2),
                            // Widget Text: Posisi / peran kerja
                            Text(
                              'Kepala Koki (Dapur Utama)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Widget Text: Keterangan status kehadiran
                      const Text(
                        'Hadir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- DATA KARYAWAN 2 (KASIR / DEPAN) ---
                // Widget Container: Kartu pembungkus item karyawan ke-2
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Widget Row: Menata elemen karyawan ke-2
                  child: Row(
                    children: [
                      // Widget Container: Bingkai ikon kasir
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        // Widget Icon: Ikon kasir
                        child: const Icon(
                          Icons.point_of_sale,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      // Widget SizedBox: Jarak horizontal
                      const SizedBox(width: 12),
                      // Widget Expanded: Mengatur teks fleksibel di baris tengah
                      Expanded(
                        // Widget Column: Menyusun nama dan divisi
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Nama karyawan
                            Text(
                              'Meera',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            // Widget SizedBox: Jarak pemisah
                            SizedBox(height: 2),
                            // Widget Text: Posisi staf
                            Text(
                              'Kasir & Keuangan',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Widget Text: Status staf
                      const Text(
                        'Hadir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- DATA KARYAWAN 3 (PRAMUSAJI / PELAYANAN) ---
                // Widget Container: Kartu pembungkus item karyawan ke-3
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Widget Row: Menata elemen karyawan ke-3
                  child: Row(
                    children: [
                      // Widget Container: Bingkai ikon pramusaji
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        // Widget Icon: Ikon staf pelayan
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFF57F17),
                        ),
                      ),
                      // Widget SizedBox: Jarak pemisah
                      const SizedBox(width: 12),
                      // Widget Expanded: Mengatur nama dan divisi
                      Expanded(
                        // Widget Column: Menyusun teks secara vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Nama staf
                            Text(
                              'Ilham',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            // Widget SizedBox: Jarak pemisah
                            SizedBox(height: 2),
                            // Widget Text: Posisi staf
                            Text(
                              'Pramusaji / Waiter',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Widget Text: Status staf
                      const Text(
                        'Hadir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
