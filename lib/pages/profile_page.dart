import 'package:flutter/material.dart';
import 'package:monitoring_faskes_dinkes/pages/login_page.dart';
import 'package:monitoring_faskes_dinkes/services/api_service.dart';
import 'package:monitoring_faskes_dinkes/widgets/reusable_bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;

  ProfileModel? profile;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      final result = await ApiService.getProfile();

      setState(() {
        profile = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Keluar"),
          content: const Text("Apakah yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove("token");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF4F7FB),
        bottomNavigationBar: ReusableBottomNav(selected: 5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xffF4F7FB),
        bottomNavigationBar: ReusableBottomNav(selected: 5),
        body: Center(child: Text("Profile gagal dimuat")),
      );
    }

    final user = profile!.data;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      bottomNavigationBar: const ReusableBottomNav(selected: 5),

      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.only(
              top: 55,
              left: 20,
              right: 20,
              bottom: 28,
            ),

            decoration: const BoxDecoration(
              color: Color(0xff0B4A63),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),

            child: Column(
              children: [
                const Text(
                  "Akun",

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    children: [
                      // LOGO
                      Container(
                        width: 58,
                        height: 58,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),

                          color: Colors.grey.shade100,
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),

                          child: const Icon(
                            Icons.local_hospital,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              user.name,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              user.email,

                              style: TextStyle(
                                color: Colors.grey.shade600,

                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xff2E7D32),

                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Text(
                                user.role,

                                style: const TextStyle(
                                  color: Colors.white,

                                  fontSize: 11,

                                  fontWeight: FontWeight.w600,
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

          // ================= MENU =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),

              children: [
                _menuTile(
                  icon: Icons.person_outline,
                  title: "Profil Dinas",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.groups_outlined,
                  title: "Pengguna",
                  badge: "12",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.settings_outlined,
                  title: "Pengaturan",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.notifications_none_outlined,
                  title: "Notifikasi",
                  badge: "3",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                InkWell(
                  borderRadius: BorderRadius.circular(14),

                  onTap: logout,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),

                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 22),

                        SizedBox(width: 14),

                        Text(
                          "Keluar",

                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU TILE =================

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(14),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

        margin: const EdgeInsets.only(bottom: 6),

        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xff4B5563)),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

                decoration: BoxDecoration(
                  color: const Color(0xffE8EEF9),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  badge,

                  style: const TextStyle(
                    color: Color(0xff0B4A63),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(width: 8),

            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
