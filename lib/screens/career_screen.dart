import 'package:flutter/material.dart';
import 'package:pmsn20232/database/career_controller.dart';
import 'package:pmsn20232/models/career_model.dart';
import 'package:pmsn20232/services/provider/global_provider.dart';
import 'package:pmsn20232/widgets/cards/card_career_widget.dart';
import 'package:pmsn20232/widgets/filter_widget.dart';
import 'package:provider/provider.dart';

class CareerScreen extends StatefulWidget {
  final String title;
  const CareerScreen({super.key, required this.title});
  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  CareerController? careerController;
  FilterWidget? filterText;

  @override
  void initState() {
    super.initState();
    careerController = CareerController();
    filterText = FilterWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addCareer')
                    .then((value) => {setState(() {})});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Stack(
        children: [
          filterText!,
          select(context),
        ],
      ), // children: [filtered(context)],
    );
  }

  FutureBuilder<List<CareerModel>> select(context) {
    final provider = Provider.of<GlobalProvider>(context);
    if (provider.isUpdated) {
      return getList();
    }
    return getList();
  }

  FutureBuilder<List<CareerModel>> getList() {
    return FutureBuilder(
        future: filterText!.txtController.text.isEmpty
            ? careerController!.get()
            : careerController!.getCareerByName(filterText!.txtController.text),
        builder:
            (BuildContext context, AsyncSnapshot<List<CareerModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error!'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        });
  }

  Widget buildList(info) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
      child: ListView.builder(
          itemCount: info!.length, //snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return CardCareerWidget(
              careerController!,
              careerModel: info![index],
            );
          }),
    );
  }
}
