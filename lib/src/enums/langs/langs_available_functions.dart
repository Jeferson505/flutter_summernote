import 'package:flutter_summernote/src/enums/langs/langs_available.dart';

String langToString(AllLangsAvailable lang) {
  String language = lang.name;

  if (lang.name.length == 4) {
    return "${language.substring(0, 2)}-${language.substring(2)}";
  }

  return "${language.substring(0, 2)}-${language.substring(2, 4)}-${language.substring(4)}";
}
