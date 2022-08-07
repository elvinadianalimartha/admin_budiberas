class ReportAnnualModel {
  late String month;
  late double omzet;
  late double tax;

  ReportAnnualModel({
    required this.month,
    required this.omzet,
    required this.tax
  });
  
  ReportAnnualModel.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    omzet = double.parse(json['omzet'].toString());
    tax = double.parse(json['tax'].toString());
  }
}