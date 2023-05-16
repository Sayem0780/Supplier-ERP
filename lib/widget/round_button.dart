import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onpress;
  const RoundButton({super.key, required this.title,required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: MaterialButton(
        color: Theme.of(context).primaryColorDark,
        height: 50,
        minWidth: MediaQuery.of(context).size.width*.5,
        onPressed: onpress,
        child: Text(title,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
