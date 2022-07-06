import 'package:flutter/material.dart';

class InformationDialog extends StatelessWidget {
  final String? titleText;
  final String? contentText;
  final Widget? title;
  final Widget? content;

  const InformationDialog({
    Key? key,
    this.titleText,
    this.contentText,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(
      !(title != null && titleText != null),
      "Either one of title and titleText can be specified",
    );
    assert(
      !(content != null && contentText != null),
      "Either one of content and contentText can be specified",
    );

    return AlertDialog(
      title: titleText != null ? Text(titleText!) : title,
      content: contentText != null ? Text(contentText!) : content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
