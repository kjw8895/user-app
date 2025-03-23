import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sms_verification_provider.dart';

class SmsVerificationScreen extends StatefulWidget {
  final String phone;

  const SmsVerificationScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SmsVerificationProvider>().sendVerificationSms(widget.phone);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onResendPressed() {
    if (_isResendEnabled) {
      context.read<SmsVerificationProvider>().sendVerificationSms(widget.phone);
      setState(() => _isResendEnabled = false);
    }
  }

  void _onVerifyPressed() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final verified = await context.read<SmsVerificationProvider>().verifyCode(code);
    if (verified && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴대폰 인증'),
      ),
      body: Consumer<SmsVerificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${widget.phone}로 인증번호를 발송했습니다.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '인증번호',
                    hintText: '6자리 인증번호를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 6,
                ),
                const SizedBox(height: 16),
                if (provider.error != null)
                  Text(
                    provider.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _onVerifyPressed,
                  child: const Text('인증하기'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: provider.remainingTime > 0 ? null : _onResendPressed,
                  child: Text(
                    provider.remainingTime > 0
                        ? '${provider.remainingTime ~/ 60}:${(provider.remainingTime % 60).toString().padLeft(2, '0')}'
                        : '인증번호 재발송',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 