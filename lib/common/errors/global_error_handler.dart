import 'package:flutter/material.dart';
import 'package:quiz_maker/components/text_field.dart';
import '../../main.dart';

class GlobalErrorHandler extends StatefulWidget {
  final Widget child;

  const GlobalErrorHandler({super.key, required this.child});

  @override
  _GlobalErrorHandlerState createState() => _GlobalErrorHandlerState();
}

class _GlobalErrorHandlerState extends State<GlobalErrorHandler> {

  void onError(FlutterErrorDetails errorDetails) {
    logger.e('Caught error: ${errorDetails.exception}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const MyTextField(text: 'Грешка', fontSize: 20,),
          content: const MyTextField(text:
            'Нещо се обърка. Моля опитайте отново. Екипът работи по отстраняване на проблема.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const MyTextField(text: 'OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(
      builder: (context, errorDetails) {
        return widget.child;
      },
      onError: onError,
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget Function(BuildContext, FlutterErrorDetails) builder;
  final void Function(FlutterErrorDetails) onError;
  final Widget child;

  ErrorWidgetBuilder({
    required this.builder,
    required this.onError,
    required this.child,
  });

  @override
  _ErrorWidgetBuilderState createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    FlutterError.onError = widget.onError;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}