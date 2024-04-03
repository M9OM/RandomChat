
import '../models/lang_model.dart';

class Languages {
  Languages._();

  static List<LanguageModel> languages = [
    const LanguageModel(code: 'en', value: 'english'),
    const LanguageModel(code: 'ar', value: 'arabic'),
  ];
}
