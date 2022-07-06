part of "parts_list.dart";

enum PcPartFormMode {
  edit,
  create;
}

class PcPartForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final PcPartFormMode mode;
  final String titleText;
  final String? submitButtonText;
  final Map<String, dynamic>? initialValue;
  final FutureOr<void> Function(Map<String, dynamic>)? onSubmit;
  final FutureOr<void> Function()? onCancel;

  PcPartForm({
    super.key,
    this.mode = PcPartFormMode.create,
    required this.titleText,
    this.submitButtonText,
    this.initialValue,
    this.onSubmit,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final required = ValidationBuilder().required().build();
    const columnGap = 16.0;
    return FormBuilder(
      initialValue: initialValue ?? {},
      key: _formKey,
      child: Column(
        children: [
          Text(
            titleText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (mode != PcPartFormMode.edit) ...[
            const SizedBox(height: columnGap),
            FormBuilderTextField(
              name: "upc",
              validator: ValidationBuilder()
                  .regExp(RegExp(r"^\d-\d{6}-\d{6}$"),
                      "Should follow the format #-######-###### Ex. 9-234234-456456")
                  .build(),
              decoration: const InputDecoration(
                labelText: "UPC",
              ),
            ),
          ],
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "brand",
            validator: required,
            decoration: const InputDecoration(
              labelText: "Brand",
            ),
          ),
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "name",
            validator: required,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
          ),
          if (mode != PcPartFormMode.edit) ...[
            const SizedBox(height: columnGap),
            FormBuilderDropdown<String>(
              items: const [
                DropdownMenuItem(value: "cpu", child: Text("CPU")),
                DropdownMenuItem(
                    value: "motherboard", child: Text("Motherboard")),
                DropdownMenuItem(value: "ram", child: Text("RAM")),
                DropdownMenuItem(
                    value: "video-card", child: Text("Video Card")),
                DropdownMenuItem(
                    value: "power-supply", child: Text("Power Supply")),
                DropdownMenuItem(
                    value: "pc-chassis", child: Text("PC Chassis")),
              ],
              name: "type",
              validator: required,
              decoration: const InputDecoration(
                labelText: "Type",
              ),
            ),
          ],
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "price",
            keyboardType: TextInputType.number,
            validator: ValidationBuilder()
                .required()
                .regExp(RegExp(r"^\d+(?:\.\d+)?$"),
                    "Should be a valid number format")
                .build(),
            inputFormatters: [
              FilteringTextInputFormatter(RegExp(r"[.\d]"), allow: true)
            ],
            valueTransformer: (value) =>
                value != null ? double.parse(value) : null,
            decoration: const InputDecoration(
              labelText: "Price (PHP)",
            ),
          ),
          const SizedBox(height: columnGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    onSubmit?.call({
                      "upc": _formKey.currentState!.getTransformedValue("upc"),
                      "brand":
                          _formKey.currentState!.getTransformedValue("brand"),
                      "name":
                          _formKey.currentState!.getTransformedValue("name"),
                      "type":
                          _formKey.currentState!.getTransformedValue("type"),
                      "price":
                          _formKey.currentState!.getTransformedValue("price"),
                    });
                  }
                },
                child: Text(
                  submitButtonText ??
                      (mode == PcPartFormMode.create
                          ? "CREATE USER"
                          : "EDIT USER"),
                ),
              ),
              const SizedBox(width: 32),
              OutlinedButton(
                onPressed: onCancel,
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PcPartFormDialog extends StatelessWidget {
  final String titleText;
  final String? submitButtonText;
  final PcPartFormMode mode;
  final Map<String, dynamic>? initialValue;

  const PcPartFormDialog({
    super.key,
    this.initialValue,
    required this.titleText,
    this.mode = PcPartFormMode.create,
    this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: PcPartForm(
            titleText: titleText,
            mode: mode,
            initialValue: initialValue,
            submitButtonText: submitButtonText,
            onSubmit: (values) {
              Navigator.of(context).pop(values);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
