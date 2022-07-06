import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_parts_list/common/widgets/confirmation_dialog.dart';
import 'package:pc_parts_list/features/parts_list/parts_list.dart';

class PcPartsScreen extends StatelessWidget {
  const PcPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PC Parts"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final add = context.read<PcPartsBloc>().add;
          final result = await showDialog<Map<String, dynamic>?>(
            context: context,
            builder: (context) {
              return const PcPartFormDialog(
                titleText: "CREATE USER",
                submitButtonText: "Save",
                mode: PcPartFormMode.create,
              );
            },
          );
          if (result != null) {
            add(PcPartsCreated(
              upc: result["upc"],
              price: result["price"],
              brand: result["brand"],
              name: result["name"],
              type: result["type"],
            ));
          }
        },
      ),
      body: BlocBuilder<PcPartsBloc, PcPartsState>(
        builder: (context, state) {
          if (state is PcPartsLoadSuccess) {
            return SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Action")),
                    DataColumn(label: Text("UPC")),
                    DataColumn(label: Text("Part Type")),
                    DataColumn(label: Text("Brand")),
                    DataColumn(label: Text("Part Name")),
                    DataColumn(label: Text("Price")),
                  ],
                  rows: [
                    for (final pcPart in state.pcParts)
                      DataRow(cells: [
                        DataCell(PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == "delete") {
                              void deleteIt() => context
                                  .read<PcPartsBloc>()
                                  .add(PcPartsDeleted(pcPart.upc));
                              final result = await showDialog<bool?>(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  titleText:
                                      "Delete PC Part ${pcPart.brand} ${pcPart.name}?",
                                  contentText: "This action is irreversible.",
                                ),
                              );

                              if (result == true) deleteIt();
                            } else if (value == "edit") {
                              final pcPartsBloc = context.read<PcPartsBloc>();

                              final result =
                                  await showDialog<Map<String, dynamic>?>(
                                context: context,
                                builder: (context) {
                                  return PcPartFormDialog(
                                    initialValue: {
                                      "brand": pcPart.brand,
                                      "name": pcPart.name,
                                      "price": pcPart.price.toString(),
                                    },
                                    titleText: "EDIT ${pcPart.upc}",
                                    submitButtonText: "Update",
                                    mode: PcPartFormMode.edit,
                                  );
                                },
                              );
                              if (result != null) {
                                pcPartsBloc.add(
                                  PcPartsUpdated(
                                    upc: pcPart.upc,
                                    newPrice: result["price"],
                                    newName: result["name"],
                                    newBrand: result["brand"],
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        )),
                        DataCell(Text(pcPart.upc)),
                        DataCell(Text(pcPart.type)),
                        DataCell(Text(pcPart.brand)),
                        DataCell(Text(pcPart.name)),
                        DataCell(Text("${pcPart.price}"))
                      ]),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
