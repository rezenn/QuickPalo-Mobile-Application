import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/widgets/custom_button.dart';

class AppointmentConfirmScreen extends StatelessWidget {
  const AppointmentConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(title: Text("Book Appointment"), elevation: 2),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green),
                      Text(
                        "Confirmation",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter Bold 24",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "Organization Name",
                        style: TextStyle(
                          fontFamily: "Inter Bold 24",
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: isTablet ? 20 : 16,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Organization Location",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Text("Client Name: ", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Date:", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Time: ", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Department: ", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Note: ", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text(
                        "Token Number: YE785 ",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text("Payment: Online ", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Divider(),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Appointment QR",
                              style: TextStyle(
                                fontFamily: "Inter Bold 24",
                                fontSize: 20,
                                color: const Color.fromARGB(255, 34, 34, 34),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: Image.network(
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: CustomButton(onPressed: () {}, text: "Download QR"),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: CustomButton(
                      onPressed: () {},
                      color: buttonColor3,
                      text: "Add to Calendar",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
