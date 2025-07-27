import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Used for making HTTP requests.
import 'package:fl_chart/fl_chart.dart';

// The main entry point for the Flutter application.
void main() {
  runApp(MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configures the top-level Navigator and Theme.
    return MaterialApp(
      title: 'Emotion Detector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EmotionHomePage(), // Sets the default screen of the app.
      debugShowCheckedModeBanner: false, // Hides the debug banner.
    );
  }
}

// A stateful widget for the main screen because its content will change.
class EmotionHomePage extends StatefulWidget {
  const EmotionHomePage({super.key});

  @override
  EmotionHomePageState createState() => EmotionHomePageState();
}

// The State class for EmotionHomePage, containing the UI and logic.
class EmotionHomePageState extends State<EmotionHomePage> {
  // Controller to manage the text input field.
  final TextEditingController _controller = TextEditingController();
  // Stores the emotion string returned from the backend.
  String? predictedEmotion;
  // Stores the probability map for each emotion for the chart.
  Map<String, double>? probabilities;
  // Stores the original text submitted by the user.
  String? inputText;
  // A flag to show a loading indicator during the API call.
  bool isLoading = false;

  // Asynchronous function to send text to the backend for prediction.
  Future<void> predictEmotion(String text) async {
    // Update the UI to show the loading indicator and store the input text.
    setState(() {
      isLoading = true;
      inputText = text;
    });

    // The URL of the backend prediction endpoint.
    final uri = Uri.parse('http://172.20.10.3:5001/predict');
    try {
      // Make an HTTP POST request to the backend.
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }, // Set the content type to JSON.
        body: jsonEncode({
          'text': text,
        }), // Encode the input text as a JSON object.
      );

      // Check if the request was successful (HTTP status code 200).
      if (response.statusCode == 200) {
        // Decode the JSON response from the server.
        final data = jsonDecode(response.body);
        // Update the state with the new prediction data, triggering a UI rebuild.
        setState(() {
          predictedEmotion = data['prediction'];
          probabilities = Map<String, double>.from(
            (data['probabilities'] as Map).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ),
          );
        });
      } else {
        // Print an error to the console if the server returned an error.
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Print an error to the console if the connection to the backend failed.
      print('Error connecting to backend: $e');
    }

    // Update the UI to hide the loading indicator.
    setState(() {
      isLoading = false;
    });
  }

  // Helper function to get an emoji for a given emotion.
  String getEmojiForEmotion(String? emotion) {
    switch (emotion) {
      case 'joy':
        return '😄';
      case 'sadness':
        return '😢';
      case 'anger':
        return '😠';
      case 'fear':
        return '😨';

      case 'disgust':
        return '🤢';
      case 'shame':
        return '😳';
      case 'neutral':
        return '😐';
      case 'surprise':
        return '😮';
      default:
        return '🤔'; // A thinking face for unknown/null emotions.
    }
  }

  // A helper widget to build the bar chart based on the probabilities.
  Widget _buildBarChart() {
    // If there's no probability data, return an empty widget.
    if (probabilities == null) return SizedBox.shrink();

    // Convert the probability map into a list of BarChartGroupData for the chart.
    final List<BarChartGroupData> barGroups =
        probabilities!.entries.map((entry) {
          // Get the index of the current emotion to position it on the x-axis.
          final index = probabilities!.keys.toList().indexOf(entry.key);
          // Create a data group for a single bar.
          return BarChartGroupData(
            x: index,
            barRods: [
              // Define the appearance of the bar itself.
              BarChartRodData(
                toY: entry.value, // The height of the bar (the probability).
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList();

    // Return the configured BarChart widget.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          maxY: 1.0, // The maximum value on the y-axis.
          minY: 0.0, // The minimum value on the y-axis.
          barGroups: barGroups, // The data for the bars.
          borderData: FlBorderData(show: false), // Hide the chart border.
          gridData: FlGridData(show: true), // Show the grid lines.
          titlesData: FlTitlesData(
            // Configure the titles on the left (y-axis).
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            // Configure the titles on the bottom (x-axis).
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // A function to get the widget for each title on the bottom axis.
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  // Ensure the index is within the valid range.
                  if (index < 0 || index >= probabilities!.length) {
                    return SizedBox();
                  }
                  // Get the emotion label for the current index.
                  final label = probabilities!.keys.elementAt(index);
                  // Return a styled text widget for the label.
                  // added scrollview
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(label, style: TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The main build method that describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of the visual interface.
    return Scaffold(
      // The top app bar with a title.
      appBar: AppBar(title: Text('Emotion Detection')),
      // The main content of the screen.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content.
        child: Column(
          // Arrange widgets vertically.
          children: [
            // A text field for user input.
            TextField(
              controller:
                  _controller, // Link the controller to this text field.
              decoration: InputDecoration(
                hintText: 'write here', // A hint text.
                labelText: 'Enter your text here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12), // A small vertical space.
            // A button to submit the text.
            ElevatedButton(
              onPressed: () {
                // Only call the prediction function if the text field is not empty.
                if (_controller.text.isNotEmpty) {
                  predictEmotion(_controller.text);
                }
                // Clear the text field after submission.
                _controller.clear();
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 24), // A larger vertical space.
            Expanded(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conditionally display the loading indicator.
                  if (isLoading) CircularProgressIndicator(),
                  // Conditionally display the results if not loading and data is available.
                  if (!isLoading &&
                      predictedEmotion != null &&
                      probabilities != null) ...[
                    // Display the original input text.
                    Text(
                      'Input: $inputText',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Display the final predicted emotion.
                    Row(
                      children: [
                        Text(
                          'Predicted Emotion: $predictedEmotion ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getEmojiForEmotion(predictedEmotion),
                          style: TextStyle(
                            fontSize: 34,
                          ), // Make the emoji large and expressive.
                        ),
                      ],
                    ),

                    SizedBox(height: 24),
                    // Display the bar chart, expanded to fill available space.
                    Expanded(child: _buildBarChart()),
                    SizedBox(height: 24),
                    // Container(
                    //   height: 300,
                    //   child: ListView.builder(
                    //     itemCount: probabilities!.length,
                    //     itemBuilder: (context, index) {
                    //       final entry = probabilities!.entries.toList()[index];
                    //       return ListTile(
                    //         title: Text(entry.key),
                    //         subtitle: Text(entry.value.toString()),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
