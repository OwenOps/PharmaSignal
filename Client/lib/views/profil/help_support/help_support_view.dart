import 'package:flutter/material.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/widgets/button.dart';
import 'package:pharma_signal/widgets/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            AppBar(
                title: Text(AppLocalizations.of(context)?.helpSupport ?? Constants.notAvailable,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Container(
              margin: const EdgeInsets.only(top:15, left: 20, right: 20),
              width: double.infinity,
              child: Text(AppLocalizations.of(context)?.havingProblem ?? Constants.notAvailable,
                  style: const TextStyle(color: Constants.darkGrey, fontSize: 17)),
            ),
            const _HelpSupportForm(),
          ],
        ),
      ),
    );
  }
}

class _HelpSupportForm extends StatefulWidget {
  const _HelpSupportForm({super.key});

  @override
  State<_HelpSupportForm> createState() => _HelpSupportFormState();
}

class _HelpSupportFormState extends State<_HelpSupportForm> {
  final _formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controllers = {
    'objet': TextEditingController(),
    'message': TextEditingController(),
  };

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void showSnackBar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.sendingData ?? Constants.notAvailable),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              InputTextBase(description: AppLocalizations.of(context)?.objet ?? Constants.notAvailable, controller: controllers['objet']),
              InputTextArea(description: AppLocalizations.of(context)?.message ?? Constants.notAvailable, controller: controllers['message']),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: BlueButton(onPressed: showSnackBar, description: AppLocalizations.of(context)?.validate ?? Constants.notAvailable),
              )
            ],
          ),
        ));
  }
}
