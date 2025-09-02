import 'package:flutter/material.dart';

class PostJobFlowView extends StatelessWidget {
  const PostJobFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_business,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'Post a Job',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is a placeholder view. The full job posting flow will be implemented here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
