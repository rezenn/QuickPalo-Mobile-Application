import 'package:flutter/material.dart';
import 'package:quickpalo/common/date_selector.dart';
import 'package:quickpalo/common/department_selector.dart';
import 'package:quickpalo/common/time_selector.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/appointment_detail_screen.dart';
import 'package:quickpalo/screens/call_screen.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_detail_action.dart';
import 'package:quickpalo/models/organization_model.dart';

class OrganizationDetailScreen extends StatefulWidget {
  final OrganizationModel organization;

  const OrganizationDetailScreen({super.key, required this.organization});

  @override
  State<OrganizationDetailScreen> createState() =>
      _OrganizationDetailScreenState();
}

class _OrganizationDetailScreenState extends State<OrganizationDetailScreen> {
  // int _navIndex = 0;
  // void _onNavTap(int index) {
  //   setState(() => _navIndex = index);

  //   switch (index) {
  //     case 0:
  //       Navigator.pop(context);
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const CalendarScreen()),
  //       );
  //       break;
  //     case 2:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HistoryScreen()),
  //       );
  //       break;
  //     case 3:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const ProfileScreen()),
  //       );
  //       break;
  //   }
  // }

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
              style: TextStyle(fontFamily: "Inter Bold 24"),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.black54, height: 1),
            ),
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: isTablet
                  ? EdgeInsets.symmetric(horizontal: 25)
                  : EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: isTablet ? 500 : 250,
                      child: Image.network(
                        widget.organization.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                widget.organization.title,
                                style: TextStyle(
                                  fontFamily: "Inter Bold 18",
                                  fontSize: isTablet ? 34 : 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: isTablet ? 20 : 13,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.organization.location,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: isTablet ? 20 : 13,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.organization.time,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 246, 244, 244),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            CustomDetailAction(
                              icon: Icons.call,
                              label: "Call",
                              isTablet: isTablet,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CallScreen(),
                                  ),
                                );
                              },
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

                  const SizedBox(height: 10),
                  Divider(),
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 20,
                      fontFamily: "Inter Bold 24",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      widget.organization.description,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      "Department",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Inter Bold 24",
                      ),
                    ),
                  ),
                  DepartmentSelector(
                    departments: widget.organization.departments,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                    child: Text(
                      "Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Inter Bold 24",
                      ),
                    ),
                  ),
                  DateSelector(),

                  TimeSelector(timeSlots: widget.organization.timeSlots),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      text: "Book Appointment",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AppointmentDetailScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: CustomNavBar(
          //   currentIndex: _navIndex,
          //   onTap: _onNavTap,
          // ),
        );
      },
    );
  }
}
