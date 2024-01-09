import 'package:flutter/material.dart';

Widget menuRecyclerView(IconData icon, String text) {
  return Scaffold(
    body: Row(
      children: [
        Icon(
          icon,
          size: 16,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
