import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class LocationService{
  final String key="AIzaSyD8ToMfvTbURNMAawN1DqIE8Sf5MLtTL-0";

  Future<String> getPlaceId(String input) async {
    final String url='https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response= await http.get(Uri.parse(url));
    var json= convert.jsonDecode(response.body);
    var placeId= json['candidates'][0]['place_id'] as String;
    return placeId;

  }
  //Future<Map<String,dynamic>> getPlace(String input) async {
   // final placeId= await getPlaceId(input);
   // final String url='https://maps.googleapis.com/maps/api/place/findplacefromtext/json?placeId=$placeId&key=$key';
    //var response= await http.get(Uri.parse(url));
    //var json= convert.jsonDecode(response.body);
   // var results= json['result'] as Map<String,dynamic>;
   // print('helloo');
   // return results;
 // }

}