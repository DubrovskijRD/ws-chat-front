import 'package:flutter/material.dart';

class Path {
  const Path(this.pattern, this.builder);
  
  final String pattern;
  final Widget Function(BuildContext, String?) builder;
}