import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatbotLogic {
  final String? apiKey = dotenv.env['apiKey'];
  final SupabaseClient supabase = Supabase.instance.client;

  String currentStep = "initial"; // Track the current step in the flow
  Map<String, String> userData = {}; // Store user inputs

  // Function to push user data to Supabase
  Future<void> saveDataToSupabase() async {
    try {
      final response = await supabase.from('opd_bookings').insert([
        {
          'name': userData['name'],
          'phone': userData['phone'],
          'aadhaar': userData['aadhaar'],
          'age': userData['age'],
          'address': userData['address'],
          'appointment_date': userData['appointment_date'],
          'time_slot': userData['time_slot'],
        }
      ]);

      print('Data saved: $response');
    } catch (e) {
      print('Failed to save data: $e');
    }
  }

  // Start the OPD booking flow
  Future<String> startOPDBookingFlow() async {
    currentStep = "awaiting_name";
    return "Welcome to OPD booking! May I have your name, please?";
  }

  // Handles user responses step by step
  Future<String> getBotResponse(String userMessage) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate typing delay

    switch (currentStep) {
      case "awaiting_name":
        userData["name"] = userMessage;
        currentStep = "awaiting_phone";
        return "Got it, ${userMessage}! Now, please provide your phone number.";

      case "awaiting_phone":
        if (userMessage.isNotEmpty && RegExp(r'^[0-9]{10}$').hasMatch(userMessage)) {
  userData["phone"] = userMessage;
  currentStep = "awaiting_aadhaar";
  return "Thanks! Finally, can you share your Aadhaar number?";
} else {
  return "Please enter a valid 10-digit phone number.";
}


      case "awaiting_aadhaar":
  if (userMessage.trim().isNotEmpty && RegExp(r'^[0-9]{12}$').hasMatch(userMessage.trim())) {
    userData["aadhaar"] = userMessage.trim();
    currentStep = "awaiting_name_again";
    return "Great! Can you please confirm your name again?";
  } else {
    return "Please enter a valid 12-digit Aadhaar number.";
  }

      case "awaiting_name_again":
        userData["confirmed_name"] = userMessage;
        currentStep = "awaiting_age";
        return "Thank you, ${userMessage}! May I know your age?";

      case "awaiting_age":
  if (userMessage.trim().isNotEmpty && RegExp(r'^\d{1,3}$').hasMatch(userMessage.trim())) {
    userData["age"] = userMessage.trim();
    currentStep = "awaiting_address";
    return "Got it! What's your address?";
  } else {
    return "Please enter a valid age (like 20 or 45).";
  }


      case "awaiting_address":
        userData["address"] = userMessage;
        currentStep = "awaiting_appointment_date";
        return "Thanks! What date would you like to book your appointment? (Format: YYYY-MM-DD)";

      case "awaiting_appointment_date":
        if (userMessage == "Tomorrow" || userMessage == "Day after tomorrow") {
          userData["appointment_date"] = userMessage;
          currentStep = "awaiting_time_slot";
          return "Great! Would you like a morning or evening slot?";
        } else {
          return "Please select a date by clicking one of the buttons: Tomorrow or Day after tomorrow.";
        }

      case "awaiting_time_slot":
        if (userMessage.toLowerCase() == "morning" || userMessage.toLowerCase() == "evening") {
          userData["time_slot"] = userMessage;
          currentStep = "completed";

          await saveDataToSupabase(); // Save data to Supabase

          return "Your appointment is confirmed for ${userData["appointment_date"]} in the ${userData["time_slot"]} slot. We'll contact you shortly!";
        } else {
          return "Please choose either 'morning' or 'evening'.";
        }

      default:
        return await _getApiResponse(userMessage);
    }
  }

  // Fallback to API call if the chatbot is not in the OPD flow
  Future<String> _getApiResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {"role": "user", "parts": [{"text": userMessage}]}
          ],
          "generationConfig": {
            "maxOutputTokens": 100,
            "temperature": 0.7,
            "topP": 0.8
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "I couldn't understand that.";
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
