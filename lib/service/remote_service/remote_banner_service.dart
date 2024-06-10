import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';

class RemoteBannerService {
  final http.Client _client = http.Client();
  final String _remoteUrl = '$baseUrl/api/banners';

  Future<http.Response> get() async {
    try {
      final http.Response response = await _client.get(
        Uri.parse('$_remoteUrl?populate=image'),
      );
      return response;
    } catch (e) {
      print('Error occurred: $e');
      rethrow; // rethrow the exception for higher-level error handling
    }
  }

  void close() {
    _client.close(); // close the client when it's no longer needed
  }
}
