import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  const CustomContainer({
    super.key,
    required this.child,
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.white,
    this.padding,
    this.margin,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w), // scaled padding
      margin:
          margin ??
          EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w), // scaled margin
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r), // scaled radius
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                spreadRadius: 2.r, // scaled spread
                blurRadius: 6.r, // scaled blur
                offset: Offset(0, 3.h), // scaled vertical offset
              ),
            ],
      ),
      child: child,
    );
  }
}
