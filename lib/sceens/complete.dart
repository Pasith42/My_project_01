import 'package:flutter/material.dart';
import 'package:flutter_application_1/sceens/home.dart';

class Complete extends StatelessWidget {
  const Complete({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_sharp,
                size: 20, color: Colors.green),
            const Text(
              'เสร็จสมบูรณ์',
              textScaleFactor: 2.0,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text('OK'))
          ],
        ),
      ),
    );
  }
}
