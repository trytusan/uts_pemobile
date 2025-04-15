class Report {
  String idCustomerService;
  String nim;
  String titleIssues;
  String descriptionIssues;
  String rating;
  String imageUrl;
  String idDivisionTarget;
  String idPriority;
  String divisionDepartmentName;
  String priorityName;

  Report({
    required this.idCustomerService,
    required this.nim,
    required this.titleIssues,
    required this.descriptionIssues,
    required this.rating,
    required this.imageUrl,
    required this.idDivisionTarget,
    required this.idPriority,
    required this.divisionDepartmentName,
    required this.priorityName,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    idCustomerService: json["id_customer_service"].toString(),
    nim: json["nim"].toString(),
    titleIssues: json["title_issues"].toString(),
    descriptionIssues: json["description_issues"].toString(),
    rating: json["rating"].toString(),
    imageUrl: json["image_url"].toString(),
    idDivisionTarget: json["id_division_target"].toString(),
    idPriority: json["id_priority"].toString(),
    divisionDepartmentName: json["division_department_name"].toString(),
    priorityName: json["priority_name"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id_customer_service": idCustomerService,
    "nim": nim,
    "title_issues": titleIssues,
    "description_issues": descriptionIssues,
    "rating": rating,
    "image_url": imageUrl,
    "id_division_target": idDivisionTarget,
    "id_priority": idPriority,
    "division_department_name": divisionDepartmentName,
    "priority_name": priorityName,
  };
}
