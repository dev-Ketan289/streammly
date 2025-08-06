import 'dart:convert';

class WorkingDay {
  final String days;
  final String? time;

  WorkingDay({required this.days, this.time});

  factory WorkingDay.fromJson(Map<String, dynamic> json) => WorkingDay(
        days: json['days'],
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        'days': days,
        'time': time,
      };
}

class CompanyBusinessSettings {
    String? companyId;
    String? companyWorkingDays;
    String? advanceAmountPercentage;
    String? advanceBookingDays;
    String? workingShedule;
    String? email;
    String? mobile;
    String? editTeamSupportNumber;
    String? salesTeamSupportNumber;
    String? disclaimer;

    CompanyBusinessSettings({
        this.companyId,
        this.companyWorkingDays,
        this.advanceAmountPercentage,
        this.advanceBookingDays,
        this.workingShedule,
        this.email,
        this.mobile,
        this.editTeamSupportNumber,
        this.salesTeamSupportNumber,
        this.disclaimer,
    });

    factory CompanyBusinessSettings.fromJson(Map<String, dynamic> json) => CompanyBusinessSettings(
        companyId: json["company_id"],
        companyWorkingDays: json["company_working_days"],
        advanceAmountPercentage: json["advance_amount_percentage"],
        advanceBookingDays: json["advance_booking_days"],
        workingShedule: json["working_shedule"],
        email: json["email"],
        mobile: json["mobile"],
        editTeamSupportNumber: json["edit_team_support_number"],
        salesTeamSupportNumber: json["sales_team_support_number"],
        disclaimer: json["disclaimer"],
    );

    Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "company_working_days": companyWorkingDays,
        "advance_amount_percentage": advanceAmountPercentage,
        "advance_booking_days": advanceBookingDays,
        "working_shedule": workingShedule,
        "email": email,
        "mobile": mobile,
        "edit_team_support_number": editTeamSupportNumber,
        "sales_team_support_number": salesTeamSupportNumber,
        "disclaimer": disclaimer,
    };

    // Function to get map of all days with their time slots (or "Closed")
    Map<String, String> getDayTimeSlots() {
      final List<String> allDays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      ];
      final Map<String, String> result = {for (var day in allDays) day: "Closed"};

      if (companyWorkingDays == null) return result;

      // Parse the JSON string into a list of WorkingDay objects
      final List<dynamic> decoded = jsonDecode(companyWorkingDays!) as List;
      final List<WorkingDay> workingDays = decoded.map((item) => WorkingDay.fromJson(item)).toList();

      for (var workingDay in workingDays) {
        String daysStr = workingDay.days.trim();
        String? time = workingDay.time ?? "Not specified";
        // Handle range format like "Monday - Friday"
        if (daysStr.contains('-')) {
          var range = daysStr.split('-').map((s) => s.trim()).toList();
          if (range.length == 2) {
            int startIndex = allDays.indexOf(range[0]);
            int endIndex = allDays.indexOf(range[1]);
            if (startIndex != -1 && endIndex != -1 && startIndex <= endIndex) {
              for (var day in allDays.sublist(startIndex, endIndex + 1)) {
                result[day] = time;
              }
            }
          }
        } else {
          // Handle single day or comma-separated days
          var days = daysStr.split(',').map((s) => s.trim()).toList();
          for (var day in days) {
            if (allDays.contains(day)) {
              result[day] = time;
            }
          }
        }
      }

      return result;
    }
}