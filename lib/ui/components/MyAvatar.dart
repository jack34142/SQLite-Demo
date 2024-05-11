import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAvatar extends StatelessWidget {

  final String imageUrl;
  final double size;

  bool isBase64 = true;

  MyAvatar({required this.imageUrl, this.size = 48}){
    if(imageUrl.length > 4 && imageUrl.substring(0,4) == "http"){
      isBase64 = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
        child: imageUrl.isEmpty ? Icon(Icons.image, size: size-20) :
          isBase64 ? Image.memory(base64Decode(imageUrl),
            fit: BoxFit.cover,
          ) : CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imageUrl
        ),
      ),
    );
  }
}