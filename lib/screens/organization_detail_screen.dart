import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_detail_action.dart';

class OrganizationDetailScreen extends StatelessWidget {
  const OrganizationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Book Appointment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- IMAGE BANNER ----------
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: isTablet ? 450 : 250,
                    child: Image.network(
                      "https://www.shutterstock.com/shutterstock/photos/212251981/display_1500/stock-photo-modern-hospital-style-building-212251981.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ---------- HEADER + ACTION BUTTONS ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// LEFT: Name + Address
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RKM Hospital",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 34 : 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Naya Sadak, Kathmandu",
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "8:00 - 17:00",
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// RIGHT: Action Icons
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: buttonColor2),
                        ),
                        child: Row(
                          children: [
                            CustomDetailAction(
                              icon: Icons.call,
                              label: "Call",
                              isTablet: isTablet,
                              onTap: () {},
                            ),
                            CustomDetailAction(
                              icon: Icons.message,
                              label: "Message",
                              isTablet: isTablet,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 10),
                  child: Text(
                    "About",
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "RKM Hospital is a modern healthcare center offering emergency "
                    "services, OPD, diagnostics, and specialized medical care. "
                    "We provide affordable and reliable treatment with a commitment "
                    "to patient care.",
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// ---------- APPOINTMENT BUTTON ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(
                    text: "Book Appointment",
                    onPressed: () {},
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
