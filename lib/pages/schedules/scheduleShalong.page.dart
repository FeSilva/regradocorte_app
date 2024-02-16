import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'components/details.dart';

class ScheduleShalonPage extends StatefulWidget {
  @override
  _ScheduleShalonPageState createState() => _ScheduleShalonPageState();
}

class _ScheduleShalonPageState extends State<ScheduleShalonPage> {
  CalendarView _calendarView = CalendarView.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _showCalendarViewDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        child: SfCalendar(
          key: UniqueKey(),
          view: _calendarView,
          dataSource: AppointmentDataSource(_getAppointments()),
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.appointment) {
              _showBottomSheet(context, details.appointments![0]);
            }
          },
          appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
            // Verificar se há agendamentos antes de acessar
            if (details.appointments != null && details.appointments!.isNotEmpty) {
              var firstAppointment = details.appointments!.first;

              return Container(
                color: firstAppointment.color,
                child: Center(
                  child: Text(
                    firstAppointment.subject,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              // Tratamento para o caso de não haver agendamentos
              return Container(); // ou outro widget apropriado
            }
          },
        ),
      ),
    );
  }

  List<Appointment> _getAppointments() {
    return <Appointment>[
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(minutes: 30)),
        subject: 'Felipe Feitosa',
        color: Colors.orange,
        notes: 'Mais informações sobre o agendamento...',
      ),
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(minutes: 30)),
        subject: 'Eduardo Dourado',
        color: Colors.green,
        notes: ' - Corte de cabelo \n - Barba',
      ),
    ];
  }

  void _showBottomSheet(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agendamento: ${appointment.subject}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('Data: ${appointment.startTime}'),
              SizedBox(height: 10),
              Text('Observações: ${appointment.notes}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fechar o modal
                  _navigateToAppointmentScheduleScreen(context, appointment.startTime);
                },
                child: Text('Consultar Agendamentos'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCalendarViewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione a visualização da agenda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Mês'),
                onTap: () {
                  _changeCalendarView(CalendarView.month);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Semana'),
                onTap: () {
                  _changeCalendarView(CalendarView.week);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Dia'),
                onTap: () {
                  _changeCalendarView(CalendarView.day);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeCalendarView(CalendarView view) {
    setState(() {
      _calendarView = view;
    });
  }

  void _navigateToAppointmentScheduleScreen(BuildContext context, DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detailShalonSchedule(date: date),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
