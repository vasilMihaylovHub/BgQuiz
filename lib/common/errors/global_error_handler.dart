import 'package:flutter/material.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';

class GlobalErrorHandler extends StatefulWidget {
  final Widget child;

  const GlobalErrorHandler({super.key, required this.child});

  @override
  _GlobalErrorHandlerState createState() => _GlobalErrorHandlerState();
}

class _GlobalErrorHandlerState extends State<GlobalErrorHandler> {

  void onError(FlutterErrorDetails errorDetails) {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    logger.e('Caught error UUID: $uniqueId, error: ${errorDetails.exception}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const MyTextField(text: 'Грешка', fontSize: 20,),
          content: MyTextField(text: 'Нещо се обърка. Екипът работи по отстраняване на проблема. [$uniqueId]',
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