import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../services/ai_schedule_service.dart';
import '../models/task_model.dart';
import 'task_input_screen.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleService>(context);

    final sortedTasks = List<TaskModel>.from(scheduleProvider.tasks);
    sortedTasks.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: const Color(0xFFFFD700)),
            const SizedBox(width: 8),
            const Text('SCHEDULE RESOLVER'),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (aiService.currentAnalysis != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  border: Border.all(color: const Color(0xFF1A1A1A), width: 3.0),
                  boxShadow: const [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                ),
                child: Column(
                  children: [
                    const Text(
                      'RECOMMENDATION READY',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: const BoxDecoration(
                        boxShadow: [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                          foregroundColor: const Color(0xFF1A1A1A),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendationScreen())),
                        child: const Text('VIEW RESULTS', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
              child: sortedTasks.isEmpty
                  ? const Center(child: Text('NO TASKS LOGGED', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)))
                  : ListView.separated(
                itemCount: sortedTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(color: const Color(0xFF1A1A1A), width: 3.0),
                      boxShadow: const [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                    ),
                    child: Row(
                      children: [
                        Container(width: 8, height: 80, color: const Color(0xFFFFD700)),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(task.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                            subtitle: Text(
                              "${task.category.toUpperCase()} | ${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFF1A1A1A), size: 32),
                              onPressed: () => scheduleProvider.removeTask(task.id),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (sortedTasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                  ),
                  child: ElevatedButton(
                    onPressed: aiService.isLoading ? null : () => aiService.analyzeSchedule(scheduleProvider.tasks),
                    child: aiService.isLoading ? const CircularProgressIndicator(color: Color(0xFFFFD700)) : const Text('RESOLVE CONFLICTS'),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: const Color(0xFF1A1A1A),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
          ),
          elevation: 0,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskInputScreen())),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}