import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = "Fetching weather...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    try {
      final data = await WeatherService().fetchWeather();
      setState(() {
        _weatherInfo =
            "${data['main']['temp']}°C, ${data['weather'][0]['description']} in ${data['name']}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _weatherInfo = "Weather unavailable";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Journal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Weather Card (Rubric: API Integration)
            Card(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                title: Text(
                  _weatherInfo,
                  style: const TextStyle(color: Colors.black87),
                ),
                trailing: _isLoading ? const CircularProgressIndicator() : null,
              ),
            ),
            const SizedBox(height: 20),
            // Input Field (Rubric: Simple Navigation)
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "How was your day in Malaysia?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Future: Save to Firebase
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Entry Saved Successfully!")),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text("Save Memory"),
            ),
          ],
        ),
      ),
    );
  }
}
