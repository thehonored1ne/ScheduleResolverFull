import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/schedule_analysis.dart';
import '../models/task_model.dart';

class AiScheduleService extends ChangeNotifier {
  ScheduleAnalysis? _currentAnalysis;
  bool _isLoading = false;
  String? _errorMessage;

  ScheduleAnalysis? get currentAnalysis => _currentAnalysis;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String _apiKey = 'your_api_key';

  Future<void> analyzeSchedule(List<TaskModel> tasks) async {
    if (_apiKey.isEmpty || tasks.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final tasksJson = jsonEncode(tasks.map((t) => t.toJson()).toList());

      // BUG FIX: Commented out the old prompt that allowed markdown.
      /*
      final prompt = '''
        You are an expert student scheduling assistant.
        Analyze these tasks in JSON format: $tasksJson

        Provide exactly 4 sections using these exact headers:
        ### Detected Conflicts
        ### Ranked Tasks
        ### Recommended Schedule
        ### Explanation
      ''';
      */

      // BUG FIX: Previous prompt was not strict enough — Gemini still returned
      // asterisks (*) for bold/bullets despite the instruction. Fixed by:
      // 1. Explicitly forbidding bold formatting (double asterisks **text**).
      // 2. Telling the model to ONLY use "-" or "1." and nothing else for lists.
      // 3. Adding a hard rule: "Do not use any Markdown formatting whatsoever."
      final prompt = '''
        You are an expert student scheduling assistant. 
        Analyze these tasks in JSON format: $tasksJson
        
        Provide exactly 4 sections using these exact headers:
        [Detected Conflicts]
        [Ranked Tasks]
        [Recommended Schedule]
        [Explanation]
        
        STRICT FORMATTING RULES — follow these exactly:
        - Do NOT use any Markdown formatting whatsoever.
        - Do NOT use asterisks (*) for any reason — not for bullets, not for bold text.
        - Do NOT use hashtags (#) for any reason.
        - Do NOT use double asterisks (**) for bold or emphasis.
        - For lists, use only a hyphen and space (- ) or numbered format (1. 2. 3.).
        - For emphasis, use UPPERCASE instead of asterisks.
        - Plain text only. Human-readable. No symbols except hyphens and numbers for lists.
        - Do NOT display or mention any task IDs (UUIDs or any alphanumeric identifiers). Refer to tasks by their name only.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null) {
        throw Exception('AI returned empty response');
      }

      _currentAnalysis = _parseResponse(text);
    } catch (e) {
      _errorMessage = 'Failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ScheduleAnalysis _parseResponse(String fullText) {
    String conflicts = "";
    String rankedTasks = "";
    String recommendedSchedule = "";
    String explanation = "";

    // BUG FIX: Commented out the hashtag-based parsing logic.
    /*
    final sections = fullText.split('###');

    for (var section in sections) {
      final cleanSection = section.trim();
      if (cleanSection.startsWith('Detected Conflicts')) {
        conflicts = cleanSection.replaceFirst('Detected Conflicts', '').trim();
      } else if (cleanSection.startsWith('Ranked Tasks')) {
        rankedTasks = cleanSection.replaceFirst('Ranked Tasks', '').trim();
      } else if (cleanSection.startsWith('Recommended Schedule')) {
        recommendedSchedule = cleanSection.replaceFirst('Recommended Schedule', '').trim();
      } else if (cleanSection.startsWith('Explanation')) {
        explanation = cleanSection.replaceFirst('Explanation', '').trim();
      }
    }
    */

    final sections = fullText.split('[');

    for (var section in sections) {
      final cleanSection = section.trim();
      if (cleanSection.startsWith('Detected Conflicts]')) {
        conflicts = cleanSection.replaceFirst('Detected Conflicts]', '').trim();
      } else if (cleanSection.startsWith('Ranked Tasks]')) {
        rankedTasks = cleanSection.replaceFirst('Ranked Tasks]', '').trim();
      } else if (cleanSection.startsWith('Recommended Schedule]')) {
        recommendedSchedule = cleanSection.replaceFirst('Recommended Schedule]', '').trim();
      } else if (cleanSection.startsWith('Explanation]')) {
        explanation = cleanSection.replaceFirst('Explanation]', '').trim();
      }
    }

    return ScheduleAnalysis(
      conflicts: conflicts,
      rankedTasks: rankedTasks,
      recommendedSchedule: recommendedSchedule,
      explanation: explanation,
    );
  }
}