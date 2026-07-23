import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool dense;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.dense = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late FocusNode _focusNode;
  Color _hintColor = const Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          // Stay grey; slightly darker when focused (never green).
          _hintColor = _focusNode.hasFocus
              ? const Color(0xFF757575)
              : const Color(0xFF9E9E9E);
        });
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = widget.dense ? 48.0 : 52.0;
    final bottomMargin = widget.dense ? 12.0 : 20.0;

    return Container(
      height: fieldHeight,
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: widget.textController,
        focusNode: _focusNode,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              height: 1.0,
            ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(
            top: 4,
            bottom: 0,
            right: 16,
          ),
          prefixIcon: Icon(widget.icon, color: _hintColor),
          prefixIconConstraints: BoxConstraints(
            minWidth: 48,
            minHeight: fieldHeight,
          ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: widget.placeholder,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _hintColor,
                fontSize: 13,
                height: 1.0,
              ),
        ),
      ),
    );
  }
}
