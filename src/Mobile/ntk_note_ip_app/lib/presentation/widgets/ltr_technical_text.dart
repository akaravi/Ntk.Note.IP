import 'package:flutter/material.dart';

/// True when [text] has no Arabic/Persian/Hebrew scripts — should render LTR.
bool isLatinTechnicalText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    return false;
  }

  for (final codeUnit in trimmed.runes) {
    if (_isRtlScript(codeUnit)) {
      return false;
    }
  }

  return true;
}

bool _isRtlScript(int codeUnit) {
  return (codeUnit >= 0x0600 && codeUnit <= 0x06FF) ||
      (codeUnit >= 0x0750 && codeUnit <= 0x077F) ||
      (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) ||
      (codeUnit >= 0xFB50 && codeUnit <= 0xFDFF) ||
      (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF) ||
      (codeUnit >= 0x0590 && codeUnit <= 0x05FF);
}

/// Forces LTR layout for a subtree (code blocks, IPs, commands).
class LtrScope extends StatelessWidget {
  const LtrScope({
    required this.child,
    this.alignment = AlignmentDirectional.centerStart,
    super.key,
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: alignment,
        widthFactor: 1,
        child: child,
      ),
    );
  }
}

class LtrText extends StatelessWidget {
  const LtrText(
    this.data, {
    super.key,
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
  });

  final String data;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return LtrScope(
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class LtrSelectableText extends StatelessWidget {
  const LtrSelectableText(
    this.data, {
    super.key,
    this.style,
  });

  final String data;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LtrScope(
      child: SelectableText(
        data,
        style: style,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      ),
    );
  }
}

/// Monospace code/command block — always LTR.
class LtrCodeBlock extends StatelessWidget {
  const LtrCodeBlock({
    required this.code,
    this.fontSize = 13,
    super.key,
  });

  final String code;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LtrSelectableText(
      code,
      style: TextStyle(fontFamily: 'monospace', fontSize: fontSize),
    );
  }
}

/// Text field for IP, domain, CIDR, port — always LTR input.
class LtrTextFormField extends StatelessWidget {
  const LtrTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled,
    this.validator,
    this.obscureText = false,
    this.autofillHints,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      decoration: decoration,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      validator: validator,
      obscureText: obscureText,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
  }
}
