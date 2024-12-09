import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mountain/app/constants/theme.dart';

class CustomInput extends StatefulWidget {
  final bool isPassword;
  final String labelText;
  final TextEditingController controller;
  final bool isError;
  final String? errorMessage;
  final int? maxLines;

  const CustomInput({
    Key? key,
    this.isPassword = false,
    required this.labelText,
    required this.controller,
    this.isError = false,
    this.errorMessage,
    this.maxLines,
  }) : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleInput() {
    // Process input here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: widget.isError ? Colors.red : Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _controller,
          obscureText: widget.isPassword && _obscureText,
          style: TextStyle(
            color: widget.isError ? Colors.red : Colors.black,
          ),
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: widget.isError ? Colors.red : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: widget.isError ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: widget.isError ? Colors.red : AppTheme.primaryColor,
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    color: widget.isError ? Colors.red : Colors.grey[700],
                    onPressed: () {
                      setState(
                        () {
                          _obscureText = !_obscureText;
                        },
                      );
                    },
                  )
                : null,
          ),
        ),
        if (widget.isError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              '*${widget.errorMessage}',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
