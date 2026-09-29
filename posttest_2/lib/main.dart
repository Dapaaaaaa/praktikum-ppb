import 'package:flutter/material.dart';

void main() {
  // Widget MaterialApp: Root / inisialisasi aplikasi Flutter
  runApp(
    const MaterialApp(
      title: 'Manajemen Karyawan Rumah Makan',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    ),
  );
}

// Widget StatefulWidget: Halaman pembungkus utama yang mengelola Navigation Bar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State {
  int _currentIndex = 0;

  // Daftar halaman yang diakses melalui Navigation Bar
  final List _pages = const [ManajemenKaryawanPage(), ProfilRestoPage()];

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Kerangka utama aplikasi yang menampung Body dan Navigation Bar
    return Scaffold(
      body: _pages[_currentIndex],
      // Widget NavigationBar: Komponen navigasi bawah (Navigation Bar)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        destinations: const [
          // Widget NavigationDestination: Item tab beranda
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Color(0xFFD32F2F)),
            label: 'Karyawan',
          ),
          // Widget NavigationDestination: Item tab profil resto
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFFD32F2F)),
            label: 'Info Resto',
          ),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 1: MANAJEMEN KARYAWAN ====================
class ManajemenKaryawanPage extends StatelessWidget {
  const ManajemenKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Kerangka halaman daftar karyawan
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Menjaga konten agar tidak tertutup notch atau status bar
      body: SafeArea(
        // Widget SingleChildScrollView: Membuat halaman bisa discroll vertikal
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi luar konten
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Menyusun tata letak secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER HALAMAN ---
                // Widget Container: Wadah baris header
                Container(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  // Widget Row: Menyusun ikon dan teks header secara horizontal
                  child: Row(
                    children: [
                      // Widget Icon: Ikon resto
                      const Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Color(0xFFD32F2F),
                      ),
                      // Widget SizedBox: Jarak pemisah horizontal
                      const SizedBox(width: 10),
                      // Widget Column: Menyusun judul dan subjudul vertikal
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Widget Text: Judul resto
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
                          // Widget Text: Subjudul modul
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

                // Widget SizedBox: Jarak vertikal
                const SizedBox(height: 14),

                // --- BANNER PROFIL CABANG DENGAN STACK & POSITIONED ---
                // Widget Stack: Menumpuk elemen gambar dengan badge teks di atasnya
                Stack(
                  children: [
                    // Widget Container: Wadah gambar resto dengan bayangan (BoxShadow)
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        // BoxShadow: Memberikan efek bayangan lembut pada kartu banner
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        // Widget Image: Menampilkan foto suasana dapur/restoran
                        child: Image.asset(
                          'assets/images/halaman.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Widget Positioned: Mengatur letak badge di pojok kanan atas banner
                    Positioned(
                      top: 10,
                      right: 10,
                      // Widget Container: Wadah badge status operasional
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        // Widget Text: Keterangan operasional resto
                        child: const Text(
                          'Shift Aktif Berjalan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Widget SizedBox: Jarak vertikal
                const SizedBox(height: 16),

                // --- PENCARIAN KARYAWAN ---
                // Widget Container: Wadah form pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCCCCCC)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Widget TextField: Input teks pencarian staf
                  child: const TextField(
                    decoration: InputDecoration(
                      // Widget Icon: Ikon pencarian
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
                // Widget Row: Menata dua kotak ringkasan horizontal berdampingan
                Row(
                  children: [
                    // Widget Expanded: Membagi lebar sama rata untuk kotak 1
                    Expanded(
                      // Widget Container: Kotak ringkasan total staf dengan BoxShadow
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                          // BoxShadow: Efek bayangan kotak ringkasan
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        // Widget Column: Menyusun data metrik vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Label kategori shift
                            Text(
                              'Shift Aktif (Pagi)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            // Widget SizedBox: Jarak kecil
                            SizedBox(height: 6),
                            // Widget Text: Total staf
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

                    // Widget SizedBox: Jarak horizontal antar kotak ringkasan
                    const SizedBox(width: 12),

                    // Widget Expanded: Membagi lebar sama rata untuk kotak 2
                    Expanded(
                      // Widget Container: Kotak ringkasan kehadiran dengan BoxShadow
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                          // BoxShadow: Efek bayangan kotak presensi
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        // Widget Column: Menyusun data presensi vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Widget Text: Label kehadiran
                            Text(
                              'Kehadiran Hari Ini',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            // Widget SizedBox: Jarak kecil
                            SizedBox(height: 6),
                            // Widget Text: Jumlah staf hadir
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

                // Widget SizedBox: Jarak pemisah
                const SizedBox(height: 20),

                // Widget Text: Judul list staf
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

                // --- DATA KARYAWAN 1 (CHEF) ---
                _buildKaryawanCard(
                  context: context,
                  nama: 'Azka',
                  posisi: 'Kepala Koki (Dapur Utama)',
                  status: 'Hadir',
                  imagePath: 'assets/images/bos.jpg',
                  iconRole: Icons.soup_kitchen,
                  roleColor: const Color(0xFFD32F2F),
                ),

                // --- DATA KARYAWAN 2 (KASIR) ---
                _buildKaryawanCard(
                  context: context,
                  nama: 'Meera',
                  posisi: 'Kasir & Keuangan',
                  status: 'Hadir',
                  imagePath: 'assets/images/perry.jpg',
                  iconRole: Icons.point_of_sale,
                  roleColor: const Color(0xFF1976D2),
                ),

                // --- DATA KARYAWAN 3 (PRAMUSAJI) ---
                _buildKaryawanCard(
                  context: context,
                  nama: 'Ilham',
                  posisi: 'Pramusaji / Waiter',
                  status: 'Hadir',
                  imagePath: 'assets/images/phineas.jpg',
                  iconRole: Icons.person,
                  roleColor: const Color(0xFFF57F17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget kartu staf menggunakan Stack, Positioned, Image, dan BoxShadow
  Widget _buildKaryawanCard({
    required BuildContext context,
    required String nama,
    required String posisi,
    required String status,
    required String imagePath,
    required IconData iconRole,
    required Color roleColor,
  }) {
    // Widget Container: Pembungkus baris staf dengan border & BoxShadow
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(4.0),
        // BoxShadow: Bayangan halus pembatas baris data
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      // Widget Row: Menata foto, deskripsi, dan tombol navigasi detail secara horizontal
      child: Row(
        children: [
          // Widget Stack: Menumpuk foto profil karyawan dengan badge status hadir
          Stack(
            children: [
              // Widget Container: Wadah foto profil karyawan
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  // Widget Image: Foto karyawan dari URL
                  child: Image.network(imagePath, fit: BoxFit.cover),
                ),
              ),
              // Widget Positioned: Indikator titik hijau di sudut kanan bawah avatar
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),

          // Widget SizedBox: Jarak dari avatar ke rincian teks
          const SizedBox(width: 12),

          // Widget Expanded: Membuat rincian nama dan peran mengisi ruang tengah
          Expanded(
            // Widget Column: Menyusun teks nama dan peran secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget Row: Ikon divisi kecil berdampingan dengan nama
                Row(
                  children: [
                    // Widget Icon: Ikon peran kerja
                    Icon(iconRole, size: 14, color: roleColor),
                    // Widget SizedBox: Jarak kecil
                    const SizedBox(width: 4),
                    // Widget Text: Nama karyawan
                    Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // Widget SizedBox: Jarak kecil
                const SizedBox(height: 2),
                // Widget Text: Jabatan staf
                Text(
                  posisi,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Widget Container: Tombol navigasi "Detail" ke halaman berikutnya
          GestureDetector(
            onTap: () {
              // Navigator.push: Berpindah rute ke halaman DetailKaryawanPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailKaryawanPage(
                    nama: nama,
                    posisi: posisi,
                    imagePath: imagePath,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(4),
              ),
              // Widget Row: Teks tombol dan panah
              child: Row(
                children: const [
                  // Widget Text: Label tombol detail
                  Text(
                    'Detail',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  // Widget SizedBox: Jarak kecil
                  SizedBox(width: 2),
                  // Widget Icon: Ikon navigasi panah
                  Icon(Icons.chevron_right, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 2: DETAIL KARYAWAN (NAVIGATOR PUSH & POP) ====================
class DetailKaryawanPage extends StatelessWidget {
  final String nama;
  final String posisi;
  final String imagePath;

  const DetailKaryawanPage({
    super.key,
    required this.nama,
    required this.posisi,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Halaman detail karyawan
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Area aman layar
      body: SafeArea(
        // Widget SingleChildScrollView: Scroll halaman detail
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Tata letak vertikal elemen detail
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- TOMBOL KEMBALI MENGGUNAKAN NAVIGATOR.POP ---
                GestureDetector(
                  onTap: () {
                    // Navigator.pop: Kembali ke halaman daftar karyawan sebelumnya
                    Navigator.pop(context);
                  },
                  // Widget Container: Tombol kembali dengan border
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Widget Row: Menyusun ikon panah kiri dan teks "Kembali"
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // Widget Icon: Ikon kembali
                        Icon(Icons.arrow_back, size: 16),
                        // Widget SizedBox: Jarak
                        SizedBox(width: 6),
                        // Widget Text: Teks kembali
                        Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Widget SizedBox: Jarak vertikal
                const SizedBox(height: 16),

                // --- KARTU FOTO PROFIL DENGAN STACK & POSITIONED ---
                // Widget Container: Wadah utama info detail
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(6.0),
                    // BoxShadow: Efek bayangan kartu detail staf
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Widget Column: Tata letak informasi staf
                  child: Column(
                    children: [
                      // Widget Stack: Memposisikan foto besar dan status bertugas
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Widget Container: Bingkai foto detail karyawan
                          Container(
                            width: 110,
                            height: 110,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              // Widget Image: Foto karyawan dalam resolusi lebih jelas
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Widget Positioned: Badge "Aktif Bekerja" di bawah foto
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Widget Text: Status staf
                              child: const Text(
                                'Shift Pagi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Widget SizedBox: Jarak vertikal
                      const SizedBox(height: 12),

                      // Widget Text: Nama lengkap staf
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Widget SizedBox: Jarak kecil
                      const SizedBox(height: 4),
                      // Widget Text: Jabatan kerja
                      Text(
                        posisi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),

                      // Widget SizedBox: Jarak pemisah
                      const SizedBox(height: 16),

                      // Widget Container: Kotak informasi jadwal jam kerja
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        // Widget Row: Jam masuk & keluar
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            // Widget Column: Jam masuk
                            Column(
                              children: [
                                Text(
                                  'Jam Masuk',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '07:55 WITA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            // Widget Column: Jam pulang
                            Column(
                              children: [
                                Text(
                                  'Jadwal Pulang',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '16:00 WITA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
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

// ==================== HALAMAN 3: INFO RESTO (TAB KEDUA NAVIGATION BAR) ====================
class ProfilRestoPage extends StatelessWidget {
  const ProfilRestoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Halaman info cabang restoran
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Area aman layar
      body: SafeArea(
        // Widget SingleChildScrollView: Scroll halaman profil resto
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi halaman
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Susunan info profil resto
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget Text: Judul halaman tab info resto
                const Text(
                  'Profil Rumah Makan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // Widget SizedBox: Jarak vertikal
                const SizedBox(height: 14),

                // Widget Container: Kartu informasi resto dengan BoxShadow
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    // BoxShadow: Bayangan kartu info rumah makan
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Widget Column: Data detail cabang resto
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widget ClipRRect: Memotong sudut gambar depan resto
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        // Widget Image: Foto resto
                        child: Image.asset(
                          'assets/images/halaman.jpg',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Widget SizedBox: Jarak
                      const SizedBox(height: 12),
                      // Widget Text: Nama resto
                      const Text(
                        'RM Harahap - Cabang Utama',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Widget SizedBox: Jarak
                      const SizedBox(height: 4),
                      // Widget Text: Alamat lokasi cabang
                      const Text(
                        'Jl. Pramuka No. 12, Samarinda, Kalimantan Timur',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      // Widget SizedBox: Jarak
                      const SizedBox(height: 12),
                      // Widget Row: Ikon kontak dan nomor telepon
                      Row(
                        children: const [
                          // Widget Icon: Ikon telepon
                          Icon(Icons.phone, size: 14, color: Color(0xFFD32F2F)),
                          // Widget SizedBox: Jarak
                          SizedBox(width: 6),
                          // Widget Text: Nomor telepon operasional
                          Text(
                            '+62 812-3456-7890',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
