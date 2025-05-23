import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_request.dart';
import 'package:course_dilaundry/config/app_response.dart';
import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ShopDatasource {
  static Future<Either<Failure, Map>> readRecommendationLimit() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/recommendation/limit');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(url, headers: AppRequest.header(token));
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> searchByCity(String name) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/search/city/$name');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(url, headers: AppRequest.header(token));
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }
}
