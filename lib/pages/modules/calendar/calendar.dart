import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'components/details.dart';
import 'components/schedule.dart';
class AppointmentCalendar extends StatelessWidget {
  final int selectedServiceId;
  final String ownerShalonId; //


  AppointmentCalendar(this.selectedServiceId, this.ownerShalonId);
  
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
                  _navigateToAppointmentScheduleScreen(context, date, selectedServiceId, ownerShalonId);
                },
                child: Text('Agendar'),
              ),
            ],
          ),
        );
      },
    );
  }

 

  void _navigateToAppointmentScheduleScreen(BuildContext context, DateTime date, selectedServiceId, ownerShalonId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Schedule(date: date, ownerShalonId: ownerShalonId),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
