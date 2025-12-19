import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: LightPurpleColor),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "Organization Name",
                style: TextStyle(fontFamily: "Inter Bold 24", fontSize: 35),
              ),
              SizedBox(height: 40),
              SizedBox(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    "https://www.brockport.edu/live/image/gid/154/width/990/height/552/crop/1/src_region/0,147,3200,1931/11625_health_center_exterior19-2.jpg",
                  ),
                ),
              ),
              SizedBox(height: 80),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 6,
                            shadowColor: Colors.grey.shade200,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 194, 193, 193),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.headphones,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 40),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 6,
                            shadowColor: Colors.grey.shade200,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 194, 193, 193),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.volume_off,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 6,
                            shadowColor: Colors.redAccent.shade200,
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.redAccent, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 40),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 6,
                            shadowColor: Colors.grey.shade200,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 194, 193, 193),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
