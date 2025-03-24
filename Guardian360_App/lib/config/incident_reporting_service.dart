import 'base_config.dart';

class IncidentReportingService {
  static String get_types = "${config.incidentReportingServiceBaseUrl}incident/types";
  static String get_subtypes = "${config.incidentReportingServiceBaseUrl}{typeID}/subtypes";
  static String createReport = "${config.incidentReportingServiceBaseUrl}incident/report";
}
