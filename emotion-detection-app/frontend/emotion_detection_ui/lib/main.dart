import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

void main() {
  runApp(const EmotionDetectionApp());
}

class EmotionDetectionApp extends StatelessWidget {
  const EmotionDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emotion Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EmotionDetectionScreen(),
    );
  }
}

class EmotionDetectionScreen extends StatefulWidget {
  const EmotionDetectionScreen({super.key});

  @override
  State<EmotionDetectionScreen> createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _predictionResult;
  String? _errorMessage;

  // Backend API URL - change this to your backend URL
  static const String apiUrl = 'http://localhost:3000';

  // Emotion colors for the chart
  final Map<String, Color> emotionColors = {
    'joy': Colors.yellow,
    'sadness': Colors.blue,
    'anger': Colors.red,
    'fear': Colors.purple,
    'surprise': Colors.orange,
    'disgust': Colors.green,
    'neutral': Colors.grey,
    'shame': Colors.pink,
  };

  Future<void> _predictEmotion() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _predictionResult = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': _textController.text.trim()}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          _predictionResult = result;
          _isLoading = false;
        });
      } else {
        final error = json.decode(response.body);
        setState(() {
          _errorMessage = error['error'] ?? 'Prediction failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<BarChartGroupData> _generateChartData() {
    if (_predictionResult == null || _predictionResult!['probabilities'] == null) {
      return [];
    }

    final probabilities = _predictionResult!['probabilities'] as Map<String, dynamic>;
    final sortedEntries = probabilities.entries.toList()
      ..sort((a, b) => (b.value as double).compareTo(a.value as double));

    return sortedEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final emotion = entry.value.key;
      final probability = entry.value.value as double;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: probability * 100,
            color: emotionColors[emotion] ?? Colors.grey,
            width: 40,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildChart() {
    if (_predictionResult == null) return const SizedBox.shrink();

    final probabilities = _predictionResult!['probabilities'] as Map<String, dynamic>;
    final sortedEntries = probabilities.entries.toList()
      ..sort((a, b) => (b.value as double).compareTo(a.value as double));

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final emotion = sortedEntries[group.x.toInt()].key;
                final value = rod.toY;
                return BarTooltipItem(
                  '$emotion\n${value.toStringAsFixed(1)}%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < sortedEntries.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        sortedEntries[value.toInt()].key,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _generateChartData(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Detection'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter text to analyze emotions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your text here...',
                        labelText: 'Text Input',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _predictEmotion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Analyzing...'),
                              ],
                            )
                          : const Text(
                              'Predict Emotion',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Card(
                elevation: 4,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_predictionResult != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prediction Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Original Text:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(_predictionResult!['original_text'] ?? ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: emotionColors[_predictionResult!['predicted_emotion']]?.withOpacity(0.1) ?? Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: emotionColors[_predictionResult!['predicted_emotion']] ?? Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Predicted Emotion:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: emotionColors[_predictionResult!['predicted_emotion']] ?? Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _predictionResult!['predicted_emotion'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emotion Probabilities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChart(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}