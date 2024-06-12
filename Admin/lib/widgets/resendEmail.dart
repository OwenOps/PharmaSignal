import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mobile_application/utils/constants.dart';

class SendEmail extends StatelessWidget {
  const SendEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child : 

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 115), // Ajustez la valeur
          child: Wrap(
              children: [
                  ResendEmailWithTimer(
                      onResend: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Code de confirmation envoyé par mail'),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 30, left: 20, right: 20)),
                          );
                      },
                  ),
              ],
          ),
      ),
    );
  }
  
}

// Widget pour renvoyer un email avec un minuteur
class ResendEmailWithTimer extends StatefulWidget {
  final Function onResend; // Fonction à appeler pour renvoyer un email

  const ResendEmailWithTimer({super.key, required this.onResend});

  @override
  _ResendEmailWithTimerState createState() => _ResendEmailWithTimerState();
}

class _ResendEmailWithTimerState extends State<ResendEmailWithTimer> {
  bool _isResendButtonEnabled = false;
  int _secondsRemaining = 60; // 1 minute
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _isResendButtonEnabled = false;
      _secondsRemaining = 60; // 1 minute
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {

      if (!mounted) return;

      if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });

      } else {
        timer.cancel();
          setState(() {
            _isResendButtonEnabled = true;
          });
      }
    });
  }

  void _handleResend() {
    if (_isResendButtonEnabled) {
      widget.onResend();
      _startTimer(); 
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _isResendButtonEnabled ? _handleResend : null,
          child: Text(
            'Envoyer à nouveau',
            style: TextStyle(
              color: _isResendButtonEnabled ? Constants.white : Constants.lightGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$_secondsRemaining s',
          style: TextStyle(
            color: _isResendButtonEnabled ? Constants.lightGreen : Constants.lightGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
