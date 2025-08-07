import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPlaceholder extends StatelessWidget {
  final String text;
  const LoadingPlaceholder({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Lottie.asset(
          'assets/lottie/loading.json',
          width: 320,
          height: 320,
          fit: BoxFit.contain,
        ),
        Text(text)
        ]
      ),
    );
  }
}
