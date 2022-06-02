



import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class OrderController extends GetxController {
  var isDataSubmitting = false.obs;
  var isDataReadingCompleted = false.obs;
  static var client = http.Client();
  final box = GetStorage();

  Future<Map<String, dynamic>> order(String paymentMethod, paymentMethodTitle, firstName, lastName,
      address, city, state, postcode, country, email, phone, lineItemModel) async {
    Map<String, dynamic> result;
    isDataSubmitting.value = true;
    Map<dynamic, dynamic> dataBody = {
        "payment_method": paymentMethod,
        "payment_method_title": paymentMethodTitle,
        "billing": {
          "first_name": firstName,
          "last_name": lastName,
          "address_1": address,
          "city": city,
          "state": state,
          "postcode": postcode,
          "country": country,
          "email": email,
          "phone": phone,
        },
      "line_items": lineItemModel
    };
    String userName = "ck_62b64e6a92c2c362330491e2044f7e49414ca6c9";
    String password = "cs_6dab149b45ec92999adfc637192d53b3f589d41a";
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$userName:$password'));

    var response = await client.post(Uri.parse("https://musing-gould.18-141-157-112.plesk.page/wp-json/wc/v3/orders"),
        headers: { 'Authorization': basicAuth },
        body: jsonEncode(dataBody));

    if (response.statusCode == 200 || response.statusCode == 201) {
      isDataSubmitting.value = false;
      Map<String, dynamic> responseData = jsonDecode(response.body);
      isDataReadingCompleted.value = true;
      result = {'status': true, 'id': responseData['id'], 'paymentStatus': responseData['status'], 'order_key': responseData['order_key']};
    } else {
      isDataSubmitting.value = false;
      isDataReadingCompleted.value = true;
      result = {'status': false, 'message': "Server Error!\nFailed to finish the lesson"};
    }
    return result;
  }
}