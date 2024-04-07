import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget buildImage(BuildContext context, String imageUrl, double radius) {
  return Image.memory(
    base64Decode(imageUrl),
    fit: BoxFit.cover,
    );
  }