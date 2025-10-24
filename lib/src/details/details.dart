import 'package:flutter/material.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/src/details/details_view.dart';

class Details extends StatefulWidget {
  final User currentUser;
  const Details({super.key, required this.currentUser});

  @override
  DetailsView createState() => DetailsView();
}
