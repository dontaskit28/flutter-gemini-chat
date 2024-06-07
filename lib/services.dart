import 'package:google_generative_ai/google_generative_ai.dart';

class APIService {
  final String _apiKey = "AIzaSyDj36B_Y_ThTzbU2IDDAWeR1t3Q8rtRMy0";
  GenerativeModel? _model;

  void initialize() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String?> generateText({required String prompt}) async {
    if (_model == null) {
      initialize();
    }
    List<Content> content = [Content.text(prompt)];
    GenerateContentResponse response = await _model!.generateContent(content);
    return response.text;
  }
}
