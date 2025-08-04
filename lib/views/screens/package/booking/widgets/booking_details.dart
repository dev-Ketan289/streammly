import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/my_bookings.dart';
import 'package:streammly/views/screens/package/booking/widgets/custom_bookingcard.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

// --- Addons Model ---
class BookingAddOn {
  final String name;
  final String desc;
  final String price;
  BookingAddOn(this.name, this.desc, this.price);
}

// --- Main Booking Details Page ---
class BookingDetailsPage extends StatelessWidget {
  final BookingInfo booking;
  final String? status;
  final Color? statusColor;

  // Expect a list of add-ons (for example sake, you could pass them into your BookingInfo, too)
  final List<BookingAddOn>? addons;
  const BookingDetailsPage({
    required this.booking,
    this.status,
    this.statusColor,
    this.addons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'Booking Details',
            style: theme.textTheme.titleLarge?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status != null)
                    Container(
                      width: 84,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: Text(
                          status!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 15),
                  CustomDetailContainer(booking: booking),
                  SizedBox(height: 20),

                  PackageDetails(title: "Package Details", booking: booking),
                  SizedBox(height: 20),

                  PricingDetails(title: "Pricing Details", booking: booking),
                  SizedBox(height: 20),

                  ContactInformation(title: 'Contact Information'),
                  SizedBox(height: 20),

                  Text(
                    "Special Instructions",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(22.0),
                      child: Text(
                        'Please ensure the shooting area is well-lit and clean. The photographer will arrive 15 minutes early for setup. Kindly have all props & outfits ready before the session begins',
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // --- Add-ons section ---
                  if (addons != null && addons!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Add-ons",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "+ Add",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ...addons!.map(
                          (addon) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                addon.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                addon.desc,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Text(
                                addon.price,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  // END Add-ons section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A6CF7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Let's Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Contact Info, Pricing and PackageDetails updated for dynamic booking data ---
class ContactInformation extends StatelessWidget {
  final String title;
  const ContactInformation({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 377,
          height: 145,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Support",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "+91 9854758568",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 46,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          "Call",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email Support",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "support@focuspointstudio.com",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 46,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          "Email",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PricingDetails extends StatelessWidget {
  final String title;
  final BookingInfo booking;
  const PricingDetails({super.key, required this.title, required this.booking});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Example: replace with real data from booking, hardcoded values here
    final basePrice = "₹2,500"; // booking.basePrice
    final travel = "₹200"; // booking.travelCharges
    final gst = "₹486"; // booking.gst
    final total = "₹3,186"; // booking.totalPayment

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 377,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            child: Column(
              children: [
                _row("Base Price", basePrice, theme),
                SizedBox(height: 5),
                _row("Travel Charges", travel, theme),
                SizedBox(height: 5),
                _row("GST (18%)", gst, theme),
                SizedBox(height: 8),
                Divider(color: Colors.grey.shade400),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Payment",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      total,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PackageDetails extends StatelessWidget {
  final String title;
  final BookingInfo booking;
  const PackageDetails({super.key, required this.title, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Replace these with actual values from booking.package as needed
    final duration = '1 Hour'; // booking.duration
    final photos = '25-30 Photos'; // booking.photosIncluded
    final delivery = '3-5 Working Days'; // booking.deliveryTime
    final team = 'Professional Team'; // booking.photographer

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 377,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            child: Column(
              children: [
                CommonBookingDetailRow(
                  title: "Duration",
                  description: duration,
                ),
                SizedBox(height: 8),
                CommonBookingDetailRow(
                  title: "Photos Included",
                  description: photos,
                ),
                SizedBox(height: 8),
                CommonBookingDetailRow(
                  title: "Delivery Time",
                  description: delivery,
                ),
                SizedBox(height: 8),
                CommonBookingDetailRow(
                  title: "Photographer",
                  description: team,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommonBookingDetailRow extends StatelessWidget {
  final String title;
  final String description;
  const CommonBookingDetailRow({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CustomDetailContainer extends StatelessWidget {
  final BookingInfo booking;
  final String? status;
  final Color? statusColor;
  const CustomDetailContainer({
    super.key,
    required this.booking,
    this.status,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 377,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleSection(
                  title: booking.title,
                  type: booking.type,
                  theme: theme,
                ),
                OtpSection(otp: booking.otp, theme: theme),
              ],
            ),
            SizedBox(height: 15),
            Text("Booking Id"),
            Text(
              booking.bookingId,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.grey.shade400),
            SizedBox(height: 5),
            Text("Date of Shoot"),
            Text(
              booking.date,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text("Timing"),
            Text(
              booking.time,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text("Shoot Location"),
            Text(
              booking.location,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
