import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_sync/Profile/drawer_slider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:health_sync/authentication/login_signup.dart';

// Assuming UserData class is defined elsewhere
class VoiceChatbotLogic {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;
  String _recognizedText = '';
  String _ttsStatus = 'TTS Ready';
  Map<String, dynamic> _bookingDetails = {};
  int _retryCount = 0;
  static const int _maxRetries = 2;
  int _currentQuestionIndex = 0;
  bool _isInitialized = false;
  bool _isBookingComplete = false; // Track if booking process should stop
  bool _isWelcomeMessageSpoken = false; // Track if welcome message is complete

  final List<String> _questions = [
    'Please tell me your name.',
    'What is your phone number?',
    'What is your age?',
    'What is your Aadhaar number?',
    'What is your address?',
    'Which OPD department? For example, Cardiology.',
    'Please select your appointment date using the date picker.',
    'What time slot? For example, 10:00 AM.',
    'Pay now? Say yes or no.',
  ];

  // Callbacks to update UI
  final VoidCallback onStateChanged;
  final Function(String) onRecognizedTextChanged;
  final Function(String) onTtsStatusChanged;
  final BuildContext context;

  VoiceChatbotLogic({
    required this.onStateChanged,
    required this.onRecognizedTextChanged,
    required this.onTtsStatusChanged,
    required this.context,
  });

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get recognizedText => _recognizedText;
  String get ttsStatus => _ttsStatus;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<String> get questions => _questions;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    print('VoiceChatbotLogic: Initializing...');
    await UserData.fetchUserData();
    if (UserData.userId == null) {
      print('VoiceChatbotLogic: No userId, redirecting to LoginSignupScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
      );
      return;
    }
    print('VoiceChatbotLogic: userId = ${UserData.userId}');
    await _initializeSpeech();
    await _initializeTts();
    _isInitialized = true;
    onStateChanged();
    // Don't call _startConversation here; it will be called after welcome message
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            _ttsStatus = 'TTS Ready';
            onStateChanged();
            onTtsStatusChanged(_ttsStatus);
          }
        },
        onError: (error) {
          print('Speech error: $error');
          _isListening = false;
          _ttsStatus = 'Speech Error: $error';
          onStateChanged();
          onTtsStatusChanged(_ttsStatus);
          _retryListen();
        },
      );
      if (!available) {
        _ttsStatus = 'Speech initialization failed';
        onTtsStatusChanged(_ttsStatus);
        await _speak('Speech initialization failed. Please try again.');
      }
    } catch (e) {
      print('Speech initialization exception: $e');
      _ttsStatus = 'Speech Initialization Error: $e';
      onTtsStatusChanged(_ttsStatus);
      onStateChanged();
    }
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setStartHandler(() {
        _isSpeaking = true;
        _ttsStatus = 'Speaking...';
        onStateChanged();
        onTtsStatusChanged(_ttsStatus);
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
        _ttsStatus = 'TTS Ready';
        onStateChanged();
        onTtsStatusChanged(_ttsStatus);
        if (_isInitialized && !_isBookingComplete) {
          if (!_isWelcomeMessageSpoken) {
            // Welcome message just finished, start conversation
            _isWelcomeMessageSpoken = true;
            _startConversation();
          } else if (_currentQuestionIndex == 6) {
            _showDatePicker();
          } else if (_currentQuestionIndex < _questions.length) {
            Future.delayed(const Duration(milliseconds: 500), listen);
          } else {
            // After booking, ask if user wants another appointment
            Future.delayed(const Duration(milliseconds: 500), _askForAnotherBooking);
          }
        }
      });

      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
        _ttsStatus = 'TTS Error: $msg';
        onStateChanged();
        onTtsStatusChanged(_ttsStatus);
        print('TTS error: $msg');
      });

      await _speak(
          'Hello! Welcome to HealthSync AI, your friendly assistant for booking OPD appointments. I\'m here to guide you step-by-step. Let\'s get started!');
    } catch (e) {
      _ttsStatus = 'TTS Initialization Error: $e';
      onTtsStatusChanged(_ttsStatus);
      onStateChanged();
      print('TTS initialization exception: $e');
    }
  }

  Future<void> _startConversation() async {
    if (!_isSpeaking && !_isListening && _isInitialized && !_isBookingComplete) {
      _retryCount = 0;
      if (_currentQuestionIndex == 6) {
        await _speak(_questions[_currentQuestionIndex]);
      } else {
        await _speak(_questions[_currentQuestionIndex]);
      }
    }
  }

  Future<void> _speak(String text) async {
    try {
      _ttsStatus = 'Preparing to speak...';
      onTtsStatusChanged(_ttsStatus);
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      _ttsStatus = 'TTS Error: $e';
      onTtsStatusChanged(_ttsStatus);
      print('TTS exception: $e');
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _bookingDetails['appointment_date'] = formattedDate;
      _recognizedText = formattedDate;
      onRecognizedTextChanged(_recognizedText);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startConversation();
      } else {
        _saveBooking();
      }
    } else {
      await _speak('No date selected. Please select a date for your appointment.');
      Future.delayed(const Duration(milliseconds: 500), _showDatePicker);
    }
  }

  Future<void> listen() async {
    if (!_isListening && !_isSpeaking && _isInitialized && !_isBookingComplete) {
      _isListening = true;
      _ttsStatus = 'Listening...';
      onStateChanged();
      onTtsStatusChanged(_ttsStatus);
      try {
        await _speech.listen(
          onResult: (result) {
            _recognizedText = result.recognizedWords;
            onRecognizedTextChanged(_recognizedText);
            if (result.finalResult) {
              _isListening = false;
              _ttsStatus = 'Processing...';
              onStateChanged();
              onTtsStatusChanged(_ttsStatus);
              if (_recognizedText.isEmpty) {
                _retryListen();
              } else {
                _retryCount = 0;
                if (_currentQuestionIndex >= _questions.length) {
                  _processAnotherBookingResponse(_recognizedText);
                } else {
                  _processResponse(_recognizedText);
                }
              }
            }
          },
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 5),
          onSoundLevelChange: (level) => print('Sound level: $level'),
          cancelOnError: false,
          partialResults: true,
        );
      } catch (e) {
        print('Listen exception: $e');
        _isListening = false;
        _ttsStatus = 'Listen Error: $e';
        onStateChanged();
        onTtsStatusChanged(_ttsStatus);
        _retryListen();
      }
    }
  }

  Future<void> _retryListen() async {
    if (_retryCount < _maxRetries) {
      _retryCount++;
      await _speak('Sorry, I didn’t catch that. Please try again.');
      Future.delayed(const Duration(seconds: 1), listen);
    } else {
      await _speak('I’m having trouble hearing you. Let’s try this question again.');
      _retryCount = 0;
      if (_currentQuestionIndex >= _questions.length) {
        _askForAnotherBooking();
      } else {
        _startConversation();
      }
    }
  }

  Future<Map<String, dynamic>> _extractDetailsWithGemini(String input) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=${dotenv.env['GEMINI_API_KEY']}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Extract details from this input: name, phone, age, aadhar, address, OPD_dept, time_slot, is_paid. Return as JSON. Input: $input'
                }
              ]
            }
          ]
        }),
      );
      print('Gemini response status: ${response.statusCode}');
      print('Gemini response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final extractedText =
            data['candidates'][0]['content']['parts'][0]['text'];
        try {
          return jsonDecode(extractedText);
        } catch (e) {
          return {
            'name': extractedText.contains('name')
                ? extractedText.split('name: ')[1].split('\n')[0]
                : input,
            'phone': extractedText.contains('phone')
                ? extractedText.split('phone: ')[1].split('\n')[0]
                : input,
            'age': extractedText.contains('age')
                ? extractedText.split('age: ')[1].split('\n')[0]
                : input,
            'aadhar': extractedText.contains('aadhar')
                ? extractedText.split('aadhar: ')[1].split('\n')[0]
                : input,
            'address': extractedText.contains('address')
                ? extractedText.split('address: ')[1].split('\n')[0]
                : input,
            'OPD_dept': extractedText.contains('OPD_dept')
                ? extractedText.split('OPD_dept: ')[1].split('\n')[0]
                : input,
            'time_slot': extractedText.contains('time_slot')
                ? extractedText.split('time_slot: ')[1].split('\n')[0]
                : input,
            'is_paid': extractedText.contains('is_paid')
                ? extractedText.split('is_paid: ')[1].split('\n')[0]
                : (input.toLowerCase() == 'yes' ? 'true' : 'false'),
          };
        }
      } else {
        print('Gemini error: ${response.statusCode} - ${response.body}');
        return {
          'name': input,
          'phone': input,
          'age': input,
          'aadhar': input,
          'address': input,
          'OPD_dept': input,
          'time_slot': input,
          'is_paid': input.toLowerCase() == 'yes' ? 'true' : 'false',
        };
      }
    } catch (e) {
      print('Gemini exception: $e');
      return {
        'name': input,
        'phone': input,
        'age': input,
        'aadhar': input,
        'address': input,
        'OPD_dept': input,
        'time_slot': input,
        'is_paid': input.toLowerCase() == 'yes' ? 'true' : 'false',
      };
    }
  }

  void _processResponse(String response) async {
    final extractedDetails = await _extractDetailsWithGemini(response);
    String key;
    dynamic value;

    switch (_currentQuestionIndex) {
      case 0:
        key = 'name';
        value = extractedDetails['name'] ?? response;
        break;
      case 1:
        key = 'phone';
        value = extractedDetails['phone'] ?? response;
        break;
      case 2:
        key = 'age';
        value = extractedDetails['age'] ?? response;
        break;
      case 3:
        key = 'aadhar';
        value = extractedDetails['aadhar'] ?? response;
        break;
      case 4:
        key = 'address';
        value = extractedDetails['address'] ?? response;
        break;
      case 5:
        key = 'OPD_dept';
        value = extractedDetails['OPD_dept'] ?? response;
        break;
      case 7:
        key = 'time_slot';
        value = extractedDetails['time_slot'] ?? response;
        break;
      case 8:
        key = 'is_paid';
        value = (extractedDetails['is_paid']?.toLowerCase() == 'true' ||
            response.toLowerCase() == 'yes');
        break;
      default:
        key = '';
        value = '';
    }

    _bookingDetails[key] = value;

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _startConversation();
    } else {
      _saveBooking();
    }
  }

  Future<void> _askForAnotherBooking() async {
    if (!_isSpeaking && !_isListening && _isInitialized && !_isBookingComplete) {
      _currentQuestionIndex = _questions.length; // Indicate we're in the post-booking phase
      await _speak('Would you like to book another OPD appointment? Please say yes or no.');
    }
  }

  void _processAnotherBookingResponse(String response) async {
    final normalizedResponse = response.toLowerCase().trim();
    if (normalizedResponse == 'yes') {
      // Reset for a new booking
      _bookingDetails = {};
      _currentQuestionIndex = 0;
      _recognizedText = '';
      onRecognizedTextChanged(_recognizedText);
      onStateChanged();
      _startConversation();
    } else if (normalizedResponse == 'no') {
      // End the booking process
      _isBookingComplete = true;
      await _speak('Thank you so much for using HealthSync AI. We wish you well!');
      _ttsStatus = 'Booking Session Complete';
      onTtsStatusChanged(_ttsStatus);
      onStateChanged();
    } else {
      // Unclear response, retry
      _retryListen();
    }
  }

  Future<void> _saveBooking() async {
    try {
      await UserData.fetchUserData();
      print('SaveBooking: userId = ${UserData.userId}');

      final requiredFields = [
        'name',
        'phone',
        'age',
        'aadhar',
        'address',
        'OPD_dept',
        'appointment_date',
        'time_slot',
        'is_paid',
      ];
      for (var field in requiredFields) {
        if (!_bookingDetails.containsKey(field) || _bookingDetails[field] == null) {
          throw Exception('Missing or null field: $field');
        }
      }
      if (UserData.userId == null || UserData.userId!.isEmpty) {
        print('SaveBooking: User not authenticated, redirecting to LoginSignupScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
        );
        throw Exception('User is not authenticated');
      }

      _bookingDetails['user_id'] = UserData.userId;

      print('Attempting to save booking with data: $_bookingDetails');

      final response =
          await Supabase.instance.client.from('opd_bookings').insert({
        'name': _bookingDetails['name'],
        'phone': _bookingDetails['phone'],
        'age': int.tryParse(_bookingDetails['age']?.toString() ?? '0') ?? 0,
        'aadhar': _bookingDetails['aadhar'],
        'address': _bookingDetails['address'],
        'OPD_dept': _bookingDetails['OPD_dept'],
        'appointment_date': _bookingDetails['appointment_date'],
        'time_slot': _bookingDetails['time_slot'],
        'created_at': DateTime.now().toIso8601String(),
        'is_paid': _bookingDetails['is_paid'] ?? false,
        'user_id': _bookingDetails['user_id'],
      }).select();

      print('Booking saved successfully: $response');
      await _speak('Your appointment has been booked successfully!');
    } catch (e, stackTrace) {
      print('Booking error: $e');
      print('Stack trace: $stackTrace');
      await _speak('Sorry, there was an error booking your appointment.');
      _ttsStatus = 'Booking Error: $e';
      onTtsStatusChanged(_ttsStatus);
      onStateChanged();
    }
  }

  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}