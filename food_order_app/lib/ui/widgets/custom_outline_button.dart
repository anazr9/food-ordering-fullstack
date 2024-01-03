// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? icon;
  final Size? size;
  final String text;
  const CustomOutlineButton({
    Key? key,
    this.onPressed,
    this.icon,
    this.size,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.height,
      width: size?.width,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Colors.white,
          side: const BorderSide(width: 1.5, color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        icon: icon ?? Container(),
        label: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
