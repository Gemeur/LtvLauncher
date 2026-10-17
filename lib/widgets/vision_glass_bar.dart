import 'dart:ui';
import 'package:flutter/material.dart';

/// Виджет жидкого стекла Apple (visionOS Material)
/// Аппаратное размытие Skia GPU — стабильные 60 FPS на ATV 9
class VisionGlassBar extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color tintColor;
  final double surfaceOpacity;
  final double specularRimIntensity;
  final double cornerRadius;
  final double? focusXPercent; // 0.0 - 1.0 (смещение курсора пульта)

  const VisionGlassBar({
    Key? key,
    required this.child,
    this.blurSigma = 24.0, // Глубокое матовое стекло для мощного GPU
    this.tintColor = const Color(0xFF0D131F),
    this.surfaceOpacity = 0.32,
    this.specularRimIntensity = 0.70,
    this.cornerRadius = 30.0,
    this.focusXPercent = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.40),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Stack(
            children: [
              // 1. Акриловая тонировка
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: tintColor.withOpacity(surfaceOpacity),
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                ),
              ),

              // 2. Световой рефракционный блик visionOS
              if (focusXPercent != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cornerRadius),
                      gradient: RadialGradient(
                        center: Alignment(focusXPercent! * 2 - 1, 0),
                        radius: 0.85,
                        colors: [
                          Colors.white.withOpacity(specularRimIntensity * 0.40),
                          Colors.white.withOpacity(specularRimIntensity * 0.10),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.35, 1.0],
                      ),
                    ),
                  ),
                ),

              // 3. Зеркальный ободок Fresnel
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white.withOpacity(specularRimIntensity * 0.75),
                    ),
                  ),
                ),
              ),

              // 4. Карточки приложений
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
