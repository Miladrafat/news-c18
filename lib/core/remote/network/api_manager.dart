import 'package:dio/dio.dart';

class ApiManager {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://newsapi.org"
    )
  );

  getSources(){
    dio.get("/v2/top-headlines/sources",queryParameters: {
      "apiKey":"d3e16e322c2e4c00b4b4f4967c290a7f"
    });
  }
}