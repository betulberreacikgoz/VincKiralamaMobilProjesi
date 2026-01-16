class Offer {
  final int id;
  final String jobType;
  final String description;
  final String city;
  final String? district;
  final String? siteType;
  final String? accessType;
  final int? heightMeters;
  final double? loadWeightKg; // Backend double gönderiyor
  final String startDate;
  final String endDate;
  final String status;
  final String craneName;
  final int craneId;
  final String customerName;
  final String customerEmail;
  final String? customerPhone;

  Offer({
    required this.id,
    required this.jobType,
    required this.description,
    required this.city,
    this.district,
    this.siteType,
    this.accessType,
    this.heightMeters,
    this.loadWeightKg,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.craneName,
    required this.craneId,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? json['Id'] ?? 0,
      jobType: json['jobType'] ?? json['JobType'] ?? '',
      description: json['description'] ?? json['Description'] ?? '',
      city: json['city'] ?? json['City'] ?? '',
      district: json['district'] ?? json['District'],
      siteType: json['siteType'] ?? json['SiteType'],
      accessType: json['accessType'] ?? json['AccessType'],
      heightMeters: json['heightMeters'] ?? json['HeightMeters'],
      loadWeightKg: (json['loadWeightKg'] ?? json['LoadWeightKg'])?.toDouble(),
      startDate: json['startDate'] ?? json['StartDate'] ?? '',
      endDate: json['endDate'] ?? json['EndDate'] ?? '',
      status: json['status'] ?? json['Status'] ?? 'Beklemede',
      craneName: json['craneName'] ?? json['CraneName'] ?? '',
      craneId: json['craneId'] ?? json['CraneId'] ?? 0,
      customerName: json['customerName'] ?? json['CustomerName'] ?? '',
      customerEmail: json['customerEmail'] ?? json['CustomerEmail'] ?? '',
      customerPhone: json['customerPhone'] ?? json['CustomerPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobType': jobType,
      'description': description,
      'city': city,
      'district': district,
      'siteType': siteType,
      'accessType': accessType,
      'heightMeters': heightMeters,
      'loadWeightKg': loadWeightKg,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'craneName': craneName,
      'craneId': craneId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
    };
  }
}
