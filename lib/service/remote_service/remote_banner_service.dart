// remote_banner.dart
import 'package:http/http.dart' as http;
import 'package:pustakaloka/const.dart';

class RemoteBannerService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/banners';

  Future<dynamic> get() async {
    var response = await client.get(
      Uri.parse('$remoteUrl?populate=image')
    );
    return response;
  }
}
