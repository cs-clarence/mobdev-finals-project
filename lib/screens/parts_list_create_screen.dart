import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_parts_list/features/parts_list/parts_list.dart';
import 'package:pc_parts_list/features/user/user.dart';

class PartsListCreateScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  PartsListCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Part List"),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FormBuilder(
              key: _formKey,
              child: BlocBuilder<PcPartsBloc, PcPartsState>(
                builder: (context, state) {
                  if (state is PcPartsLoadSuccess) {
                    final required = ValidationBuilder().required().build();

                    final cpus =
                        state.pcParts.where((value) => value.type == "cpu");

                    final motherboards = state.pcParts
                        .where((value) => value.type == "motherboard");

                    final rams =
                        state.pcParts.where((value) => value.type == "ram");

                    final videoCards = state.pcParts
                        .where((value) => value.type == "video-card");

                    final pcChassis = state.pcParts
                        .where((value) => value.type == "pc-chassis");

                    final powerSupplies = state.pcParts
                        .where((value) => value.type == "power-supply");

                    List<DropdownMenuItem<String>> pcPartsToDropDownMenuItems(
                      Iterable<PcPartModel> pcParts,
                    ) {
                      return pcParts
                          .map((e) => DropdownMenuItem<String>(
                                value: e.upc,
                                child: Text(
                                    "${e.brand} ${e.name} - PHP ${e.price}"),
                              ))
                          .toList();
                    }

                    return Column(
                      children: [
                        FormBuilderTextField(
                          name: "partsListName",
                          decoration: const InputDecoration(
                              labelText: "Parts List Name"),
                          validator: required,
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "cpuUpc",
                          decoration: const InputDecoration(
                            labelText: "CPU",
                          ),
                          items: pcPartsToDropDownMenuItems(cpus),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "motherboardUpc",
                          decoration: const InputDecoration(
                            labelText: "Motherboard",
                          ),
                          items: pcPartsToDropDownMenuItems(motherboards),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "ramUpc",
                          decoration: const InputDecoration(
                            labelText: "RAM",
                          ),
                          items: pcPartsToDropDownMenuItems(rams),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "videoCardUpc",
                          decoration: const InputDecoration(
                            labelText: "Video Card",
                          ),
                          items: pcPartsToDropDownMenuItems(videoCards),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "powerSupplyUpc",
                          decoration: const InputDecoration(
                            labelText: "Power Supply",
                          ),
                          items: pcPartsToDropDownMenuItems(powerSupplies),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderDropdown<String>(
                          name: "pcChassisUpc",
                          decoration: const InputDecoration(
                            labelText: "PC Chassis",
                          ),
                          items: pcPartsToDropDownMenuItems(pcChassis),
                        ),
                        const SizedBox(height: 32),
                        OutlinedButton(
                          child: const Text("Create"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final partsListName = _formKey.currentState!.getTransformedValue("partsListName") as String;
                              final userName = (context.read<UserBloc>().state as UserLoadSuccess).user.account.userName;
                              final partsUpcs = <String?>[
                                _formKey.currentState!.getTransformedValue("cpuUpc") as String?,
                                _formKey.currentState!.getTransformedValue("motherboardUpc") as String?,
                                _formKey.currentState!.getTransformedValue("ramUpc") as String?,
                                _formKey.currentState!.getTransformedValue("videoCardUpc") as String?,
                                _formKey.currentState!.getTransformedValue("powerSupplyUpc") as String?,
                                _formKey.currentState!.getTransformedValue("pcChassisUpc") as String?,
                              ];

                              context.read<PartsListsBloc>().add(
                                    PartsListsForUserCreated(
                                      userName: userName,
                                      partsListName: partsListName,
                                      partsUpcs: partsUpcs.where((element) => element != null).map((e) => e as String),
                                    ),
                                  );
                              context.pop();
                            }
                          },
                        ),
                      ],
                    );
                  } else if (state is PcPartsLoadInProgress ||
                      state is PcPartsInitial) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text("Can't load PC Parts");
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
