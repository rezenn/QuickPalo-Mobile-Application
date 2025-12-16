class OrganizationModel {
  final String title;
  final String image;
  final String location;
  final String time;
  final String description;
  final List<String> departments;
  final List<String> timeSlots;

  OrganizationModel({
    required this.title,
    required this.image,
    required this.location,
    required this.time,
    required this.description,
    required this.departments,
    required this.timeSlots,
  });
}
