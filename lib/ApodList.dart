import 'dart:convert';

List<ApodList> postFromJson(String str) =>
    List<ApodList>.from(json.decode(str).map((x) => ApodList.fromMap(x)));

class ApodList {
  String copyright;
  String date;
  String explanation;
  String hdurl;
  String media_type;
  String service_version;
  String title;
  String url;
  ApodList({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.media_type,
    required this.service_version,
    required this.title,
    required this.url,
  });
  factory ApodList.fromMap(Map<String, dynamic> json) => ApodList(
        copyright: json["copyright"].toString(),
        date: json["date"].toString(),
        explanation: json["explanation"].toString(),
        hdurl: json["hdurl"].toString(),
        media_type: json["media_type"].toString(),
        service_version: json["service_version"].toString(),
        title: json["title"].toString(),
        url: json["url"].toString(),
      );
}
