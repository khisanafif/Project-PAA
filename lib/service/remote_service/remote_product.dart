import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';

class RemoteProductService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/products';

  Future<dynamic> get() async {
    try {
      var response = await client.get(
        Uri.parse('$remoteUrl?populate=images,tags')
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load products: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  
  Future<dynamic> getByName({required String keyword}) async {
    try {
      var response = await client.get(
        Uri.parse('$remoteUrl?populate=images,tags&filters[name][\$contains]=$keyword')
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load products by name: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> getByCategory({required int id}) async {
    try {
      var response = await client.get(
        Uri.parse('$remoteUrl?populate=images,tags&filters[category][id]=$id')
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load products by category: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
