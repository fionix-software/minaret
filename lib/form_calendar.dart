import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime startDate, endDate;
  CalendarScreen(this.startDate, this.endDate);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  DateTime selectedDate = DateTime.now();

  // calendar library requires init state
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  // calendar library requires dispose
  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(context, 'Please select a date'),
          Text('Click on icon on bottom right to select'),
          buildSpaceSeparator(),
          buildCalendar(context),
          buildSpaceExpanded(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.check,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  // pop and send selected date to main page
                  Navigator.of(context).pop(_calendarController.selectedDay);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildCalendar(BuildContext context) {
    return TableCalendar(
      startDay: widget.startDate,
      endDay: widget.endDate,
      formatAnimation: FormatAnimation.scale,
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        centerHeaderTitle: true,
        leftChevronIcon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.white,
        ),
        rightChevronIcon: const Icon(
          FontAwesomeIcons.chevronRight,
          color: Colors.white,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayColor: Colors.transparent,
        todayStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        selectedColor: Theme.of(context).primaryColor,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
