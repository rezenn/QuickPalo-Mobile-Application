import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/data/organization_data.dart';
import 'package:quickpalo/screens/organization_detail_screen.dart';
import 'package:quickpalo/widgets/custom_big_card.dart';
import 'package:quickpalo/widgets/custom_search_bar.dart';
import 'package:quickpalo/widgets/custom_small_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
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
                            fontFamily: "Inter Bold 18",
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
                          radius: 26,
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recently Viewed",
                    style: TextStyle(fontSize: 24, fontFamily: "Inter Bold 18"),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: organizations.length > 10
                        ? 10
                        : organizations.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final org = organizations[index];

                      return CustomSmallCard(
                        title: org.title,
                        imagePath: org.image,
                      );
                    },
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
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 4
                      : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.7,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: organizations.map((org) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OrganizationDetailScreen(organization: org),
                          ),
                        );
                      },
                      child: CustomBigCard(
                        imagePath: org.image,
                        title: org.title,
                        location: org.location,
                        time: org.time,
                        description: org.description,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
