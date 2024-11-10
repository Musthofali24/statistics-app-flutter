import 'package:flutter/material.dart';
import '../widgets/theme_toggle.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teori Statistik'),
        backgroundColor: const Color(0xFF2D3875),
        actions: const [
          ThemeToggle(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(
              context,
              'Pengertian Statistika',
              'Statistika adalah ilmu yang mempelajari cara pengumpulan, pengolahan, penyajian, dan analisis data serta penarikan kesimpulan berdasarkan data tersebut.\n\n'
                  'Statistika dibagi menjadi dua:\n'
                  '• Statistika Deskriptif: Metode statistik untuk merangkum dan menggambarkan data\n'
                  '• Statistika Inferensial: Metode statistik untuk mengambil kesimpulan tentang populasi berdasarkan sampel',
            ),
            _buildTheorySection(
              context,
              'Mean (Rata-rata)',
              'Mean adalah nilai rata-rata dari sekumpulan data.\n\n'
                  'Rumus:\nx̄ = Σx ÷ n\n\n'
                  'Dimana:\n'
                  'x̄ = Mean (rata-rata)\n'
                  'Σx = Jumlah seluruh nilai data\n'
                  'n = Banyaknya data\n\n'
                  'Contoh:\n'
                  'Data: 5, 8, 12, 15, 20\n'
                  'Mean = (5 + 8 + 12 + 15 + 20) ÷ 5\n'
                  'Mean = 60 ÷ 5 = 12',
            ),
            _buildTheorySection(
              context,
              'Median',
              'Median adalah nilai tengah dari data yang telah diurutkan.\n\n'
                  'Rumus untuk data ganjil:\n'
                  'Me = X(n+1)/2\n\n'
                  'Rumus untuk data genap:\n'
                  'Me = (Xn/2 + X(n/2)+1) ÷ 2\n\n'
                  'Contoh data ganjil:\n'
                  'Data: 3, 5, 7, 8, 9\n'
                  'n = 5, maka posisi median = (5+1)/2 = 3\n'
                  'Median = nilai ke-3 = 7\n\n'
                  'Contoh data genap:\n'
                  'Data: 3, 5, 7, 8, 9, 11\n'
                  'n = 6, maka posisi median = (7 + 8) ÷ 2 = 7,5',
            ),
            _buildTheorySection(
              context,
              'Modus',
              'Modus adalah nilai yang paling sering muncul dalam data.\n\n'
                  'Contoh:\n'
                  'Data: 2, 3, 3, 4, 4, 4, 5, 5\n'
                  'Modus = 4 (muncul 3 kali)\n\n'
                  'Catatan:\n'
                  '• Bisa tidak memiliki modus jika semua nilai frekuensinya sama\n'
                  '• Bisa memiliki lebih dari satu modus (bimodal/multimodal)',
            ),
            _buildTheorySection(
              context,
              'Kuartil',
              'Kuartil membagi data menjadi empat bagian sama besar.\n\n'
                  'Rumus:\n'
                  'Q1 = Kuartil bawah = P25\n'
                  'Q2 = Median = P50\n'
                  'Q3 = Kuartil atas = P75\n\n'
                  'Contoh:\n'
                  'Data: 2, 4, 6, 8, 10, 12, 14\n'
                  'Q1 = 4\n'
                  'Q2 = 8\n'
                  'Q3 = 12',
            ),
            _buildTheorySection(
              context,
              'Jangkauan dan IQR',
              'Jangkauan (Range) = Nilai maksimum - Nilai minimum\n\n'
                  'IQR (Interquartile Range) = Q3 - Q1\n\n'
                  'Contoh:\n'
                  'Data: 2, 4, 6, 8, 10, 12, 14\n'
                  'Jangkauan = 14 - 2 = 12\n'
                  'IQR = 12 - 4 = 8\n\n'
                  'Outliers (Pencilan):\n'
                  '• Batas bawah = Q1 - (1.5 × IQR)\n'
                  '• Batas atas = Q3 + (1.5 × IQR)',
            ),
            _buildTheorySection(
              context,
              'Variansi dan Standar Deviasi',
              'Variansi mengukur seberapa jauh sebaran data dari nilai rata-ratanya.\n\n'
                  'Rumus Variansi Populasi:\n'
                  'σ² = Σ(x - μ)² ÷ N\n\n'
                  'Rumus Variansi Sampel:\n'
                  's² = Σ(x - x̄)² ÷ (n-1)\n\n'
                  'Standar Deviasi = √Variansi\n\n'
                  'Contoh:\n'
                  'Data: 2, 4, 4, 4, 5, 5, 7, 9\n'
                  'Mean = 5\n'
                  'Variansi Sampel = 4\n'
                  'Standar Deviasi = 2',
            ),
            _buildTheorySection(
              context,
              'Distribusi Frekuensi',
              'Distribusi frekuensi menunjukkan seberapa sering setiap nilai muncul dalam data.\n\n'
                  'Komponen:\n'
                  '• Nilai Data (x)\n'
                  '• Frekuensi (f): jumlah kemunculan\n'
                  '• Frekuensi Relatif (f%): (f ÷ n) × 100%\n'
                  '• Frekuensi Kumulatif (F): jumlah frekuensi sampai nilai tertentu\n\n'
                  'Contoh:\n'
                  'Data: 2, 2, 3, 3, 3, 4, 4, 5\n'
                  'Nilai | f | f% | F\n'
                  '2     | 2 | 25% | 2\n'
                  '3     | 3 | 37.5% | 5\n'
                  '4     | 2 | 25% | 7\n'
                  '5     | 1 | 12.5% | 8',
            ),
            _buildTheorySection(
              context,
              'Ukuran Penyebaran',
              'Ukuran penyebaran menunjukkan seberapa besar data tersebar dari nilai pusatnya.\n\n'
                  '1. Rentang/Jangkauan\n'
                  '• Range = Nilai Max - Nilai Min\n\n'
                  '2. Simpangan Rata-rata\n'
                  '• SR = Σ|x - x̄| ÷ n\n\n'
                  '3. Variansi dan Standar Deviasi\n'
                  '• Mengukur rata-rata kuadrat simpangan\n\n'
                  '4. Koefisien Variasi\n'
                  '• KV = (s ÷ x̄) × 100%\n'
                  '• Membandingkan variabilitas relatif',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection(
      BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF24262B) // Warna dark mode
            : Colors.white, // Warna light mode
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // Border ungu tetap ada di kedua mode
          color: const Color(0xFF6B4EFF).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4EFF), // Judul tetap ungu di kedua mode
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              // Warna teks menyesuaikan mode
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : const Color(0xFF1A1B1E),
            ),
          ),
        ],
      ),
    );
  }
}
