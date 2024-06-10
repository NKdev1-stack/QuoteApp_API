import 'dart:convert';
/// q : "High thoughts must have high language."
/// a : "Aristophanes"
/// c : "38"
/// h : "<blockquote>&ldquo;High thoughts must have high language.&rdquo; &mdash; <footer>Aristophanes</footer></blockquote>"

MtQuotes mtQuotesFromJson(String str) => MtQuotes.fromJson(json.decode(str));
String mtQuotesToJson(MtQuotes data) => json.encode(data.toJson());
class MtQuotes {
  MtQuotes({
      String? q, 
      String? a, 
      String? c, 
      String? h,}){
    _q = q;
    _a = a;
    _c = c;
    _h = h;
}

  MtQuotes.fromJson(dynamic json) {
    _q = json['q'];
    _a = json['a'];
    _c = json['c'];
    _h = json['h'];
  }
  String? _q;
  String? _a;
  String? _c;
  String? _h;
MtQuotes copyWith({  String? q,
  String? a,
  String? c,
  String? h,
}) => MtQuotes(  q: q ?? _q,
  a: a ?? _a,
  c: c ?? _c,
  h: h ?? _h,
);
  String? get q => _q;
  String? get a => _a;
  String? get c => _c;
  String? get h => _h;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['q'] = _q;
    map['a'] = _a;
    map['c'] = _c;
    map['h'] = _h;
    return map;
  }

}