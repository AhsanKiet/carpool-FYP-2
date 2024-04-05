
class PlacesResponse {
  double lat = 0;
  double lng = 0;
  String name = '';

  PlacesResponse(double lat, double lng, String name) {
    this.lat = lat;
    this.lng = lng;
    this.name = name;
  }

  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return PlacesResponse(
      json['geometry']['location']['lat'] as double,
      json['geometry']['location']['lng'] as double,
      json['name'] as String,
    );
  }
}
