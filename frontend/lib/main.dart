import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emotion Detector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EmotionHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmotionHomePage extends StatefulWidget {
  @override
  _EmotionHomePageState createState() => _EmotionHomePageState();
}

class _EmotionHomePageState extends State<EmotionHomePage> {
  TextEditingController _controller = TextEditingController();
  String? predictedEmotion;
  Map<String, double>? probabilities;
  String? inputText;
  bool isLoading = false;

  Future<void> predictEmotion(String text) async {
    setState(() {
      isLoading = true;
      inputText = text;
    });

    final uri = Uri.parse('http://172.20.10.3:5001/predict');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          predictedEmotion = data['prediction'];
          probabilities = Map<String, double>.from(
            (data['probabilities'] as Map).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ),
          );
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to backend: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _buildBarChart() {
    if (probabilities == null) return SizedBox.shrink();

    final List<BarChartGroupData> barGroups =
        probabilities!.entries.map((entry) {
          final index = probabilities!.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList();

    return BarChart(
      BarChartData(
        maxY: 1.0,
        minY: 0.0,
        barGroups: barGroups,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= probabilities!.length) {
                  return SizedBox();
                }
                final label = probabilities!.keys.elementAt(index);
                return SideTitleWidget(
                  meta: meta,
                  child: Text(label, style: TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emotion Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your text here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  predictEmotion(_controller.text);
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 24),
            if (isLoading) CircularProgressIndicator(),
            if (!isLoading &&
                predictedEmotion != null &&
                probabilities != null) ...[
              Text('Input: $inputText', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                'Predicted Emotion: $predictedEmotion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Expanded(child: _buildBarChart()),
            ],
          ],
        ),
      ),
    );
  }
}
