// pages/detail_hospital.dart

import 'package:flutter/material.dart';
import 'package:monitoring_faskes_dinkes/models/hospital_model.dart';
import 'package:monitoring_faskes_dinkes/pages/facilities_page.dart';
import 'package:monitoring_faskes_dinkes/pages/hospital_page.dart';
import 'package:monitoring_faskes_dinkes/widgets/reusable_bottom_nav.dart';

class DetailHospitalPage extends StatelessWidget {
  final DetailHospitalData data;

  const DetailHospitalPage({super.key, required this.data});

  Color getStatusColor(String status) {
    switch (status) {
      case 'tersedia':
        return Colors.green;

      case 'terbatas':
        return Colors.orange;

      case 'penuh':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String getStatusName(String status) {
    switch (status) {
      case 'tersedia':
        return 'Tersedia';

      case 'terbatas':
        return 'Terbatas';

      case 'penuh':
        return 'Penuh';

      default:
        return '';
    }
  }

  IconData getIcon(String icon) {
    switch (icon) {
      case 'baby':
        return Icons.child_care;

      case 'activity':
        return Icons.monitor_heart;

      case 'heart':
        return Icons.favorite;

      case 'stethoscope':
        return Icons.medical_services;

      case 'hospital':
        return Icons.local_hospital;

      case 'home':
        return Icons.home;

      case 'shield':
        return Icons.shield;

      case 'scissors':
        return Icons.content_cut;

      case 'plus':
        return Icons.add;

      case 'bed':
        return Icons.bed;

      default:
        return Icons.medical_information;
    }
  }

  Color getCardColor(String color) {
    switch (color) {
      case 'blue':
        return Colors.blue;

      case 'green':
        return Colors.green;

      case 'orange':
        return Colors.orange;

      case 'purple':
        return Colors.purple;

      case 'cyan':
        return Colors.cyan;

      case 'lime':
        return Colors.lime;

      case 'yellow':
        return Colors.amber;

      case 'pink':
        return Colors.pink;

      case 'indigo':
        return Colors.indigo;

      case 'red':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospital = data.hospital;
    final summary = data.summary;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      bottomNavigationBar: const ReusableBottomNav(selected: 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00BFFF),

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HospitalPage()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),

        centerTitle: true,

        title: const Text(
          "Detail Rumah sakit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

            child: Column(
              children: [
                /// CARD
                Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,

                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: const Icon(
                          Icons.local_hospital,
                          size: 34,
                          color: Color(0xFF0D47A1),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hospital.name,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  margin: const EdgeInsets.only(top: 23),

                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      summary.status,
                                    ).withOpacity(0.12),

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    getStatusName(summary.status).toUpperCase(),

                                    style: TextStyle(
                                      color: getStatusColor(summary.status),

                                      fontWeight: FontWeight.bold,

                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                hospital.address,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// SUMMARY
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoCard("Total Unit", summary.totalUnit),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: buildInfoCard(
                          "Tersedia",
                          summary.totalAvailable,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  buildInfoCard(
                    "Persentase Ketersediaan",
                    "${summary.percentage}%",
                    full: true,
                  ),

                  const SizedBox(height: 22),

                  /// TITLE ALERT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Ringkasan Fasilitas",

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FacilitiesPage(hospital: hospital),
                            ),
                          );
                        },

                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  GridView.builder(
                    itemCount: data.facilities.length,

                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,

                          mainAxisSpacing: 12,

                          crossAxisSpacing: 12,

                          childAspectRatio: 0.85,
                        ),

                    itemBuilder: (context, index) {
                      final item = data.facilities[index];

                      return Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),

                              blurRadius: 8,

                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              width: 42,
                              height: 42,

                              decoration: BoxDecoration(
                                color: getCardColor(
                                  item.facilityType.color,
                                ).withOpacity(0.12),

                                borderRadius: BorderRadius.circular(14),
                              ),

                              child: Icon(
                                getIcon(item.facilityType.icon),

                                color: getCardColor(item.facilityType.color),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              item.facilityType.name,

                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${item.percentage}%",

                              style: TextStyle(
                                color: getStatusColor(item.status),

                                fontWeight: FontWeight.bold,

                                fontSize: 13,
                              ),
                            ),
                          ],
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
    );
  }

  Widget buildInfoCard(String title, String value, {bool full = false}) {
    return Container(
      width: full ? double.infinity : null,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 8,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            title,

            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
