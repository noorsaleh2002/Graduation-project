class FileModel {
  String? id;
  String? title;
  String? description;
  int? pages;
  String? language;
  String? fileurl;
  String? category;
  String? coverUrl;

  FileModel(
      {this.id,
      this.title,
      this.description,
      this.pages,
      this.language,
      this.fileurl,
      this.category,
      this.coverUrl});

  FileModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["pages"] is int) {
      pages = json["pages"];
    }
    if (json["language"] is String) {
      language = json["language"];
    }
    if (json["coverUrl"] is String) {
      coverUrl = json["coverUrl"];
    }
    if (json["bookUrl"] is String) {
      fileurl = json["bookUrl"];
    }
    if (json["categoryd"] is String) {
      category = json["category"];
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["description"] = description;
    _data["pages"] = pages;
    _data["language"] = language;
    _data["bookUrl"] = fileurl;
    _data["category"] = category;
    _data["coverUrl"] = coverUrl;
    return _data;
  }
}
