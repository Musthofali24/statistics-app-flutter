import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../widgets/theme_toggle.dart';

enum DataType { sampel, populasi }

enum ChartType { bar, barCumulative, pie }

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _dataController = TextEditingController();
  late PageController _pageController;
  int _currentPage = 0;
  Map<String, dynamic> results = {};
  List<double> data = [];
  DataType selectedDataType = DataType.sampel;
  ChartType selectedChartType = ChartType.bar;

  // List warna untuk visualisasi
  final List<Color> dataColors = [
    const Color(0xFF6B4EFF), // Ungu
    const Color(0xFF4ECDC4), // Tosca
    const Color(0xFFFF6B6B), // Merah Muda
    const Color(0xFFFFBE0B), // Kuning
    const Color(0xFF95D5B2), // Hijau Mint
    const Color(0xFFBB86FC), // Ungu Muda
    const Color(0xFFFF8906), // Orange
    const Color(0xFF4EA8DE), // Biru
    // Tambahkan warna lain jika diperlukan
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void calculateStatistics() {
    if (_dataController.text.trim().isEmpty) {
      showErrorDialog('Data Kosong', 'Mohon isi data terlebih dahulu.');
      return;
    }

    try {
      data = _dataController.text
          .replaceAll(' ', '')
          .split(',')
          .where((e) => e.isNotEmpty)
          .map((e) {
        final number = double.tryParse(e.trim());
        if (number == null) {
          throw const FormatException('Invalid number format');
        }
        return number;
      }).toList();

      // Tambahkan validasi jumlah data
      if (data.isEmpty) {
        showErrorDialog('Data Kosong', 'Mohon isi data terlebih dahulu.');
        return;
      }

      // Validasi minimal 2 data
      if (data.length < 2) {
        showErrorDialog('Data Kurang',
            'Minimal masukkan 2 data untuk melakukan perhitungan statistik.\n\nContoh: 6, 7');
        return;
      }

      data.sort();

      setState(() {
        // Perhitungan dasar yang sama untuk keduanya
        results = {
          'mean': calculateMean(),
          'median': calculateMedian(),
          'modus': calculateMode(),
          'q1': calculateQ1(),
          'q2': calculateMedian(),
          'q3': calculateQ3(),
          'range': calculateRange(),
          'min': data.first,
          'max': data.last,
          'sum': calculateSum(),
          'count': data.length,
          'dataType':
              selectedDataType == DataType.sampel ? 'Sampel' : 'Populasi',
        };

        // Perhitungan khusus berdasarkan tipe data
        if (selectedDataType == DataType.sampel) {
          // Perhitungan untuk Sampel
          double sampleVariance = calculateSampleVariance();
          double sampleStdDev = sqrt(sampleVariance);

          results.addAll({
            'variance': sampleVariance,
            'stdDev': sampleStdDev,
            'standardError': sampleStdDev / sqrt(data.length),
            'confidenceInterval95': calculateConfidenceInterval95(),
            'degreesOfFreedom': data.length - 1,
          });
        } else {
          // Perhitungan untuk Populasi
          double populationVariance = calculatePopulationVariance();
          double populationStdDev = sqrt(populationVariance);

          results.addAll({
            'variance': populationVariance,
            'stdDev': populationStdDev,
            'populationSize': data.length,
          });
        }
      });
    } catch (e) {
      showErrorDialog('Format Data Salah',
          'Pastikan format data benar.\nContoh: 6, 11, 14, 15');
    }
  }

  // Variansi Populasi (σ²)
  double calculatePopulationVariance() {
    double mean = calculateMean();
    double sumSquaredDiff = data.fold(0.0, (sum, x) => sum + pow(x - mean, 2));
    return sumSquaredDiff / data.length; // dibagi n
  }

  // Variansi Sampel (s²)
  double calculateSampleVariance() {
    double mean = calculateMean();
    double sumSquaredDiff = data.fold(0.0, (sum, x) => sum + pow(x - mean, 2));
    return sumSquaredDiff / (data.length - 1); // dibagi (n-1)
  }

  // Interval Kepercayaan 95%
  String calculateConfidenceInterval95() {
    double mean = calculateMean();
    double standardError = sqrt(calculateSampleVariance()) / sqrt(data.length);
    double marginOfError =
        1.96 * standardError; // Menggunakan z-score 1.96 untuk 95%

    double lowerBound = mean - marginOfError;
    double upperBound = mean + marginOfError;

    return '${lowerBound.toStringAsFixed(2)} - ${upperBound.toStringAsFixed(2)}';
  }

  double calculateMean() {
    return data.reduce((a, b) => a + b) / data.length;
  }

  double calculateMedian() {
    if (data.length % 2 == 0) {
      return (data[data.length ~/ 2 - 1] + data[data.length ~/ 2]) / 2;
    }
    return data[data.length ~/ 2];
  }

  String calculateMode() {
    Map<double, int> frequency = {};
    for (var x in data) {
      frequency[x] = (frequency[x] ?? 0) + 1;
    }

    int maxFreq = frequency.values.reduce((a, b) => a > b ? a : b);
    List<double> modes = frequency.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();

    return '${modes[0]} ( $maxFreq x )';
  }

  double calculateQ1() {
    List<double> lowerHalf = data.sublist(0, data.length ~/ 2);
    return calculateMedianOfList(lowerHalf);
  }

  double calculateQ3() {
    List<double> upperHalf = data.sublist((data.length + 1) ~/ 2);
    return calculateMedianOfList(upperHalf);
  }

  double calculateMedianOfList(List<double> list) {
    if (list.length % 2 == 0) {
      return (list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2;
    }
    return list[list.length ~/ 2];
  }

  double calculateRange() {
    return data.last - data.first;
  }

  double calculateIQR() {
    return calculateQ3() - calculateQ1();
  }

  double calculateSum() {
    return data.reduce((a, b) => a + b);
  }

  Map<double, int> calculateFrequency() {
    Map<double, int> frequency = {};
    for (var value in data) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    return Map.fromEntries(
        frequency.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  Map<double, int> calculateCumulativeFrequency() {
    Map<double, int> frequency = calculateFrequency();
    Map<double, int> cumulative = {};
    int sum = 0;

    for (var entry in frequency.entries) {
      sum += entry.value;
      cumulative[entry.key] = sum;
    }
    return cumulative;
  }

  List<BarChartGroupData> createBarGroups() {
    var frequency = calculateFrequency();
    int index = 0;

    return frequency.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: const Color.fromARGB(255, 78, 214, 255),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  // Perbarui method untuk menghitung persentase
  Map<double, double> calculateFrequencyPercentage() {
    Map<double, int> frequency = calculateFrequency();
    int totalData = data.length;
    Map<double, double> percentages = {};

    for (var entry in frequency.entries) {
      percentages[entry.key] = (entry.value / totalData) * 100;
    }
    return percentages;
  }

  Map<double, double> calculateCumulativePercentage() {
    Map<double, int> cumulative = calculateCumulativeFrequency();
    int totalData = data.length;
    Map<double, double> percentages = {};

    for (var entry in cumulative.entries) {
      percentages[entry.key] = (entry.value / totalData) * 100;
    }
    return percentages;
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF24262B),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B4EFF),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Statistik'),
        actions: const [
          ThemeToggle(), // Pastikan ini Widget, bukan method
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF24262B) // Warna gelap untuk dark mode
                      : Colors.white, // Warna putih untuk light mode
                  borderRadius: BorderRadius.circular(15),
                  border: Theme.of(context).brightness == Brightness.dark
                      ? null // Tidak ada border di dark mode
                      : Border.all(
                          // Border ungu di light mode
                          color: const Color(0xFF6B4EFF).withOpacity(0.3),
                          width: 1.5,
                        ),
                ),
                child: SegmentedButton<DataType>(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFF6B4EFF);
                        }
                        return Colors.transparent;
                      },
                    ),
                    side: WidgetStateProperty.all(BorderSide.none),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                  segments: <ButtonSegment<DataType>>[
                    ButtonSegment<DataType>(
                      value: DataType.sampel,
                      label: Text(
                        'Sampel',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: selectedDataType == DataType.sampel
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary // Warna saat dipilih
                              : Theme.of(context)
                                  .colorScheme
                                  .primary, // Warna saat tidak dipilih
                        ),
                      ),
                    ),
                    ButtonSegment<DataType>(
                      value: DataType.populasi,
                      label: Text(
                        'Populasi',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: selectedDataType == DataType.populasi
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary // Warna saat dipilih
                              : Theme.of(context)
                                  .colorScheme
                                  .primary, // Warna saat tidak dipilih
                        ),
                      ),
                    ),
                  ],
                  selected: {selectedDataType},
                  onSelectionChanged: (Set<DataType> newSelection) {
                    setState(() {
                      selectedDataType = newSelection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Input Section
              const Text(
                'Set Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dataController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 6, 11, 11, 14, 14, 15, 15, 15...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Angka dipisahkan dengan koma yaa',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Button Section
              ElevatedButton(
                onPressed: calculateStatistics,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Hitung'),
              ),
              const SizedBox(height: 24),

              // Results Section
              if (results.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2761),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D3875),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'HASIL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B4EFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                results['dataType'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1.5),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(1.5),
                          },
                          children: [
                            buildRow(
                                'Rata-rata x̄',
                                results['mean']?.toStringAsFixed(2) ?? '-',
                                'Kuartil Q1',
                                results['q1']?.toStringAsFixed(2) ?? '-'),
                            buildRow(
                                'Median x̃',
                                results['median']?.toStringAsFixed(2) ?? '-',
                                'Kuartil Q2',
                                results['q2']?.toStringAsFixed(2) ?? '-'),
                            buildRow(
                                'Modus',
                                results['modus']?.toString() ?? '-',
                                'Kuartil Q3',
                                results['q3']?.toStringAsFixed(2) ?? '-'),
                            buildRow(
                                'Jangkauan',
                                results['range']?.toStringAsFixed(2) ?? '-',
                                'Variansi',
                                results['variance']?.toStringAsFixed(4) ?? '-'),
                            buildRow(
                                'Minimum',
                                results['min']?.toString() ?? '-',
                                'IQR',
                                results['iqr']?.toStringAsFixed(2) ?? '-'),
                            buildRow(
                                'Maksimum',
                                results['max']?.toString() ?? '-',
                                'Standar Deviasi',
                                results['stdDev']?.toStringAsFixed(4) ?? '-'),
                            buildRow(
                                'Interval Kepercayaan 95%',
                                results['confidenceInterval95'] ?? '-',
                                'Jumlah n',
                                results['count']?.toString() ?? '-'),
                            if (selectedDataType == DataType.populasi) ...[
                              buildRow(
                                  'Ukuran Populasi',
                                  results['populationSize']?.toString() ?? '-',
                                  '',
                                  ''),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabel Distribusi Frekuensi
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2761),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D3875),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'TABEL DISTRIBUSI FREKUENSI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 300, // Batasi tinggi maksimal tabel
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: DataTable(
                                columnSpacing: 40, // Tambah spacing antar kolom
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                dataTextStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                columns: const [
                                  DataColumn(
                                    label: SizedBox(
                                      width: 60, // Atur lebar minimum kolom
                                      child: Text('Data'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 40,
                                      child: Text('f'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 60,
                                      child: Text('f(%)'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 40,
                                      child: Text('F'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 60,
                                      child: Text('F(%)'),
                                    ),
                                  ),
                                ],
                                rows: calculateFrequency().entries.map((entry) {
                                  var freq = entry.value;
                                  var cumFreq =
                                      calculateCumulativeFrequency()[entry.key];
                                  var freqPercent =
                                      calculateFrequencyPercentage()[entry.key];
                                  var cumFreqPercent =
                                      calculateCumulativePercentage()[
                                          entry.key];

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            entry.key.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            freq.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '${freqPercent?.toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            cumFreq.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '${cumFreqPercent?.toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                if (results.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2761),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D3875),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'VISUALISASI DATA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  3,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? const Color(0xFF6B4EFF)
                                          : Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 350,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              // Histogram Frekuensi
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Histogram Frekuensi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: _buildChart(ChartType.bar),
                                    ),
                                  ],
                                ),
                              ),
                              // Histogram Kumulatif
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Histogram Frekuensi Kumulatif',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child:
                                          _buildChart(ChartType.barCumulative),
                                    ),
                                  ],
                                ),
                              ),
                              // Pie Chart
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Diagram Lingkaran',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: _buildChart(ChartType.pie),
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(ChartType type) {
    switch (type) {
      case ChartType.bar:
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: calculateFrequency()
                    .values
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() *
                1.2,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Nilai Data',
                  style: TextStyle(color: Colors.white70),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    var freq = calculateFrequency();
                    var data = freq.keys.toList();
                    if (value >= 0 && value < data.length) {
                      return Text(
                        data[value.toInt()].toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'f',
                  style: TextStyle(color: Colors.white70),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 == 0) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 1,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: List.generate(
              calculateFrequency().length,
              (index) {
                var freq = calculateFrequency();
                var entries = freq.entries.toList();
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entries[index].value.toDouble(),
                      color: dataColors[index % dataColors.length],
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              },
            ),
          ),
        );

      case ChartType.barCumulative:
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: calculateCumulativeFrequency()
                    .values
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() *
                1.2,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Nilai Data',
                  style: TextStyle(color: Colors.white70),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    var freq = calculateFrequency();
                    var data = freq.keys.toList();
                    if (value >= 0 && value < data.length) {
                      return Text(
                        data[value.toInt()].toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'FK',
                  style: TextStyle(color: Colors.white70),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 == 0) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 1,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: List.generate(
              calculateCumulativeFrequency().length,
              (index) {
                var cumFreq = calculateCumulativeFrequency();
                var entries = cumFreq.entries.toList();
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entries[index].value.toDouble(),
                      color: dataColors[index % dataColors.length],
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              },
            ),
          ),
        );

      case ChartType.pie:
        return PieChart(
          PieChartData(
            sections: List.generate(
              calculateFrequency().length,
              (index) {
                var freq = calculateFrequency();
                var entries = freq.entries.toList();
                return PieChartSectionData(
                  value: entries[index].value.toDouble(),
                  title: '${entries[index].key}\n(${entries[index].value})',
                  color: dataColors[index % dataColors.length],
                  radius: 95, // Memperbesar radius
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Memperbesar ukuran font
                    fontWeight: FontWeight.bold,
                  ),
                  titlePositionPercentageOffset:
                      0.6, // Mengatur posisi label keluar
                  badgePositionPercentageOffset: 0.5,
                );
              },
            ),
            sectionsSpace: 4, // Menambah jarak antar section
            centerSpaceRadius: 40, // Menambah ruang kosong di tengah
          ),
        );
    }
  }

  TableRow buildRow(
      String label1, String value1, String label2, String value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label1,
            style: const TextStyle(
              color: Colors.white70, // Label dengan opacity 70%
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value1,
            style: const TextStyle(
              color: Colors.white, // Nilai dengan warna putih penuh
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label2,
            style: const TextStyle(
              color: Colors.white70, // Label dengan opacity 70%
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value2,
            style: const TextStyle(
              color: Colors.white, // Nilai dengan warna putih penuh
            ),
          ),
        ),
      ],
    );
  }
}
