part of "user.dart";

enum UserFormMode {
  edit,
  create;
}

class UserForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final UserFormMode mode;
  final String titleText;
  final String? submitButtonText;
  final Map<String, dynamic>? initialValue;
  final FutureOr<void> Function(Map<String, dynamic>)? onSubmit;
  final FutureOr<void> Function()? onCancel;

  UserForm({
    super.key,
    this.mode = UserFormMode.create,
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
          const SizedBox(height: columnGap),
          Text(
            "Account",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: columnGap),
          FormBuilderUserNameField(
            name: "userName",
          ),
          const SizedBox(height: columnGap),
          FormBuilderEmailField(
            name: "email",
          ),
          const SizedBox(height: columnGap),
          const FormBuilderPasswordField(
            name: "password",
          ),
          const SizedBox(height: columnGap),
          FormBuilderRadioGroup<int>(
            options: const [
              FormBuilderFieldOption(
                value: 0,
                child: Text("0 - Regular"),
              ),
              FormBuilderFieldOption(
                value: 10,
                child: Text("10 - Admin"),
              ),
            ],
            validator: (value) => required(value != null ? "$value" : null),
            decoration: const InputDecoration(
              labelText: "Access Level",
            ),
            name: "accessLevel",
          ),
          const SizedBox(height: columnGap),
          const Divider(),
          const SizedBox(height: columnGap),
          Text(
            "Profile",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "firstName",
            validator: required,
            decoration: const InputDecoration(
              labelText: "First Name",
            ),
          ),
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "middleName",
            decoration: const InputDecoration(
              labelText: "Middle Name",
            ),
          ),
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "lastName",
            validator: required,
            decoration: const InputDecoration(
              labelText: "Last Name",
            ),
          ),
          const SizedBox(height: columnGap),
          FormBuilderTextField(
            name: "nameSuffix",
            decoration: const InputDecoration(
              labelText: "Name Suffix",
            ),
          ),
          const SizedBox(height: columnGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final userName =
                        _formKey.currentState!.getTransformedValue("userName");
                    final password =
                        _formKey.currentState!.getTransformedValue("password");
                    final email =
                        _formKey.currentState!.getTransformedValue("email");
                    final accessLevel = _formKey.currentState!
                        .getTransformedValue("accessLevel");
                    final firstName =
                        _formKey.currentState!.getTransformedValue("firstName");
                    final middleName = _formKey.currentState!
                        .getTransformedValue("middleName");
                    final lastName =
                        _formKey.currentState!.getTransformedValue("lastName");
                    final nameSuffix = _formKey.currentState!
                        .getTransformedValue("nameSuffix");

                    onSubmit?.call({
                      "userName": userName,
                      "password": password,
                      "email": email,
                      "accessLevel": accessLevel,
                      "firstName": firstName,
                      "middleName": middleName,
                      "lastName": lastName,
                      "nameSuffix": nameSuffix,
                    });
                  }
                },
                child: Text(
                  submitButtonText ??
                      (mode == UserFormMode.create
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

class UserFormDialog extends StatelessWidget {
  final String titleText;
  final String? submitButtonText;
  final UserFormMode mode;
  final Map<String, dynamic>? initialValue;

  const UserFormDialog({
    super.key,
    this.initialValue,
    required this.titleText,
    this.mode = UserFormMode.create,
    this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: UserForm(
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
