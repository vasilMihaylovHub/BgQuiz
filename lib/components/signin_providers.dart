import 'package:flutter/material.dart';
import 'package:quiz_maker/components/square_tile.dart';
import 'package:quiz_maker/components/text_field.dart';

class SignInProviders extends StatelessWidget {
  final Function(String) onProviderTab;

  const SignInProviders({super.key, required this.onProviderTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                thickness: 0.5,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MyTextField(text: 'Или продължи с'),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SquareTile(
                imagePath: 'lib/images/google_logo.png',
                onTab: () {
                  onProviderTab("GCP");
                })
          ],
        )
      ],
    );
  }
}
