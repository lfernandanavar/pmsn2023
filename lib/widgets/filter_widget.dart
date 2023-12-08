import 'package:flutter/material.dart';
import 'package:pmsn20232/services/provider/global_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FilterWidget extends StatelessWidget {
  FilterWidget({super.key});

  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    return Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Search Bar'),
                border: OutlineInputBorder(),
              ),
              controller: txtController,
            ),
            ElevatedButton(
              onPressed: () {
                provider.isUpdated = !provider.isUpdated;
              },
              child: const Text("Find"),
            )
          ],
        ));
  }
}
