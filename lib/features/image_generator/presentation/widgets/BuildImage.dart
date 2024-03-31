import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shaka/constants/responsive.dart';


Widget buildImage(BuildContext context, String imageUrl, double radius) {
  return Image.memory(
    base64Decode(imageUrl),
    fit: BoxFit.cover,
    );
  }