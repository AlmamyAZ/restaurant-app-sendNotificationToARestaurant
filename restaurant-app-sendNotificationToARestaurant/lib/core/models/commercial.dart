class Commercial {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? externalLink;
  final String? externalLinkFallback;
  final String? imageUrl;
  final String? imageHash;
  final DateTime? createdAt;

  Commercial({
    this.id,
    this.title,
    this.subtitle,
    this.externalLink,
    this.externalLinkFallback,
    this.imageUrl,
    this.imageHash,
    this.createdAt,
  });

  Commercial.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        title = json['title'],
        subtitle = json['subtitle'],
        externalLink = json['externalLink'],
        externalLinkFallback = json['externalLinkFallback'],
        imageUrl = json['imageUrl1000'],
        imageHash = json['imageHash'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['externalLink'] = this.externalLink;
    data['externalLinkFallback'] = this.externalLinkFallback;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    data['imageHash'] = this.imageHash;
    return data;
  }
}
