import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Instanciamos la base de datos
  AgendaDB db = AgendaDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: db.GETALLTASK(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return _getTareasForDay(day, snapshot.data!);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _showTareaDetails(selectedDay, snapshot.data!);
                  });
                }
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ocurrió un error'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<TaskModel> _getTareasForDay(DateTime day, List<TaskModel> tareas) {
    // Filtramos las tareas basadas en la fecha
    return tareas.where((tarea) => isSameDay(tarea.getDateFrom(tarea.initDate), day)).toList();
  }

  void _showTareaDetails(DateTime day, List<TaskModel> tareas) {
    // Obtenemos las tareas para el día seleccionado
    List<TaskModel> tareasForDay = _getTareasForDay(day, tareas);

    // Mostramos un modal con los detalles de las tareas
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: tareasForDay.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(tareasForDay[index].nameTask!),
              subtitle: Text('Descripción: ${tareasForDay[index].dscTask}\nEstatus: ${tareasForDay[index].sttTask == 'C' ? 'Realizada' : 'No realizada'}'),
            );
          },
        );
      },
    );
  }
}
// honores al samuel :p