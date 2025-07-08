// class SearchResult {
//   final String id;
//   final double score;
//   final String paragraph;
//   final String topic;

//   SearchResult({required this.id, required this.score, required this.paragraph, required this.topic});

//   factory SearchResult.fromJson(Map<String, dynamic> json) {
//     return SearchResult(
//       id: json['id'] as String,
//       score: (json['score'] as num).toDouble(),
//       paragraph: json['paragraph'] as String,
//       topic: json['metadata']['topic'] as String,
//     );
//   }
// } 