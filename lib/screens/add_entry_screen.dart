import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/firebase_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  String _weatherInfo = "Detecting location...";
  bool _isWeatherLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initWeather();
  }

  // Fetches GPS and Weather automatically when screen opens
  Future<void> _initWeather() async {
    try {
      final data = await WeatherService().fetchWeather();
      setState(() {
        _weatherInfo =
            "${data['main']['temp']}°C, ${data['weather'][0]['description']} in ${data['name']}";
        _isWeatherLoading = false;
      });
    } catch (e) {
      setState(() {
        _weatherInfo = "Weather unavailable (Check GPS/Internet)";
        _isWeatherLoading = false;
      });
    }
  }

  // Saves to Firebase Firestore
  Future<void> _handleSave() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write your memory before saving!"),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _firebaseService.addEntry(_controller.text, _weatherInfo);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Memory saved to Cloud!")));
        Navigator.pop(context); // Go back to Home Screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error saving: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Memory")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Weather Card (Fulfills API Integration & Automation)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        _weatherInfo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_isWeatherLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Diary Input Field
            TextField(
              controller: _controller,
              maxLines: 12,
              decoration: InputDecoration(
                hintText: "What's on your mind today?",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 25),

            // Save Button (Fulfills Database Integration)
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isSaving ? "SAVING..." : "SAVE TO CLOUD"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
