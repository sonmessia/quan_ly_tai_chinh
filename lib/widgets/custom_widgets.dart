import 'package:flutter/material.dart';
import '../core/config/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppStyles.borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : (backgroundColor ?? AppColors.primary),
            borderRadius: AppStyles.borderRadius,
            border: isOutlined
                ? Border.all(color: backgroundColor ?? AppColors.primary)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isOutlined
                      ? (backgroundColor ?? AppColors.primary)
                      : (textColor ?? Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isOutlined
                      ? (backgroundColor ?? AppColors.primary)
                      : (textColor ?? Colors.white),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: AppStyles.borderRadius,
        boxShadow: [AppStyles.cardShadow],
      ),
      child: child,
    );
  }
}

class AnimatedSelectionCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AnimatedSelectionCard({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: AppStyles.borderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.text,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}