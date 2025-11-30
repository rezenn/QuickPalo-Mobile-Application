import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/widgets/custom_big_card.dart';
import 'package:quickpalo/widgets/custom_search_bar.dart';
import 'package:quickpalo/widgets/custom_small_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              color: LightPurpleColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Hem Raj Shrestha",
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_rounded,
                            color: textColorGrey,
                            size: 30,
                          ),
                          SizedBox(width: 5),
                          CircleAvatar(
                            radius: 26, // Image radius
                            backgroundImage: AssetImage(
                              "assets/images/profile.png",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  CustomSearchBar(),
                  SizedBox(height: 2),
                  Divider(),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      "Recently Viewed",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      children: [
                        CustomSmallCard(
                          title: "Hospital 1",
                          imagePath:
                              "https://www.shutterstock.com/shutterstock/photos/212251981/display_1500/stock-photo-modern-hospital-style-building-212251981.jpg",
                        ),
                        CustomSmallCard(
                          title: "Hospital 2",
                          imagePath:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaKkwpCkwk9DcZ4gzuHnX_9-ET8I7aGKs2Dg&s",
                        ),
                        CustomSmallCard(
                          title: "Hospital 3",
                          imagePath:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      children: [
                        Chip(label: Text("All")),
                        Chip(label: Text("Hospital")),
                        Chip(label: Text("University")),
                        Chip(label: Text("College")),
                        Chip(label: Text("Government Office")),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 175 / 250,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CustomBigCard(
                        imagePath:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        title: "title",
                        location: "location",
                        time: "time",
                        description:
                            "A non-profit institution prioritizing community health, maternal care and chronic illness prevention. It operates with a patient-first philosophy, ensuring that even low-income families have access to essential medical services without financial barriers. The institution also invests in research related to maternal mortality, child malnutrition, and chronic conditions such as diabetes and hypertension within low-resource areas.",
                      ),
                      CustomBigCard(
                        imagePath:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        title: "title",
                        location: "location",
                        time: "time",
                        description: "description",
                      ),
                      CustomBigCard(
                        imagePath:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        title: "title",
                        location: "location",
                        time: "time",
                        description: "description",
                      ),
                      CustomBigCard(
                        imagePath:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        title: "title",
                        location: "location",
                        time: "time",
                        description: "description",
                      ),
                      CustomBigCard(
                        imagePath:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpiIGm_Z3u8IHIIqMsPBpwU8qwiYyelbFvHw&s",
                        title: "title",
                        location: "location",
                        time: "time",
                        description: "description",
                      ),
                    ],
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
