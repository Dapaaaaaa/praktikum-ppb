import 'package:flutter/material.dart';
// Package provider: state management resmi yang direkomendasikan Flutter.
// Dibangun di atas InheritedWidget sehingga state bisa diakses dari widget mana pun di bawahnya.
import 'package:provider/provider.dart';

void main() {
  runApp(
    // MultiProvider: Mendaftarkan lebih dari satu Provider sekaligus di root aplikasi.
    // Diletakkan DI ATAS MaterialApp agar semua halaman (termasuk halaman hasil
    // Navigator.push seperti DetailKaryawanPage) tetap bisa mengakses state yang sama.
    MultiProvider(
      providers: [
        // ChangeNotifierProvider: Membuat & menyimpan instance ChangeNotifier,
        // lalu otomatis membuangnya (dispose) saat tidak dipakai lagi.
        ChangeNotifierProvider(create: (_) => KaryawanProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      // Widget MaterialApp: Pengaturan tema dan root aplikasi
      child: const MaterialApp(
        title: 'Manajemen Karyawan Rumah Makan',
        debugShowCheckedModeBanner: false,
        // Widget MainPage: Halaman pembungkus utama navigasi
        home: MainPage(),
      ),
    ),
  );
}

// =====================================================================
// MODEL
// =====================================================================
// Model data untuk menyimpan informasi karyawan dan state jatah makannya
class KaryawanItem {
  final String nama;
  final String posisi;
  final String imagePath;
  final IconData iconRole;
  final Color roleColor;
  bool hadir;
  int jatahMakan; // State jumlah counter (adaptasi CartProductCard)

  KaryawanItem({
    required this.nama,
    required this.posisi,
    required this.imagePath,
    required this.iconRole,
    required this.roleColor,
    this.hadir = true,
    this.jatahMakan = 1,
  });
}

// =====================================================================
// STATE MANAGEMENT (PROVIDER)
// =====================================================================

// ChangeNotifier: Kelas dasar Flutter untuk menyimpan state sekaligus memberi tahu
// pendengarnya (listener). Setiap kali state berubah, kita panggil notifyListeners()
// sehingga widget yang "mendengarkan" (watch/Consumer/Selector) otomatis di-rebuild.
// Ini menggantikan peran setState() yang sebelumnya tersebar di tiap halaman.

// NavigationProvider: State untuk tab navigasi yang sedang aktif (sebelumnya _currentIndex)
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  // Getter: Akses baca saja, state hanya boleh diubah lewat method di provider
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    // notifyListeners: Memberi sinyal ke semua listener bahwa state tab berubah
    notifyListeners();
  }
}

// KaryawanProvider: Menyimpan seluruh state & logika bisnis halaman karyawan:
// shift aktif, kata kunci pencarian, daftar karyawan, dan counter jatah makan.
class KaryawanProvider extends ChangeNotifier {
  static const int minJatah = 1;
  static const int maxJatah = 3;

  // State 1: Status shift aktif (dikontrol oleh ElevatedButton)
  String _shiftAktif = 'Pagi';

  // State 2: Kata kunci pencarian (dikontrol oleh TextField)
  String _query = '';

  // State 3: Data master daftar karyawan rumah makan
  final List<KaryawanItem> _daftarKaryawan = [
    KaryawanItem(
      nama: 'Azka',
      posisi: 'Kepala Koki (Dapur Utama)',
      imagePath: 'assets/images/bos.jpg',
      iconRole: Icons.soup_kitchen,
      roleColor: const Color(0xFFD32F2F),
      jatahMakan: 2,
    ),
    KaryawanItem(
      nama: 'Hammam Syamil',
      posisi: 'Kasir & Keuangan',
      imagePath: 'assets/images/perry.jpg',
      iconRole: Icons.point_of_sale,
      roleColor: const Color(0xFF1976D2),
      jatahMakan: 1,
    ),
    KaryawanItem(
      nama: 'Ilham',
      posisi: 'Pramusaji / Waiter',
      imagePath: 'assets/images/phineas.jpg',
      iconRole: Icons.person,
      roleColor: const Color(0xFFF57F17),
      jatahMakan: 1,
    ),
  ];

  // ---------- GETTER (state turunan) ----------
  String get shiftAktif => _shiftAktif;

  String get jamShift =>
      _shiftAktif == 'Pagi' ? '08:00 - 16:00' : '16:00 - 23:00';

  String get query => _query;

  // Daftar yang sudah difilter berdasarkan kata kunci (dihitung ulang tiap diakses,
  // jadi tidak perlu menyimpan list terpisah seperti _karyawanTerfilter sebelumnya)
  List<KaryawanItem> get karyawanTerfilter {
    final q = _query.toLowerCase();
    return _daftarKaryawan.where((k) {
      return k.nama.toLowerCase().contains(q) ||
          k.posisi.toLowerCase().contains(q);
    }).toList();
  }

  // Menghitung total porsi makan dari semua karyawan
  int get totalPorsiMakan {
    return _daftarKaryawan.fold(0, (sum, item) => sum + item.jatahMakan);
  }

  // ---------- AKSI (mengubah state) ----------
  void toggleShift() {
    _shiftAktif = (_shiftAktif == 'Pagi') ? 'Malam' : 'Pagi';
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void tambahJatah(KaryawanItem karyawan) {
    if (karyawan.jatahMakan < maxJatah) {
      karyawan.jatahMakan++;
      notifyListeners();
    }
  }

  void kurangiJatah(KaryawanItem karyawan) {
    if (karyawan.jatahMakan > minJatah) {
      karyawan.jatahMakan--;
      notifyListeners();
    }
  }
}

// =====================================================================
// ROOT NAVIGASI
// =====================================================================
// Widget StatelessWidget: Wrapper Navigation Bar.
// Tidak lagi butuh StatefulWidget karena indeks tab sudah disimpan di NavigationProvider.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const List<Widget> _pages = [
    // Widget ManajemenKaryawanPage: Tab daftar karyawan & kontrol presensi
    ManajemenKaryawanPage(),
    // Widget ProfilRestoPage: Tab informasi restoran
    ProfilRestoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // context.watch: Membaca state SEKALIGUS berlangganan perubahan.
    // Saat currentIndex berubah, build() ini dijalankan ulang.
    final currentIndex = context.watch<NavigationProvider>().currentIndex;

    // Widget Scaffold: Struktur dasar halaman ber-navbar
    return Scaffold(
      body: _pages[currentIndex],
      // Widget NavigationBar: Komponen navigasi bawah
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          // context.read: Membaca provider tanpa berlangganan (cocok dipakai di dalam
          // callback/event handler), lalu memanggil method untuk mengubah state.
          context.read<NavigationProvider>().setIndex(index);
        },
        backgroundColor: Colors.white,
        destinations: const [
          // Widget NavigationDestination: Tab karyawan
          NavigationDestination(
            // Widget Icon: Ikon default tab karyawan
            icon: Icon(Icons.people_outline),
            // Widget Icon: Ikon terpilih tab karyawan
            selectedIcon: Icon(Icons.people, color: Color(0xFFD32F2F)),
            label: 'Karyawan',
          ),
          // Widget NavigationDestination: Tab info resto
          NavigationDestination(
            // Widget Icon: Ikon default tab resto
            icon: Icon(Icons.storefront_outlined),
            // Widget Icon: Ikon terpilih tab resto
            selectedIcon: Icon(Icons.storefront, color: Color(0xFFD32F2F)),
            label: 'Info Resto',
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HALAMAN 1: MANAJEMEN KARYAWAN
// =====================================================================
// Widget StatefulWidget: Tetap stateful HANYA untuk mengelola TextEditingController
// (state murni UI yang perlu di-dispose). Data bisnis seluruhnya ada di KaryawanProvider.
class ManajemenKaryawanPage extends StatefulWidget {
  const ManajemenKaryawanPage({super.key});

  @override
  State<ManajemenKaryawanPage> createState() => _ManajemenKaryawanPageState();
}

class _ManajemenKaryawanPageState extends State<ManajemenKaryawanPage> {
  // Controller untuk menangani input TextField (state UI lokal)
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sinkronkan teks TextField dengan query di provider, karena halaman ini dibuat
    // ulang saat pindah tab sedangkan query di provider tetap tersimpan.
    _searchController.text = context.read<KaryawanProvider>().query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Kerangka halaman karyawan
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Menjaga konten dari notch dan status bar
      body: SafeArea(
        // Widget SingleChildScrollView: Memungkinkan halaman digulir
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi luar halaman
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Menyusun seluruh komponen secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER RESTORAN ---
                // Widget Container: Baris pembungkus identitas resto
                Container(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  // Widget Row: Menyusun logo dan judul secara horizontal
                  child: Row(
                    children: [
                      // Widget Icon: Logo resto
                      const Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Color(0xFFD32F2F),
                      ),
                      // Widget SizedBox: Jarak horizontal pemisah
                      const SizedBox(width: 10),
                      // Widget Column: Judul dan deskripsi vertikal
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
                          // Widget SizedBox: Jarak kecil vertikal
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

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 12),

                // --- STATE PADA ELEVATEDBUTTON: KONTROL SHIFT KERJA ---
                // Consumer: Widget yang mendengarkan KaryawanProvider dan hanya me-rebuild
                // bagian di dalam builder-nya saat provider memanggil notifyListeners().
                Consumer<KaryawanProvider>(
                  builder: (context, provider, _) {
                    final shift = provider.shiftAktif;
                    // Widget Container: Panel pengaturan shift aktif
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      // Widget Row: Menata status shift dan tombol secara horizontal
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Widget Column: Keterangan shift aktif saat ini
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Widget Text: Label status
                              const Text(
                                'Shift Operasional:',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              // Widget SizedBox: Jarak kecil
                              const SizedBox(height: 2),
                              // Widget Text: Nilai state shift yang berubah dinamis
                              Text(
                                'Shift $shift (${provider.jamShift})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ],
                          ),

                          // Widget ElevatedButton: Tombol pengubah state shift
                          ElevatedButton(
                            // Memanggil method provider (bukan setState lagi)
                            onPressed: provider.toggleShift,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: shift == 'Pagi'
                                  ? const Color(0xFFD32F2F)
                                  : Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            // Widget Text: Teks tombol berubah sesuai state shift
                            child: Text(
                              'Ganti ke ${shift == 'Pagi' ? 'Malam' : 'Pagi'}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 12),

                // --- STATE PADA TEXTFIELD: INPUT PENCARIAN STAF ---
                // Widget Container: Kotak pembungkus TextField
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCCCCCC)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // Selector: Varian Consumer yang hanya me-rebuild jika nilai yang DIPILIH
                  // berubah. Di sini hanya mengamati "apakah query kosong?" (bool), jadi
                  // TextField tidak di-rebuild setiap huruf diketik, hanya saat tombol
                  // clear perlu muncul/hilang.
                  child: Selector<KaryawanProvider, bool>(
                    selector: (_, provider) => provider.query.isNotEmpty,
                    builder: (context, adaTeks, _) {
                      // Widget TextField: Input teks pencarian dengan controller
                      return TextField(
                        controller: _searchController,
                        // onChanged: Meneruskan input ke provider (context.read karena
                        // ini event handler, bukan untuk membangun tampilan)
                        onChanged: (value) =>
                            context.read<KaryawanProvider>().setQuery(value),
                        decoration: InputDecoration(
                          // Widget Icon: Ikon pencarian
                          icon: const Icon(Icons.search, color: Colors.grey),
                          hintText: 'Cari nama staf atau posisi...',
                          border: InputBorder.none,
                          hintStyle:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                          // Widget IconButton: Tombol hapus pencarian bila ada teks
                          suffixIcon: adaTeks
                              ? IconButton(
                                  // Widget Icon: Ikon clear
                                  icon: const Icon(Icons.clear,
                                      size: 18, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<KaryawanProvider>().setQuery('');
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 14),

                // --- RINGKASAN METRIK KARYAWAN & TOTAL JATAH MAKAN ---
                // Widget Row: Menata kotak statistik secara horizontal
                Row(
                  children: [
                    // Widget Expanded: Membagi lebar kartu pertama sama rata
                    Expanded(
                      // Widget Container: Kartu total staf terfilter
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        // Widget Column: Menyusun teks vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Widget Text: Label kategori
                            const Text(
                              'Hasil Pencarian',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            // Widget SizedBox: Jarak kecil
                            const SizedBox(height: 4),
                            // Selector: Hanya rebuild saat JUMLAH hasil filter berubah
                            Selector<KaryawanProvider, int>(
                              selector: (_, provider) =>
                                  provider.karyawanTerfilter.length,
                              builder: (context, jumlah, _) {
                                // Widget Text: Jumlah staf hasil filter dinamis
                                return Text(
                                  '$jumlah Karyawan',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Widget SizedBox: Jarak horizontal pemisah
                    const SizedBox(width: 12),

                    // Widget Expanded: Membagi lebar kartu kedua sama rata
                    Expanded(
                      // Widget Container: Kartu akumulasi counter jatah makan
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        // Widget Column: Menyusun teks vertikal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Widget Text: Label total jatah konsumsi dapur
                            const Text(
                              'Total Porsi Konsumsi',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            // Widget SizedBox: Jarak kecil
                            const SizedBox(height: 4),
                            // Selector: Hanya rebuild saat total porsi berubah
                            Selector<KaryawanProvider, int>(
                              selector: (_, provider) => provider.totalPorsiMakan,
                              builder: (context, total, _) {
                                // Widget Text: Angka hasil kalkulasi counter dinamis
                                return Text(
                                  '$total Porsi',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 18),

                // Widget Text: Label judul daftar staf
                const Text(
                  'Daftar Staf & Jatah Konsumsi Shift',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // Widget SizedBox: Jarak kecil sebelum list item
                const SizedBox(height: 10),

                // --- DAFTAR KARYAWAN DENGAN INPUT JUMLAH (COUNTER) ---
                // Consumer: Daftar otomatis dibangun ulang saat query atau counter berubah
                Consumer<KaryawanProvider>(
                  builder: (context, provider, _) {
                    final daftar = provider.karyawanTerfilter;

                    // Menampilkan teks kosong jika hasil pencarian tidak ditemukan
                    if (daftar.isEmpty) {
                      // Widget Center: Memposisikan teks di tengah halaman
                      return const Center(
                        // Widget Padding: Jarak ruang teks kosong
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          // Widget Text: Pesan tidak ada staf ditemukan
                          child: Text(
                            'Tidak ada karyawan yang cocok dengan pencarian.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      );
                    }

                    // Widget Column: Menyusun kartu karyawan secara vertikal
                    return Column(
                      children: [
                        for (final karyawan in daftar)
                          _buildKaryawanCardWithCounter(karyawan),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ADAPTASI MODUL: STATE INPUT JUMLAH / COUNTER PADA KARTU ---
  Widget _buildKaryawanCardWithCounter(KaryawanItem karyawan) {
    // Widget Container: Kartu pembungkus item staf
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      // Widget Column: Menyusun informasi staf dan kontrol counter secara vertikal
      child: Column(
        children: [
          // Widget Row: Menata avatar, nama staf, dan tombol detail
          Row(
            children: [
              // Widget Stack: Menumpuk avatar dengan indikator status kehadiran
              Stack(
                children: [
                  // Widget Container: Bingkai avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Widget ClipRRect: Memotong sudut foto
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      // Widget Image (Asset): Foto profil staf
                      child: Image.asset(
                        karyawan.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Widget Positioned: Titik hijau status kehadiran
                  Positioned(
                    bottom: 0,
                    right: 0,
                    // Widget Container: Titik bulat status hadir
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

              // Widget SizedBox: Jarak horizontal pemisah
              const SizedBox(width: 12),

              // Widget Expanded: Memastikan teks nama memenuhi ruang tengah
              Expanded(
                // Widget Column: Menyusun nama dan jabatan staf
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Widget Row: Menyusun ikon jabatan dan nama staf
                    Row(
                      children: [
                        // Widget Icon: Ikon peran kerja staf
                        Icon(karyawan.iconRole, size: 14, color: karyawan.roleColor),
                        // Widget SizedBox: Jarak kecil horizontal
                        const SizedBox(width: 4),
                        // Widget Text: Nama karyawan
                        Text(
                          karyawan.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    // Widget SizedBox: Jarak pemisah vertikal
                    const SizedBox(height: 2),
                    // Widget Text: Posisi karyawan
                    Text(
                      karyawan.posisi,
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // Widget GestureDetector: Navigasi tombol detail ke halaman baru
              GestureDetector(
                onTap: () {
                  // Navigator.push: Berpindah rute ke halaman DetailKaryawanPage
                  Navigator.push(
                    context,
                    // Widget MaterialPageRoute: Membangun transisi rute halaman baru
                    MaterialPageRoute(
                      // Widget DetailKaryawanPage: Halaman tujuan rincian staf.
                      // Cukup mengirim objek karyawan; shift diambil langsung dari
                      // provider sehingga tidak perlu dikirim lewat constructor.
                      builder: (context) =>
                          DetailKaryawanPage(karyawan: karyawan),
                    ),
                  );
                },
                // Widget Container: Tombol detail bernuansa abu
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // Widget Row: Menata teks dan ikon panah
                  child: Row(
                    children: const [
                      // Widget Text: Label tombol detail
                      Text('Detail',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      // Widget SizedBox: Jarak kecil
                      SizedBox(width: 2),
                      // Widget Icon: Ikon chevron kanan
                      Icon(Icons.chevron_right, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Widget SizedBox: Jarak pemisah vertikal
          const SizedBox(height: 10),

          // Widget Container: Kotak kontrol State Input Jumlah Porsi Makan (Adaptasi CartProductCard)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            // Widget Row: Menyusun label jatah makan dan tombol counter plus/minus
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Widget Text: Keterangan konsumsi shift
                const Text(
                  'Jatah Porsi Makan / Shift:',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),

                // Widget Row: Kontrol counter plus-minus (Modul: State pada Input Jumlah)
                Row(
                  children: [
                    // Widget InkWell: Tombol aksi pengurangan (-)
                    InkWell(
                      // context.read: Memanggil aksi di provider (min 1 porsi diatur di provider)
                      onTap: () =>
                          context.read<KaryawanProvider>().kurangiJatah(karyawan),
                      // Widget Container: Kotak tombol minus
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: karyawan.jatahMakan > KaryawanProvider.minJatah
                              ? Colors.white
                              : const Color(0xFFEEEEEE),
                          border: Border.all(color: const Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        // Widget Icon: Ikon minus
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: karyawan.jatahMakan > KaryawanProvider.minJatah
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),

                    // Widget SizedBox: Jarak pemisah horizontal
                    const SizedBox(width: 8),

                    // Widget Text: Menampilkan angka state jumlah yang berubah dinamis
                    Text(
                      '${karyawan.jatahMakan}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Widget SizedBox: Jarak pemisah horizontal
                    const SizedBox(width: 8),

                    // Widget InkWell: Tombol aksi penambahan (+)
                    InkWell(
                      // context.read: Memanggil aksi di provider (maks 3 porsi diatur di provider)
                      onTap: () =>
                          context.read<KaryawanProvider>().tambahJatah(karyawan),
                      // Widget Container: Kotak tombol plus
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: karyawan.jatahMakan < KaryawanProvider.maxJatah
                              ? Colors.white
                              : const Color(0xFFEEEEEE),
                          border: Border.all(color: const Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        // Widget Icon: Ikon tambah
                        child: Icon(
                          Icons.add,
                          size: 14,
                          color: karyawan.jatahMakan < KaryawanProvider.maxJatah
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HALAMAN 2: DETAIL KARYAWAN
// =====================================================================
// Widget StatelessWidget: Menampilkan rincian lengkap profil karyawan.
// Shift & jatah makan dibaca langsung dari provider, sehingga selalu sinkron
// dengan halaman utama (tidak lagi hanya "salinan" nilai saat tombol ditekan).
class DetailKaryawanPage extends StatelessWidget {
  final KaryawanItem karyawan;

  const DetailKaryawanPage({super.key, required this.karyawan});

  @override
  Widget build(BuildContext context) {
    // context.watch: Berlangganan KaryawanProvider; halaman ini ikut ter-update
    // jika shift atau jatah makan berubah.
    final provider = context.watch<KaryawanProvider>();
    final shift = provider.shiftAktif;

    // Widget Scaffold: Kerangka halaman detail
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Area aman layar
      body: SafeArea(
        // Widget SingleChildScrollView: Memungkinkan scroll halaman detail
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi luar
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Menyusun komponen detail secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget GestureDetector: Tombol aksi kembali
                GestureDetector(
                  onTap: () {
                    // Navigator.pop: Kembali ke halaman sebelumnya
                    Navigator.pop(context);
                  },
                  // Widget Container: Kotak tombol kembali
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Widget Row: Ikon dan teks kembali
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // Widget Icon: Ikon panah kiri
                        Icon(Icons.arrow_back, size: 16),
                        // Widget SizedBox: Jarak horizontal
                        SizedBox(width: 6),
                        // Widget Text: Label teks kembali
                        Text(
                          'Kembali',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 16),

                // Widget Container: Kartu detail karyawan
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Widget Column: Menyusun elemen informasi profil
                  child: Column(
                    children: [
                      // Widget Stack: Foto besar dan label shift
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Widget Container: Wadah foto staf
                          Container(
                            width: 110,
                            height: 110,
                            margin: const EdgeInsets.only(bottom: 10),
                            // Widget ClipRRect: Pemotong sudut foto
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              // Widget Image (Asset): Foto staf
                              child: Image.asset(
                                karyawan.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Widget Positioned: Badge shift aktif
                          Positioned(
                            bottom: 0,
                            // Widget Container: Kotak badge shift
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: shift == 'Pagi'
                                    ? const Color(0xFF2E7D32)
                                    : Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Widget Text: Nilai shift yang dibaca dari provider
                              child: Text(
                                'Shift $shift',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Widget SizedBox: Jarak vertikal
                      const SizedBox(height: 12),

                      // Widget Text: Nama karyawan
                      Text(
                        karyawan.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Widget SizedBox: Jarak kecil
                      const SizedBox(height: 4),
                      // Widget Text: Posisi karyawan
                      Text(
                        karyawan.posisi,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),

                      // Widget SizedBox: Jarak pemisah
                      const SizedBox(height: 16),

                      // Widget Container: Kotak jadwal kerja & status konsumsi
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        // Widget Row: Menata kolom jadwal dan jatah makan
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Widget Column: Info jam kerja
                            Column(
                              children: [
                                // Widget Text: Label jadwal
                                const Text('Jam Tugas',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                                // Widget SizedBox: Jarak
                                const SizedBox(height: 2),
                                // Widget Text: Waktu shift (dari provider)
                                Text(
                                  provider.jamShift,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                            // Widget Column: Info porsi konsumsi
                            Column(
                              children: [
                                // Widget Text: Label porsi
                                const Text('Konsumsi Shift',
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                                // Widget SizedBox: Jarak
                                const SizedBox(height: 2),
                                // Widget Text: Jumlah jatah porsi yang diatur lewat counter
                                Text(
                                  '${karyawan.jatahMakan} Porsi',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF2E7D32),
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

// =====================================================================
// HALAMAN 3: INFO RESTO (tidak berubah, tidak butuh state)
// =====================================================================
// Widget StatelessWidget: Halaman informasi cabang restoran
class ProfilRestoPage extends StatelessWidget {
  const ProfilRestoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold: Kerangka halaman profil resto
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Widget SafeArea: Area aman layar
      body: SafeArea(
        // Widget SingleChildScrollView: Scroll halaman profil resto
        child: SingleChildScrollView(
          // Widget Padding: Jarak tepi luar
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Widget Column: Menyusun komponen profil secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget Text: Judul halaman profil
                const Text(
                  'Profil Rumah Makan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // Widget SizedBox: Jarak pemisah vertikal
                const SizedBox(height: 14),

                // Widget Container: Kartu informasi profil resto
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Widget Column: Data rincian resto
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widget ClipRRect: Pemotong sudut foto resto
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        // Widget Image (Asset): Foto fisik rumah makan
                        child: Image.asset(
                          'assets/images/halaman.jpg',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Widget SizedBox: Jarak pemisah
                      const SizedBox(height: 12),
                      // Widget Text: Nama resto
                      const Text(
                        'RM Harahap - Cabang Utama',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      // Widget SizedBox: Jarak kecil
                      const SizedBox(height: 4),
                      // Widget Text: Alamat lokasi cabang
                      const Text(
                        'Jl. Pramuka No. 12, Samarinda, Kalimantan Timur',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      // Widget SizedBox: Jarak pemisah
                      const SizedBox(height: 12),
                      // Widget Row: Ikon kontak telepon dan nomor telepon
                      Row(
                        children: const [
                          // Widget Icon: Ikon telepon
                          Icon(Icons.phone, size: 14, color: Color(0xFFD32F2F)),
                          // Widget SizedBox: Jarak horizontal
                          SizedBox(width: 6),
                          // Widget Text: Nomor telepon resto
                          Text(
                            '+62 812-3456-7890',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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