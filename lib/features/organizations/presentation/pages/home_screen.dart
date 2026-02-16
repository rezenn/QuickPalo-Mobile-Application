import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/widgets/organization_filter.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/features/organizations/presentation/view_model/organization_viewmodel.dart';
import 'package:quickpalo/features/profile/presentation/pages/profile_screen.dart';
import 'package:quickpalo/features/notification/presentation/pages/notification_screen.dart';
import 'package:quickpalo/features/organizations/presentation/pages/organization_detail_screen.dart';
import 'package:quickpalo/core/widgets/custom_big_card.dart';
import 'package:quickpalo/core/widgets/custom_search_bar.dart';
import 'package:quickpalo/core/widgets/custom_small_card.dart';
import 'package:quickpalo/features/organizations/presentation/state/organization_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(organizationViewModelProvider.notifier).getAllOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.read(userSessionServiceProvider);
    final organizationState = ref.watch(organizationViewModelProvider);

    final fullName = session.getuserFullName() ?? "User";
    final profileImageUrl = session.getuserProfileImage();

    // Show loading state
    if (organizationState.status == OrganizationStatus.loading) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show error state
    if (organizationState.status == OrganizationStatus.error) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${organizationState.errorMessage}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(organizationViewModelProvider.notifier)
                        .getAllOrganizations();
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final organizations = organizationState.organizations;
    final recentlyViewed =
        organizations.length > 5 ? organizations.sublist(0, 5) : organizations;

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
                            color: lightPurpleColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          fullName,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.notifications_rounded,
                            color: textColorGrey,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: lightPurpleColor.withAlpha(150),
                                  width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: profileImageUrl != null
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: profileImageUrl == null
                                  ? Text(
                                      fullName[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: lightPurpleColor3,
                                      ),
                                    )
                                  : null,
                            ),
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
                if (recentlyViewed.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recently Viewed",
                      style:
                          TextStyle(fontSize: 24, fontFamily: "Inter Bold 18"),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentlyViewed.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final org = recentlyViewed[index];

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
                          child: CustomSmallCard(
                            title: org.organizationName,
                            imagePath: org.user?.profilePicture != null
                                ? ApiEndpoints.imageUrl(
                                    org.user!.profilePicture!)
                                : "assets/images/placeholder.png",
                          ),
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 5),
                Divider(),
                OrganizationFilter(),
                SizedBox(height: 10),
                if (organizations.isNotEmpty)
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.7,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: organizations.length,
                    itemBuilder: (context, index) {
                      final org = organizations[index];
                      final address = [org.street, org.city, org.state]
                          .where((part) => part != null && part.isNotEmpty)
                          .join(', ');

                      final workingHours = org.workingHours.isNotEmpty
                          ? '${org.workingHours.first.openingTime} - ${org.workingHours.first.closingTime}'
                          : 'Hours not available';

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
                          imagePath: org.user?.profilePicture != null
                              ? ApiEndpoints.imageUrl(org.user!.profilePicture!)
                              : "assets/images/placeholder.png",
                          title: org.organizationName,
                          location: address,
                          time: workingHours,
                          description:
                              org.description ?? 'No description available',
                        ),
                      );
                    },
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('No organizations found'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
