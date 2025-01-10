import 'dart:math';

import 'package:flutter/material.dart';

/// Application level, non-persistent, shared values
class App {
  factory App() {
    return _singleton;
  }

  App._internal();

  //  parameters to be evaluated before use
  static ThemeData themeData = ThemeData.localize(
      //  start with a default theme
      ThemeData.light(useMaterial3: true),
      Typography()
          .white
          .copyWith(headlineLarge: Typography().white.headlineLarge?.copyWith(fontSize: 64) //  fixme: doesn't work
              ));

  //  colors
  // static const appBackgroundColor = Color(0xff2196f3);
  // static const screenBackgroundColor = Colors.white;
  static const defaultBackgroundColor = Color(0xff2654c6);

  static const defaultForegroundColor = Colors.white;
  static const disabledColor = Color(0xFFE8E8E8);
  static const textFieldColor = Color(0xFFE8E8E8);

  static const double defaultFontSize = 28;

  static final App _singleton = App._internal();
}

@immutable
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.onChanged,
    this.hintText,
    this.style,
    this.fontSize, //  fixme: overridden by non-null style above
    this.fontWeight,
    this.enabled,
    this.minLines,
    this.maxLines,
    this.border,
    this.width = 200,
    this.keyboardType,
  }) : onSubmitted = null;

  const AppTextField.onSubmitted({
    super.key,
    this.controller,
    this.focusNode,
    required this.onSubmitted,
    this.hintText,
    this.style,
    this.fontSize, //  fixme: overridden by non-null style above
    this.fontWeight,
    this.enabled,
    this.minLines,
    this.maxLines,
    this.border,
    this.width = 200,
    this.keyboardType,
  }) : onChanged = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: App.textFieldColor),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          // keyboardType: keyboardType ?? ((minLines ?? 0) > 1 ? TextInputType.multiline : TextInputType.text),
          onChanged: (String value) {
            onChanged?.call(value);
          },
          onSubmitted: (String value) {
            onSubmitted?.call(value);
          },
          decoration: InputDecoration(
            border: border,
            // floatingLabelAlignment: FloatingLabelAlignment.start,
            isDense: true,
            contentPadding: const EdgeInsets.all(2.0),
            hintText: hintText,
            hintStyle: style?.copyWith(color: Colors.black54, fontWeight: FontWeight.normal),
          ),
          style: style,
          //?? generateAppTextFieldStyle(fontSize: fontSize, fontWeight: fontWeight ?? FontWeight.normal),
          //(fontSize: fontSize, fontWeight: fontWeight ?? FontWeight.bold),
          autofocus: true,
          maxLength: null,
          minLines: minLines,
          maxLines: maxLines ?? minLines,
        ),
      ),
    );
  }

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final TextStyle? style;
  final double? fontSize; //  fixme: overridden by non-null style above
  final FontWeight? fontWeight;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final InputBorder? border;
  final double width;
  final TextInputType? keyboardType;
}

@immutable
class AppSpace extends StatelessWidget {
  const AppSpace(
      {super.key,
      this.space,
      //this.spaceFactor = 1.0,
      this.horizontalSpace,
      this.verticalSpace});

  static const double defaultSpace = 10;

  @override
  Widget build(BuildContext context) {
    if (space == null) {
      assert((horizontalSpace ?? 0) >= 0);
      assert((verticalSpace ?? 0) >= 0);
      return SizedBox(
        height: verticalSpace ?? (spaceFactor * defaultSpace),
        width: horizontalSpace ?? (spaceFactor * defaultSpace),
      );
    }
    final double maxSpace = max(space ?? 0, 0);
    return SizedBox(
      height: maxSpace,
      width: maxSpace,
    );
  }

  final double? space;
  static const double spaceFactor = 1;
  final double? horizontalSpace;
  final double? verticalSpace;
}

ElevatedButton appButton(
  String commandName, {
  required final VoidCallback? onPressed,
  final Color? backgroundColor,
  final double? fontSize,
  final dynamic value,
}) {
  var voidCallback = onPressed == null
      ? null //  show as disabled   //  fixme: does this work?
      : () {
          onPressed.call();
        };

  return ElevatedButton(
    clipBehavior: Clip.hardEdge,
    onPressed: voidCallback,
    child: Text(commandName,
        style: TextStyle(
          fontSize: fontSize ?? App.defaultFontSize,
        )
    ),
  );
}

IconButton appIconButton({
  required Widget icon,
  required VoidCallback onPressed, //  insist on action
  Color? color,
  double? iconSize,
}) {
  return IconButton(
    icon: icon,
    alignment: Alignment.bottomCenter,
    onPressed: () {
      onPressed();
    },
    color: color,
    iconSize: iconSize ?? App.defaultFontSize, //  demanded by IconButton
  );
}
