import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late FocusNode _focusNode;
  Color _hintColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _hintColor = _focusNode.hasFocus ? Colors.green : Colors.grey;
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
    const fieldHeight = 52.0;

    return Container(
      height: fieldHeight,
      margin: const EdgeInsets.only(bottom: 20),
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
          prefixIconConstraints: const BoxConstraints(
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
