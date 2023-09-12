class BasicResponse {
  final String? status; //	string
  final String? message; //	string
  final dynamic data; //	{...}
  final dynamic summary; //	{...}
  final int? total;

  BasicResponse({
    this.status,
    this.message,
    this.data,
    this.summary,
    this.total,
  }); //

  static BasicResponse fromJson(Map<String, dynamic> json) {
    return BasicResponse(
      status: (json["status"] as String?),
      message: (json["message"] as dynamic),
      data: (json["data"] as dynamic),
      summary: (json["summary"] as dynamic),
      total: (json["total"] as num?)?.toInt(),
    );
  }
}

class BasicResponseStatus {
  static const String success = "100";
  static const String successWithData = "200";
  static const String otpRequired = "101";
  static const String unAuthorized1 = "ERR-003";
  static const String unAuthorized2 = "ERR-400";
  static const String invalidOtp = "ERR-019";

  static List<String> get successCodes {
    return [
      success,
      successWithData,
    ];
  }

  static List<String> get unAuthorized {
    return [
      unAuthorized1,
      unAuthorized2,
    ];
  }
}
