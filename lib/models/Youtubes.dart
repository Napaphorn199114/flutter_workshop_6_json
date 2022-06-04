class Youtubes {
  List<Youtube> youtubes;
  bool error;
  String errorMsg;

  Youtubes({
    required this.youtubes,
    required this.error,
    required this.errorMsg,
  });

  factory Youtubes.fromJson(Map<String, dynamic> json) => new Youtubes(
        youtubes: new List<Youtube>.from(
            json["youtubes"].map((x) => Youtube.fromJson(x))),
        error: json["error"],
        errorMsg: json["error_msg"],
      );
}

class Youtube {
  String id;
  String title;
  String subtitle;
  String avatarImage;
  String youtubeImage;

  Youtube({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.avatarImage,
    required this.youtubeImage,
  });

  factory Youtube.fromJson(Map<String, dynamic> json) => new Youtube(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        avatarImage: json["avatar_image"],
        youtubeImage: json["youtube_image"],
      );
}