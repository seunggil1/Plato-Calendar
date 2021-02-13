import 'package:flutter/material.dart';
import 'package:plato_calendar/ics.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import './plato.dart';

// 프록시 사용할 떄 주석 해제 처리.
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
void main() {
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    //a.login().then((value) => a.getCalendar());
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: FutureBuilder(
            future: _getCalendarDataSource(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return SfCalendar(
                headerHeight: 30,
                view: CalendarView.month,
                firstDayOfWeek: 0, // 한주의 시작 - 0: 일, 1: 월 ..
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  monthCellStyle: MonthCellStyle()),
                dataSource: snapshot.hasData ? snapshot.data : DataSource(List<Appointment>())
              );
            }
          ),
        )
      )
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

Future<DataSource> _getCalendarDataSource() async {
  await icsParser();
  List<Appointment> appointments = <Appointment>[];
  for(var iter in data)
    appointments.add(iter.toAppointment());
  
  return DataSource(appointments);
}