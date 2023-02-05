import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_record/data/model/history.dart';

import '../../config/api.dart';
import '../../config/app_color.dart';
import '../../config/app_request.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = '${Api.history}analysis.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });

    if (responseBody == null) {
      return {
        'today': 0.0,
        'yesterday': 0.0,
        'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'month': {
          'income': 0.0,
          'outcome': 0.0,
        }
      };
    }

    return responseBody;
  }

  static Future<bool> add(
    String idUser,
    String date,
    String type,
    String details,
    String total,
  ) async {
    String url = '${Api.history}add.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      Fluttertoast.showToast(
          msg: "Berhasil Tambah History",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColor.green,
          textColor: AppColor.white,
          fontSize: 16.0);
    } else {
      if (responseBody['message'] == 'date') {
        Fluttertoast.showToast(
            msg: "History dengan tanggal tersebut sudah pernah dibuat",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColor.chart,
            textColor: AppColor.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Berhasil Tambah History",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColor.red,
            textColor: AppColor.white,
            fontSize: 16.0);
      }
    }

    return responseBody['success'];
  }

  static Future<List<History>> getIncomeOutcome(String idUser, String type) async {
    String url = '${Api.history}income_outcome.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'type': type,
    });

    if (responseBody == null) return [];
    
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }

    return [];
  }

  static Future<List<History>> getIncomeOutcomeSearch(String idUser, String type, String date) async {
    String url = '${Api.history}income_outcome_search.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'type': type,
      'date': date,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }

    return [];
  }

}
