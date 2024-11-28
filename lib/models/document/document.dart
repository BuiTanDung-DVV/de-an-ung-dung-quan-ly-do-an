class Document {
  final int? id;
  late final String advisor;
  late final String author;
  late final int graduationYear;
  late final String type;
  late final String specialization;
  late final String abstractText;
  late final String language;
  late final String publisher;
  late final String title;
  late final String keywords;
  late final String pdfFileName;
  late final String pdfUrl;

  Document({
    this.id,
    required this.advisor,
    required this.author,
    required this.graduationYear,
    required this.type,
    required this.specialization,
    required this.abstractText,
    required this.language,
    required this.publisher,
    required this.title,
    required this.keywords,
    required this.pdfFileName,
    required this.pdfUrl,
  });

  factory Document.fromMap(Map<dynamic, dynamic> documentMap) {
    return Document(
      id: documentMap['id'] as int?,
      advisor: documentMap['advisor'] as String,
      author: documentMap['author'] as String,
      graduationYear: documentMap['graduationYear'] as int,
      type: documentMap['type'] as String,
      specialization: documentMap['specialization'] as String,
      abstractText: documentMap['abstractText'] as String,
      language: documentMap['language'] as String,
      publisher: documentMap['publisher'] as String,
      title: documentMap['title'] as String,
      keywords: documentMap['keywords'] as String,
      pdfFileName: documentMap['pdfFileName'] as String,
      pdfUrl: documentMap['pdfUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advisor': advisor,
      'author': author,
      'graduationYear': graduationYear,
      'type': type,
      'specialization': specialization,
      'abstractText': abstractText,
      'language': language,
      'publisher': publisher,
      'title': title,
      'keywords': keywords,
      'pdfFileName': pdfFileName,
      'pdfUrl': pdfUrl,
    };
  }
}
