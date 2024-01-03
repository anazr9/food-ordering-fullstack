import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final void Function() onPressed;
  final Size size;
  final String text;
  final Color? color;
  const CustomFlatButton(
      {Key? key,
      required this.onPressed,
      required this.size,
      required this.text,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color ?? Colors.black,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 18,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
