// pages/report_page.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_faskes_dinkes/models/report_model.dart';
import 'package:monitoring_faskes_dinkes/services/api_service.dart';
import 'package:monitoring_faskes_dinkes/widgets/reusable_bottom_nav.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportModel? report;

  bool isLoading = true;

  String selectedPeriod = '7days';

  @override
  void initState() {
    super.initState();
    getReport();
  }

  Future<void> getReport() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await ApiService.getReport(period: selectedPeriod);

      setState(() {
        report = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      bottomNavigationBar: const ReusableBottomNav(selected: 2),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00BFFF),
        automaticallyImplyLeading: false,
        title: const Text(
          "Laporan Ketersediaan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  /// HEADER
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),

                    child: Column(
                      children: [
                        /// DROPDOWN FILTER
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Periode',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(66, 221, 222, 223),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPeriod,
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(16),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'today',
                                      child: Text('Hari Ini'),
                                    ),
                                    DropdownMenuItem(
                                      value: '7days',
                                      child: Text('7 Hari Terakhir'),
                                    ),
                                    DropdownMenuItem(
                                      value: '30days',
                                      child: Text('30 Hari Terakhir'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedPeriod = value;
                                      });

                                      getReport();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// BODY
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// SUMMARY CARD
                          Row(
                            children: [
                              Expanded(
                                child: buildSummaryCard(
                                  "Total Rumah\nSakit",
                                  report!.data.summary.totalHospital.toString(),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: buildSummaryCard(
                                  "Total Fasilitas",
                                  report!.data.summary.totalFacility.toString(),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: buildSummaryCard(
                                  "Rata-rata\nKetersediaan",
                                  "${report!.data.summary.averagePercentage}%",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// GRAFIK
                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: const Color.fromARGB(66, 221, 222, 223),

                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),

                                  blurRadius: 10,

                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  "Grafik Ketersediaan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                SizedBox(
                                  height: 250,

                                  child: LineChart(
                                    LineChartData(
                                      minY: 0,
                                      maxY: 100,

                                      lineTouchData: LineTouchData(
                                        touchTooltipData: LineTouchTooltipData(
                                          tooltipRoundedRadius: 12,

                                          getTooltipItems: (spots) {
                                            return spots.map((spot) {
                                              return LineTooltipItem(
                                                "${spot.y.toInt()}%",
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),

                                      gridData: FlGridData(
                                        show: true,

                                        horizontalInterval: 25,

                                        drawVerticalLine: false,

                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey.shade200,

                                            strokeWidth: 1,
                                          );
                                        },
                                      ),

                                      borderData: FlBorderData(show: false),

                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),

                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),

                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,

                                            interval: 25,

                                            reservedSize: 35,

                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                "${value.toInt()}%",

                                                style: TextStyle(
                                                  color: Colors.grey.shade600,

                                                  fontSize: 11,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,

                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();

                                              if (index >=
                                                  report!.data.graph.length) {
                                                return const SizedBox();
                                              }

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),

                                                child: Text(
                                                  report!
                                                      .data
                                                      .graph[index]
                                                      .date,

                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,

                                                    fontSize: 11,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: List.generate(
                                            report!.data.graph.length,
                                            (index) {
                                              return FlSpot(
                                                index.toDouble(),

                                                report!
                                                    .data
                                                    .graph[index]
                                                    .percentage
                                                    .toDouble(),
                                              );
                                            },
                                          ),

                                          isCurved: true,

                                          color: const Color(0xFF16A34A),

                                          barWidth: 3,

                                          isStrokeCapRound: true,

                                          dotData: FlDotData(
                                            show: true,

                                            getDotPainter:
                                                (
                                                  spot,
                                                  percent,
                                                  barData,
                                                  index,
                                                ) {
                                                  return FlDotCirclePainter(
                                                    radius: 3.5,

                                                    color: const Color(
                                                      0xFF16A34A,
                                                    ),

                                                    strokeWidth: 1.5,

                                                    strokeColor: Colors.white,
                                                  );
                                                },
                                          ),

                                          belowBarData: BarAreaData(
                                            show: true,

                                            color: const Color(
                                              0xFF16A34A,
                                            ).withOpacity(0.08),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// EXPORT
                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),

                                  blurRadius: 10,

                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  "Ekspor Laporan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: buildExportButton(
                                        title: "PDF",
                                        color: Colors.green,
                                        icon: Icons.picture_as_pdf,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: buildExportButton(
                                        title: "Excel",
                                        color: Colors.blue,
                                        icon: Icons.table_chart,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: buildExportButton(
                                        title: "CSV",
                                        color: Colors.orange,
                                        icon: Icons.description,
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
                ],
              ),
      ),
    );
  }

  Widget buildSummaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),

      decoration: BoxDecoration(
        color: const Color.fromARGB(66, 221, 222, 223),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExportButton({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      height: 52,

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: color.withOpacity(0.2)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 18, color: color),

          const SizedBox(width: 6),

          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
