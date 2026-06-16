import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monitoring_faskes_dinkes/models/facility_model.dart';
import 'package:monitoring_faskes_dinkes/models/history_model.dart';
import 'package:monitoring_faskes_dinkes/models/hospital_model.dart';
import 'package:monitoring_faskes_dinkes/models/notification_model.dart';
import 'package:monitoring_faskes_dinkes/models/profile_model.dart';
import 'package:monitoring_faskes_dinkes/models/report_model.dart';
import '../models/dashboard_model.dart';
import '../utils/api_constant.dart';
import 'auth_service.dart';

class ApiService {
  static Future<DashboardModel> getDashboard() async {
    /// AMBIL TOKEN
    String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/dinkes/dashboard"),

      headers: {
        "Accept": "application/json",

        /// BEARER TOKEN
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    return DashboardModel.fromJson(data);
  }

  static Future<List<HospitalData>> getHospitals() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/dinkes/hospitals"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = HospitalModels.fromJson(data);

        return result.data;
      } else {
        throw Exception("Gagal mengambil data rumah sakit");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<DetailHospitalModel> getDetailHospital(int id) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/dinkes/hospitals/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      return DetailHospitalModel.fromJson(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Facility>> getFacilities(
    int hospitalId, {
    String? status,
  }) async {
    try {
      String? token = await AuthService.getToken();

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}/dinkes/hospitals/$hospitalId/facilities",
      ).replace(queryParameters: status != null ? {'status': status} : null);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data fasilitas');
      }

      final data = jsonDecode(response.body);

      final result = FacilityResponse.fromJson(data);
      print(result);

      return result.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // services/api_service.dart

  static Future<DetailFacilityData> getDetailFacility({
    required int hospitalId,
    required int facilityId,
  }) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}/dinkes/hospitals/$hospitalId/facilities/$facilityId",
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = DetailFacilityModel.fromJson(data);

        return result.data;
      } else {
        throw Exception("Gagal mengambil detail fasilitas");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<ReportModel> getReport({String period = '7days'}) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/dinkes/reports?period=$period"),

        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return ReportModel.fromJson(data);
      } else {
        throw Exception("Gagal mengambil laporan");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<HistoryItem>> getHistory({String? facility}) async {
    try {
      String? token = await AuthService.getToken();
      Uri uri = Uri.parse("${ApiConstant.baseUrl}/dinkes/histories");

      // QUERY PARAM
      uri = uri.replace(
        queryParameters: {
          if (facility != null &&
              facility.isNotEmpty &&
              facility != "Semua Fasilitas")
            "facility": facility,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = HistoryResponse.fromJson(jsonDecode(response.body));

        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<ProfileModel?> getProfile() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/dinkes/profile"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return ProfileModel.fromJson(json);
      } else {
        throw Exception(
          'Gagal mengambil profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil profile: $e');
    }
  }

  static Future<List<NotificationModel>> getNotifications(String filter) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}/dinkes/notifications"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      final List list = data['data'];

      return list.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> readNotification(int id) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/dinkes/notifications/$id/read'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal update notifikasi');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> getUnreadNotificationCount() async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/dinkes/notifications/unread/count'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      return data['count'];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
