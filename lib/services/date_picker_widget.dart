import 'package:flutter/material.dart';


class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.child,
    required this.today,
    required this.onChanged,
    required this.wednesday,
    this.getTime = false,
    this.enabled,
  });

  final Widget child;
  final bool today;
  final bool wednesday;
  final bool getTime;
  final bool? enabled;
  final Function(DateTime? dateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = today ? DateTime.now().add(Duration(days:  1)) : DateTime.now();

    // Ensure initialDate satisfies selectableDayPredicate
    if (wednesday && initialDate.weekday == DateTime.wednesday) {
      initialDate = initialDate.add(const Duration(days: 1)); // Skip Wednesday if today and it's a Wednesday
    }

    return GestureDetector(
      onTap: () {
        if (enabled ?? true) {
          showDatePicker(
            selectableDayPredicate: (DateTime day) {
              if (wednesday && day.weekday == DateTime.wednesday) {
                return false; // Disable Wednesday if selecting for today
              } else {
                return true; // Allow all days otherwise
              }
            },
            context: context,
            initialDate: initialDate,
            firstDate: today ? DateTime.now().add(Duration(days:1)) : DateTime(1940),
            lastDate: today
                ? DateTime.now().add(Duration(days: 1))
                : DateTime.now().add(const Duration(days: 356 * 10)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: TextTheme(
                    headlineMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 20.0,
                        ),
                  ),
                  colorScheme: ColorScheme.light(
                    primary: Colors.black, // header background color
                    onPrimary: Colors.white, // header text color
                    onSurface: Colors.black, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          ).then((dateValue) {
            if (dateValue != null && getTime) {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: TextTheme(
                        headlineMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 20.0,
                            ),
                      ),
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor, // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: Theme.of(context).primaryColor, // body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              ).then((value) {
                if (value != null) {
                  onChanged(DateTime(dateValue.year, dateValue.month, dateValue.day, value.hour, value.minute));
                }
              });
            } else {
              onChanged(dateValue);
            }
          });
        }
      },
      child: child,
    );
  }
}
