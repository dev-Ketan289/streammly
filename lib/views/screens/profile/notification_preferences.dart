import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/profile/components/custom_switch.dart';

class NotificationSection {
  final String title;
  final String description;
  bool pushEnabled;
  bool whatsappEnabled;

  NotificationSection({
    required this.title,
    required this.description,
    this.pushEnabled = false,
    this.whatsappEnabled = false,
  });
}

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends State<NotificationPreferencesPage> {
  bool enableAll = false;

  final List<NotificationSection> sections = [
    NotificationSection(
      title: 'Booking Updates',
      description: 'Get notified about booking confirmations, changes, or cancellations.',
    ),
    NotificationSection(
      title: 'Payments & Invoices',
      description: 'Receive payment confirmation, invoice generation, or refund updates.',
    ),
    NotificationSection(
      title: 'Important Announcements',
      description: 'App updates, new features, policy changes.',
    ),
  ];

  void setAll(bool value) {
    setState(() {
      enableAll = value;
      for (var section in sections) {
        section.pushEnabled = value;
        section.whatsappEnabled = value;
      }
    });
  }

  void updateEnableAll() {
    setState(() {
      enableAll = sections.every((s) => s.pushEnabled && s.whatsappEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notification Preferences',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EnableAllTile(
                enabled: enableAll,
                onChanged: setAll,
              ),
              const SizedBox(height: 16),
              ...sections.map((section) => _SectionTile(
                    section: section,
                    onChanged: updateEnableAll,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnableAllTile extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _EnableAllTile({required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
       
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enable all', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: backgroundDark)),
              SizedBox(height: 2),
              Text('Activate all notifications', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          CustomSwitch(
            value: enabled,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

class _SectionTile extends StatefulWidget {
  final NotificationSection section;
  final VoidCallback onChanged;

  const _SectionTile({required this.section, required this.onChanged});

  @override
  State<_SectionTile> createState() => _SectionTileState();
}

class _SectionTileState extends State<_SectionTile> {
  void _onPushChanged(bool? value) {
    setState(() {
      widget.section.pushEnabled = value ?? false;
    });
    widget.onChanged();
  }

  void _onWhatsAppChanged(bool? value) {
    setState(() {
      widget.section.whatsappEnabled = value ?? false;
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
       
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.section.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: backgroundDark)),
          const SizedBox(height: 2),
          Text(widget.section.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),
          _OptionRow(
            label: 'Push',
            value: widget.section.pushEnabled,
            onChanged: _onPushChanged,
          ),
          const SizedBox(height: 20),
          _OptionRow(
            label: 'WhatsApp',
            value: widget.section.whatsappEnabled,
            onChanged: _onWhatsAppChanged,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _OptionRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.svgNotiCal,
          height: 24, 
          width: 24,
        ),
        const SizedBox(width: 20),
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        CustomSwitch(
          value: value,
          onChanged: (val) => onChanged(val),
        )
      ],
    );
  }
}
