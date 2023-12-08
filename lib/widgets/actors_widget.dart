import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActorsWidget extends StatelessWidget {
  String? id;
  String? img;
  String? name;
  ActorsWidget({super.key, this.img, this.name});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(maxRadius: 25, backgroundImage: NetworkImage(img!)),
      Text(name!),
    ]);
  }
}
