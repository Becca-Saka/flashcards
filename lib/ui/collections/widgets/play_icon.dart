import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';

class PlayIcon extends StatelessWidget {
  const PlayIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: AppColors.black100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow,
        size: 28,
        color: Colors.white,
      ),
    );
  }
}
