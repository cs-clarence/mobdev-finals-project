import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pc_parts_list/common/widgets/validation_builder_extension.dart';

class FormBuilderUserNameField extends FormBuilderTextField {
  FormBuilderUserNameField({
    required super.name,
    super.controller,
    super.key,
    super.cursorColor,
    super.toolbarOptions,
    super.cursorRadius,
    super.cursorWidth,
    super.enabled,
    super.keyboardType,
    super.keyboardAppearance,
    super.autofocus,
    super.enableSuggestions,
    super.enableInteractiveSelection,
    super.dragStartBehavior,
    super.expands,
    super.maxLines,
    super.minLines,
    super.onSubmitted,
    super.onChanged,
    super.onEditingComplete,
    super.onReset,
    super.onSaved,
    super.onTap,
    super.readOnly,
    super.maxLengthEnforcement,
    super.mouseCursor,
    super.obscureText,
    super.style,
    super.obscuringCharacter,
    super.scrollPhysics,
    super.scrollController,
    super.scrollPadding,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.showCursor,
    super.smartDashesType,
    super.smartQuotesType,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textCapitalization,
    super.textDirection,
    super.textInputAction,
    super.inputFormatters,
    super.autocorrect,
    super.autofillHints,
    super.autovalidateMode,
    super.buildCounter,
    super.focusNode,
    super.initialValue,
    super.valueTransformer,
    FormFieldValidator<String>? validator,
    int minLength = 8,
    int maxLength = 100000,
  }) : super(
          decoration: const InputDecoration(
            label: Text("Username"),
          ),
          validator: ValidationBuilder()
              .regExp(
                RegExp(r"^\w+$", multiLine: true),
                "Should only contain letters, numbers, and/or underscores",
              )
              .maybeAdd(validator)
              .minLength(minLength)
              .maxLength(maxLength)
              .required()
              .build(),
        );
}
