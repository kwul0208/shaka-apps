import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';

alert(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
    // behavior: SnackBarBehavior.floating,
  ));
}

  
alertSuccess(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
    backgroundColor: primaryColor,
    // behavior: SnackBarBehavior.floating,
  ));
}

  
alertFailed(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
    backgroundColor: red,
    // behavior: SnackBarBehavior.floating,
  ));
}