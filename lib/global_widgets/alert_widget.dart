import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';

alert(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
  ));
}

  
alertSuccess(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
    backgroundColor: primaryColor,
  ));
}

  
alertFailed(context, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$message"),
    backgroundColor: red,
  ));
}