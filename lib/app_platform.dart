/*
enum CustomPlatform{
  linux,
  macos,
  windows,
  ios,
  fuchsia,
  web,
  undefined
}*/

import 'dart:io';

import 'package:flutter/foundation.dart';

class AppPlatform{

  static const Map<String,String> _platformMap={
    'linux':'linux',
    'macos':'macos',
    'windows':'windows',
    'ios':'iphone',
  };

  static String  getPlatform(){
    if(kIsWeb){
      return 'web';
    }
    return _platformMap[Platform.operatingSystem]??'undefined';
  }

  static String get platform=>getPlatform();
}