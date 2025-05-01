import 'dart:math';
import 'package:flutter/material.dart';
import 'voice_chatbot_logic.dart';

class VoiceChatbotPage extends StatefulWidget {
  const VoiceChatbotPage({Key? key}) : super(key: key);

  @override
  _VoiceChatbotPageState createState() => _VoiceChatbotPageState();
}

class _VoiceChatbotPageState extends State<VoiceChatbotPage>
    with SingleTickerProviderStateMixin {
  late VoiceChatbotLogic _logic;
  late AnimationController _animationController;
  bool _isAiStarted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _logic = VoiceChatbotLogic(
      onStateChanged: () => setState(() {}),
      onRecognizedTextChanged: (text) => setState(() {}),
      onTtsStatusChanged: (status) => setState(() {}),
      context: context,
    );
  }

  void _startAi() {
    setState(() {
      _isAiStarted = true;
    });
    _logic.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAiStarted) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to HealthSync',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Book your OPD appointment with ease.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startAi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Call Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_logic.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'HealthSync Voice Assistant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue.shade700,
      //         ),
      //         child: Text(
      //           'Menu',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.person),
      //         title: Text('Profile'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _logic.currentQuestionIndex < _logic.questions.length
                      ? 'AI: ${_logic.questions[_logic.currentQuestionIndex]}'
                      : 'AI: Booking complete!',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You said: ${_logic.recognizedText}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Status: ${_logic.ttsStatus}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              SoundWaveWidget(
                isActive: _logic.isListening || _logic.isSpeaking,
                animationController: _animationController,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _logic.isListening
                      ? Colors.teal.shade300
                      : Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: _logic.isSpeaking || _logic.isListening
                    ? null
                    : _logic.listen,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _logic.isListening ? Icons.mic : Icons.mic_none,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _logic.isListening ? 'Listening...' : 'Speak Now',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logic.dispose();
    super.dispose();
  }
}

// Custom SoundWaveWidget for animated sound waves
class SoundWaveWidget extends StatelessWidget {
  final bool isActive;
  final AnimationController animationController;

  const SoundWaveWidget({
    Key? key,
    required this.isActive,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: SoundWavePainter(
              isActive: isActive,
              animationValue: animationController.value,
            ),
          ),
        );
      },
    );
  }
}

class SoundWavePainter extends CustomPainter {
  final bool isActive;
  final double animationValue;

  SoundWavePainter({
    required this.isActive,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? Colors.teal.shade700 : Colors.grey.shade400
      ..style = PaintingStyle.fill;

    final barWidth = size.width / 10;
    final maxHeight = size.height * 0.6;

    for (int i = 0; i < 5; i++) {
      double heightFactor = isActive
          ? (0.5 + 0.5 * (sin((i + animationValue) * pi)).abs())
          : 0.3;
      double barHeight = maxHeight * heightFactor;
      double x = (i * barWidth * 2) + barWidth;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            (size.height - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}