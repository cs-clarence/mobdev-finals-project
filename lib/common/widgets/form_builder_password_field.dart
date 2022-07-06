import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pc_parts_list/common/widgets/validation_builder_extension.dart';

class FormBuilderPasswordField extends StatefulWidget {
  final String? initialValue;
  final int minLength;
  final int maxLength;
  final bool enabled;
  final String name;
  final ValueChanged<String>? onChanged;
  final InputDecoration decoration;
  final ValueTransformer<String?>? valueTransformer;
  final FormFieldValidator<String>? validator;

  const FormBuilderPasswordField({
    Key? key,
    this.initialValue,
    required this.name,
    this.onChanged,
    this.valueTransformer,
    this.validator,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    this.maxLength = 100000,
    this.minLength = 8,
  }) : super(key: key);

  @override
  State<FormBuilderPasswordField> createState() =>
      _FormBuilderPasswordFieldState();
}

class _FormBuilderPasswordFieldState extends State<FormBuilderPasswordField> {
  bool _showPassword = false;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validator = ValidationBuilder()
        .required()
        .minLength(widget.minLength)
        .maxLength(widget.maxLength);

    if (widget.validator != null) {
      validator.add(widget.validator!);
    }

    final decoration = InputDecoration(
      labelText: "Password",
      suffixIcon: ExcludeFocus(
        child: IconButton(
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          icon: _showPassword
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
    );

    return FormBuilderTextField(
      obscureText: !_showPassword,
      valueTransformer: widget.valueTransformer,
      name: widget.name,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      decoration: decoration,
      validator: validator.build(),
    );
  }
}
