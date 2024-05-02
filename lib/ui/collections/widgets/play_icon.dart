import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';

class PlayIcon extends StatelessWidget {
  final bool isLoading;
  const PlayIcon({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(isLoading ? 10 : 0),
      decoration: const BoxDecoration(
        color: AppColors.black100,
        shape: BoxShape.circle,
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(
              Icons.play_arrow,
              size: 28,
              color: Colors.white,
            ),
    );
  }
}
