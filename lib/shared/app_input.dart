import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_icons.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onFocusChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscuring;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLength;
  final int maxLines;
  final double? height, width;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  const AppInput({
    super.key,
    this.hintText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.height,
    this.width,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscuring = false,
    this.textStyle,
    this.inputFormatters,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool obscureText = false;
  TextEditingController? _inputController;
  @override
  void initState() {
    obscureText = widget.obscuring;
    if (widget.onSubmitted != null) {
      _inputController = TextEditingController(text: widget.initialValue);
    }

    obscureText = isPassword ? true : obscureText;
    super.initState();
  }

  void _updateVisibility() {
    obscureText = !obscureText;
    setState(() {});
  }

  bool get isPassword => widget.keyboardType == TextInputType.visiblePassword;
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: color,
          width: 0.5,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        controller: widget.controller ?? _inputController,
        initialValue: _inputController != null ? null : widget.initialValue,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        validator: widget.validator,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onFieldSubmitted: (val) {
          _inputController?.clear();
          widget.onSubmitted?.call(val);
        },
        textInputAction: widget.textInputAction,
        obscuringCharacter: '*',
        maxLength: widget.maxLength,
        style: widget.textStyle,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          hintText: widget.hintText,
          counterStyle: const TextStyle(fontSize: 0),
          hintStyle: AppTextStyle.medium14.copyWith(
            color: AppColors.grey300,
          ),
          errorStyle: AppTextStyle.light14.copyWith(
            color: Colors.red,
          ),
          suffixIcon: isPassword
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: AppIcons(
                    icon:
                        obscureText ? AppIconData.eyesClosed : AppIconData.eyes,
                    size: 16,
                    onTap: _updateVisibility,
                  ),
                )
              : null,
          border: _border(AppColors.grey400),
          enabledBorder: _border(AppColors.grey400),
          focusedBorder: _border(AppColors.primaryColor),
          errorBorder: _border(Colors.red),
          focusedErrorBorder: _border(Colors.red),
        ),
      ),
    );
  }
}
