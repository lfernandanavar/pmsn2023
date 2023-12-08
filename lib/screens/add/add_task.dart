import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/database/teacher_controller.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/services/notification_services.dart';
import 'package:pmsn20232/services/provider/tasks_provider.dart';
import 'package:pmsn20232/utils/messages.dart';
import 'package:pmsn20232/widgets/dropdown_widget.dart';
import 'package:pmsn20232/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // ignore: prefer_final_fields
  var _currentTime = TimeOfDay.now();
  AgendaDB? agendaDB;
  TaskModel? args;
  final textName =
      TxtTextField(placeholder: "Name Task", type: TextInputType.name);

  final textDsc =
      TxtTextField(placeholder: "Description", type: TextInputType.text);

  DropDownWidget? dropDownWidget;
  DropDownWidget? dropDownTeacher;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime initSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 1)));

    if (picked != null && picked != endSelectedDate) {
      setState(() {
        endSelectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
  }

  void verifyIsEditting(data) {
    String stt;
    if (data == null) {
      args = null;
      return;
    }

    args = data as TaskModel;
    textName.controller.text = args!.nameTask!;
    textDsc.controller.text = args!.dscTask!;
    stt = args!.sttTask!.substring(0, 1);
    var value = '';
    switch (stt) {
      case 'E':
        value = 'En proceso';
        break;
      case 'C':
        value = 'Completado';
        break;
      case 'P':
        value = 'Pendiente';
        break;
      default:
        value = 'Pendiente';
    }
    dropDownWidget = DropDownWidget(
      controller: value,
      values: const <String>['Pendiente', 'En proceso', 'Completado'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    var data = ModalRoute.of(context)?.settings.arguments;
    if (data != null) {
      verifyIsEditting(data);
    } else {
      dropDownWidget = DropDownWidget(
        controller: 'Pendiente',
        values: const <String>['Pendiente', 'En proceso', 'Completado'],
      );
    }

    const space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = ElevatedButton(
        onPressed: () {
          if (textName.text.isEmpty || textDsc.text.isEmpty) {
            Messages().failMessage(Messages().empty, context);
            return;
          }
          final flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          // Llama a la función para programar una notificación
          NotificationService().scheduleNotification(
            flutterLocalNotificationsPlugin,
            initSelectedDate.year,
            initSelectedDate.month,
            initSelectedDate.day,
            _currentTime.hour,
            _currentTime.minute,
            textName.text,
            textDsc.text,
          );

          String formatDate =
              "${initSelectedDate.toString().substring(0, 10)} ${_currentTime.hour}:${_currentTime.minute}:00";

          // Llama a la función para programar una notificación
          args == null
              ? agendaDB!.INSERT('tblTareas', {
                  'nameTask': textName.text,
                  'dscTask': textDsc.text,
                  'sttTask': dropDownWidget!.controller!.substring(0, 1),
                  'initDate': formatDate,
                  'endDate': endSelectedDate.toString().substring(0, 19),
                }).then((value) {
                  if (value > 0) {
                    Messages().okMessage(Messages().okInsert, context);
                  } else {
                    Messages().failMessage(Messages().failInsert, context);
                  }
                  provider.isUpdated = !provider.isUpdated;
                  Navigator.pop(context);
                })
              : agendaDB!.UPDATE('tblTareas', {
                  'idTask': args!.idTask,
                  'nameTask': textName.text,
                  'dscTask': textDsc.text,
                  'sttTask': dropDownWidget!.controller!.substring(0, 1),
                  'initDate': initSelectedDate.toString().substring(0, 19),
                  'endDate': endSelectedDate.toString().substring(0, 19),
                }).then((value) {
                  if (value > 0) {
                    Messages().okMessage(Messages().okUpdate, context);
                  } else {
                    Messages().failMessage(Messages().failUpdate, context);
                  }
                  provider.isUpdated = !provider.isUpdated;
                  Navigator.pop(context);
                });
        },
        child: const Text('Save Task'));
    return Scaffold(
      appBar: AppBar(
        title: Text("${args == null ? 'Add' : 'Update'} Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textName,
            space,
            textDsc,
            buildDateEndSelector(context, "Fecha Final"),
            buildDateInitSelector(context, "Recordatorio"),
            buildTimeSelector(context, "Hora"),
            futureBuilder(),
            btnGuardar,
          ],
        ),
      ),
    );
  }

  Widget buildDateEndSelector(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly:
            true, // Evita que se pueda editar el campo de texto directamente
        controller: TextEditingController(
          text: dateFormat
              .format(endSelectedDate), // Muestra la fecha seleccionada
        ),

        decoration: InputDecoration(
          labelText: title,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () {
          _selectDateEnd(
              context); // Abre el selector de fecha al tocar en cualquier parte del campo
        },
        // Añade el sufijo del ícono para indicar que es un campo de fecha
      ),
    );
  }

  Widget buildDateInitSelector(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly:
            true, // Evita que se pueda editar el campo de texto directamente
        controller: TextEditingController(
          text: dateFormat
              .format(initSelectedDate), // Muestra la fecha seleccionada
        ),

        decoration: InputDecoration(
          labelText: title,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () {
          _selectDateInit(
              context); // Abre el selector de fecha al tocar en cualquier parte del campo
        },
        // Añade el sufijo del ícono para indicar que es un campo de fecha
      ),
    );
  }

  FutureBuilder<List<String>> futureBuilder() {
    return FutureBuilder<List<String>>(
      future: TeacherController()
          .getAllStringName(), // Llama a tu función que devuelve el Future<List<String>>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el Future, muestra un indicador de carga
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error, muestra un mensaje de error
          return Text('Error: ${snapshot.error}');
        } else {
          // Una vez que el Future se completa con éxito, muestra los datos en un ListView
          final data = snapshot.data;
          if (data == null) {
            dropDownTeacher = DropDownWidget();
          } else {
            dropDownTeacher = DropDownWidget(
              values: data,
              controller: data[0],
              labelText: "Teacher",
            );
          }
          return dropDownTeacher!;
        }
      },
    );
  }

  Future<void> _selectDateInit(BuildContext context) async {
    final DateTime? picked = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 1)));

    if (picked != null && picked != initSelectedDate) {
      setState(() {
        initSelectedDate = picked;
      });
    }
  }

  // Time
  void callTimePicker() async {
    var selectedTime = await (showTimePicker(
      context: context,
      initialTime: _currentTime,
      builder: (context, child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    ));
    setState(() {
      _currentTime = selectedTime!;
    });
  }

  Widget buildTimeSelector(BuildContext context, String title) {
    return TextFormField(
      readOnly:
          true, // Evita que se pueda editar el campo de texto directamente
      controller: TextEditingController(
        text: _currentTime.format(context), // Muestra la fecha seleccionada
      ),

      decoration: InputDecoration(
        labelText: title,
        suffixIcon: const Icon(Icons.alarm),
      ),
      onTap: () {
        callTimePicker(); // Abre el selector de fecha al tocar en cualquier parte del campo
      },
      // Añade el sufijo del ícono para indicar que es un campo de fecha
    );
  }
}
