import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pc_parts_list/common/widgets/form_builder_email_field.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../common/widgets/form_builder_password_field.dart';
import '../../common/widgets/form_builder_user_name_field.dart';

part "parts_list.g.dart";
part "./parts_list_model.dart";
part "./pc_part_model.dart";
part "./parts_lists_bloc.dart";
part "./parts_list_repository.dart";
part "./pc_part_repository.dart";
part "./pc_parts_bloc.dart";
part "./pc_part_form.dart";