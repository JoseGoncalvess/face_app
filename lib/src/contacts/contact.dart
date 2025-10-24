import 'package:flutter/material.dart';
import 'package:persona_app/src/contacts/contact_view.dart';

class Contact extends StatefulWidget {
  final bool isconnectState;
  const Contact({super.key, required this.isconnectState});

  @override
  ContactView createState() => ContactView();
}
