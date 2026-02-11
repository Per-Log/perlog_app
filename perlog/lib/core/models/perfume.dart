import 'package:flutter/material.dart';

class Perfume {
  final String name;
  final List<String> tags;
  final String description;
  final Color color;

  const Perfume({
    required this.name,
    required this.tags,
    required this.description,
    required this.color,
  });
}
