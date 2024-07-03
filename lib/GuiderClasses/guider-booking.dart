import 'package:bitirmes/CustomClass/ButtonWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/GuiderClasses/guider-selection.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GuiderBookingScreen extends StatefulWidget {
  final Guider guider;
  final int placeId;

  const GuiderBookingScreen({
    super.key,
    required this.guider,
    required this.placeId,
  });

  @override
  State<GuiderBookingScreen> createState() => _GuiderBookingScreenState();
}

class _GuiderBookingScreenState extends State<GuiderBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GuiderImage(guider: widget.guider),
                  Column(
                    children: [
                      Text(
                        widget.guider.fullName ?? '',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      GuiderRating(guider: widget.guider),
                    ],
                  ),
                  Text(
                    '${widget.guider.dailyPrice}\$',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            PickCalendar(
              guider: widget.guider,
              placeId: widget.placeId,
            ),
          ],
        ),
      ),
    );
  }
}

class PickCalendar extends StatefulWidget {
  final Guider guider;
  final int placeId;

  const PickCalendar({
    super.key,
    required this.guider,
    required this.placeId,
  });

  @override
  State<PickCalendar> createState() => _PickCalendarState();
}

class _PickCalendarState extends State<PickCalendar> {
  @override
  Widget build(BuildContext context) {
    final id = widget.guider.id;

    if (id == null) {
      return Text('error');
    }

    return FutureBuilder(
      future: LoginFormPage.currentCustomer.getGuiderReservedDates(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final reservations = snapshot.data as GuiderReservationList;
          return PickCalendarBody(
            guider: widget.guider,
            reservations: reservations,
            placeId: widget.placeId,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PickCalendarBody extends StatefulWidget {
  final Guider guider;
  final GuiderReservationList reservations;
  final int placeId;

  const PickCalendarBody({
    super.key,
    required this.guider,
    required this.reservations,
    required this.placeId,
  });

  @override
  State<PickCalendarBody> createState() => _PickCalendarBodyState();
}

class _PickCalendarBodyState extends State<PickCalendarBody> {
  DateTime? _selectedDay;

  List<DateTime> get bookedDates => widget.reservations.dates
      .map((e) => DateTime(e.year, e.month, e.day))
      .toList();
  // [
  //   DateTime.now(),
  //   DateTime.now().add(
  //     Duration(days: 1),
  //   ),
  // ].map((e) => DateTime(e.year, e.month, e.day)).toList();

  List<int> get workingDays => widget.guider.workingDays;

  void Function()? bookNow() {
    final guiderId = widget.guider.id;

    if (guiderId == null || _selectedDay == null) {
      return null;
    }

    return () async {
      setState(() {
        isLoading = true;
      });

      final res = await LoginFormPage.currentCustomer.reserveGuider(
        placeId: widget.placeId,
        guiderId: guiderId,
        date: _selectedDay!,
        totalPrice: widget.guider.dailyPrice!,
      );

      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Booking requested successfully'),
          ),
        );
        Navigator.of(context).popUntil(
          (route) {
            return route.isFirst;
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error'),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    };
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        children: [
          Center(
            child: Row(
              children: [
                SizedBox(
                  height: 400,
                  width: 320,
                  child: TableCalendar(
                    weekendDays: [],
                    onDaySelected: (selectedDay, focusedDay) {
                      if (selectedDay == _selectedDay) {
                        setState(() {
                          _selectedDay = null;
                        });
                        return;
                      }

                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return _selectedDay == day;
                    },
                    enabledDayPredicate: (day) {
                      // monday = 1
                      // tuesday = 2
                      // wednesday = 3
                      // ...
                      // ours starts from
                      // monday = 0
                      final weekdy = day.weekday - 1;

                      if (!workingDays.contains(weekdy)) {
                        return false;
                      }

                      return !bookedDates.any(
                        (element) =>
                            element.year == day.year &&
                            element.month == day.month &&
                            element.day == day.day,
                      );
                    },
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: "Book Now",
                  pressedKey: bookNow(),
                  styleParam: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorItems.projectGreen),
                    shadowColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
