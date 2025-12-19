import 'package:flutter/material.dart';
import 'package:quickpalo/models/organization_model.dart';
import 'package:quickpalo/widgets/custom_button.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Appointment Details",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(height: 10),
                Text(
                  "Organization Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Note: ", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Text(
                  "Appointment Fee: Rs --",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),

                // Payment Method Section
                Text(
                  "Payment method:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: [
                    ChoiceChip(
                      label: Text("Online", style: TextStyle(fontSize: 16)),
                      selected: true, // update dynamically if needed
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: Text("Physical", style: TextStyle(fontSize: 16)),
                      selected: false, // update dynamically if needed
                      onSelected: (_) {},
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: CustomButton(
                    onPressed: () {},
                    text: "Confirm Appointment",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
