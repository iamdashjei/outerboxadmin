import "dart:async";
import "dart:io";

import "package:http/http.dart" as http;
import "package:outerboxadmin/src/utils/constants.dart";

import "api_exceptions.dart";

class ApiProvider {
  static Future<http.Response> login(String url, String email, String password) async {
    http.Response responseJson;
    var body = new Map<String, dynamic>();
    body["client_secret"] = CLIENT_SECRET_PROD;
    body["client_id"] = CLIENT_ID;
    body["grant_type"] = GRANT_TYPE;
    body["username"] = email;
    body["password"] = password;

    try {
      http.Response response = await http.post(PROD_URL + url,
        body: body,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  static Future<http.Response> get(String url, String token) async {
    http.Response responseJson;
    var header = new Map<String, String>();
    header["Accept"] = "application/json";
    header["Content-Type"] = "application/json";
    header["token"] = token;
    // header["Authorization"] = token;

    try {
      http.Response response = await http.get(url,
        headers: header,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  static http.Response _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 403:
        throw InvalidInputException(response.body);
      case 500:
      default:
        throw FetchDataException(
            "Error occurred while Communication with Server with StatusCode : ${response.statusCode}");
    }
  }
}
