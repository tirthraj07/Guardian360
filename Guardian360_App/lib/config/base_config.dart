abstract class BaseConfig {
  String get authServiceHost;
  int get authServicePort;
  String get travelAlertServiceHost;
  String get incidentReportingServiceHost;
  int get travelAlertServicePort;
  int get incidentReportingServicePort;
  String get authServiceBaseUrl;
  String get travelAlertServiceBaseUrl;
  String get incidentReportingServiceBaseUrl;
  String get sosReportingServiceBaseUrl;
  int get sosReportingServicePort;
  String get sosReportingServiceHost;
}

class DevConfig implements BaseConfig {
  @override
  String get authServiceHost => "143.110.183.53";
  @override
  int get authServicePort => 5001;

  @override
  String get travelAlertServiceHost => "192.168.28.182";
  @override
  int get travelAlertServicePort => 8000;

  @override
  String get authServiceBaseUrl => "http://$authServiceHost/auth-service/auth/";

  // @override
  // String get travelAlertServiceBaseUrl => "http://$travelAlertServiceHost:$travelAlertServicePort/";

  @override
  String get travelAlertServiceBaseUrl => "http://143.110.177.251/travel-service/";
  // @override
  // String get travelAlertServiceBaseUrl => "https://travel-alert-service.onrender.com/";

  @override
  int get incidentReportingServicePort => 8001;

  @override
  String get incidentReportingServiceBaseUrl => "http://$incidentReportingServiceHost:$incidentReportingServicePort/";

  @override
  String get incidentReportingServiceHost => "192.168.28.182";

  @override
  String get sosReportingServiceHost => "192.168.28.182";

  @override
  int get sosReportingServicePort => 8005;

  @override
  String get sosReportingServiceBaseUrl => "http://$sosReportingServiceHost:$sosReportingServicePort";

  @override
  String get chatbotServiceHost => "192.168.28.182";

  @override
  int get chatbotgServicePort => 8003;

  @override
  String get chatbotServiceBaseUrl => "http://$chatbotServiceHost:$chatbotgServicePort";

  @override
  String get notificationServiceHost => "143.110.183.53";
  @override
  int get notificationServicePort => 9000;

  @override
  String get notificationServiceBaseUrl => "http://$notificationServiceHost/notification-service/";


}

// Set environment here
BaseConfig config = DevConfig(); // Change to ProdConfig() for production
