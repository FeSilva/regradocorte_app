import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'components/details.dart';
import 'components/schedule.dart';
class AppointmentCalendar extends StatelessWidget {
  final int selectedServiceId;

  AppointmentCalendar(this.selectedServiceId);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: AppointmentDataSource(_getAppointments()),
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.calendarCell) {
              DateTime tappedDate = details.date!;
              _showBottomSheet(context, tappedDate);
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
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Reunião importante',
        color: Colors.blue,
      ),
    ];
  }

  void _showBottomSheet(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fechar o modal
                  _navigateToAppointmentDetailsScreen(context, date);
                },
                child: Text('Ver Agendamento'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fechar o modal
                  _navigateToAppointmentScheduleScreen(context, date, selectedServiceId);
                },
                child: Text('Agendar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToAppointmentDetailsScreen(BuildContext context, DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detailSchedule(date: date),
      ),
    );
  }

  void _navigateToAppointmentScheduleScreen(BuildContext context, DateTime date, selectedServiceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Schedule(date: date, serviceId: selectedServiceId),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
