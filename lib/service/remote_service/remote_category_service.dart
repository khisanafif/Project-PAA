import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';

class RemoteCategoryService {
  final http.Client client = http.Client();

  Future<dynamic> get() async {
    final remoteUrl = '$baseUrl/api/categories';
    final response = await client.get(Uri.parse('$remoteUrl?populate=image'));
    return response;
  }
}
