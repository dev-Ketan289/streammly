  import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class CustomBookingcard extends StatelessWidget {
  final String bookingId;
  final String otp;
  final String title;
  final String type;
  final String location;
  final String date;
  final String time;
  final String? status;
  final Color? statusColor;
  final bool showReschedule;
  final bool showActionButtons;
  final String? topActionLabel;
  final VoidCallback? onTopAction;
  final String leftActionLabel;
  final VoidCallback? onLeftAction;
  final VoidCallback? onViewReceipt;

  const CustomBookingcard({
    required this.bookingId,
    required this.otp,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.time,
    this.status,
    this.statusColor,
    this.showReschedule = true,
    this.showActionButtons = true,
    this.topActionLabel,
    this.onTopAction,
    required this.leftActionLabel,
    this.onLeftAction,
    this.onViewReceipt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(
              bookingId: bookingId,
              theme: theme,
              showReschedule: showReschedule,
              topActionLabel: topActionLabel,
              onTopAction: onTopAction,
            ),
            const SizedBox(height: 8),
            OtpSection(otp: otp, theme: theme),
            const SizedBox(height: 10),
            TitleSection(title: title, type: type, theme: theme),
            const SizedBox(height: 10),
            _LocationSection(location: location, theme: theme),
            const SizedBox(height: 25),
            _DateTimeSection(date: date, time: time, theme: theme),
            if (status != null) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  status!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusColor ?? Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (showActionButtons) ...[
              const SizedBox(height: 30),
              _ActionButtons(
                theme: theme,
                leftActionLabel: leftActionLabel,
                onLeftAction: onLeftAction,
                onViewReceipt: onViewReceipt,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String bookingId;
  final ThemeData theme;
  final bool showReschedule;
  final String? topActionLabel;
  final VoidCallback? onTopAction;
  const _HeaderSection({
    required this.bookingId,
    required this.theme,
    this.showReschedule = true,
    this.topActionLabel,
    this.onTopAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0, top: 25),
            child: Row(
              children: [
                Text(
                  'Booking Id: ',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  child: Text(
                    bookingId,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (topActionLabel != null)
          SizedBox(
            width: 80,
            height: 20,
            child: TextButton(
              onPressed: onTopAction,
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                topActionLabel!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class OtpSection extends StatelessWidget {
  final String otp;
  final ThemeData theme;
  const OtpSection({super.key, required this.otp, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            'OTP : ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: backgroundDark,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Flexible(
            child: Text(
              otp,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String title;
  final String type;
  final ThemeData theme;
  const TitleSection({
    required this.title,
    required this.type,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  final String location;
  final ThemeData theme;
  const _LocationSection({required this.location, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shoot Location',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          location,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DateTimeSection extends StatelessWidget {
  final String date;
  final String time;
  final ThemeData theme;
  const _DateTimeSection({
    required this.date,
    required this.time,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Date of Shoot',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          height: 28,
          width: 1,
          color: const Color(0xFFE9E9E9),
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Timing',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ThemeData theme;
  final String leftActionLabel;
  final VoidCallback? onLeftAction;
  final VoidCallback? onViewReceipt;

  const _ActionButtons({
    required this.theme,
    required this.leftActionLabel,
    this.onLeftAction,
    this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 39,
            child: OutlinedButton(
              onPressed: onLeftAction,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                leftActionLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 39,
            child: ElevatedButton(
              onPressed: onViewReceipt,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View Receipt',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
