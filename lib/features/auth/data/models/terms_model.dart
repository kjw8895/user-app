class TermsModel {
  final int id;
  final Map<String, dynamic> type;
  final String resourceUrl;

  TermsModel({
    required this.id,
    required this.type,
    required this.resourceUrl,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      id: json['id'] as int,
      type: json['type'] as Map<String, dynamic>,
      resourceUrl: json['resourceUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'resourceUrl': resourceUrl,
    };
  }
} 