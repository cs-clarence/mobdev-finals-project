import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

extension ValidationBuilderExtention on ValidationBuilder {
  ValidationBuilder maybeAdd<T>(FormFieldValidator<String>? validator) {
    if (validator != null) add(validator);
    return this;
  }
}
