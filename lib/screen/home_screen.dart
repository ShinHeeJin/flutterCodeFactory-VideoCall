import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100]!,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: const [
            Expanded(child: _Logo()),
            Expanded(child: _Image()),
            Expanded(child: _EntryButton()),
          ]),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _EntryButton extends StatelessWidget {
  const _EntryButton();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
