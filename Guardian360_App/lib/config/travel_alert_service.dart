import 'base_config.dart';

class TravelAlertService {

  static String get availableFriend => "${config.travelAlertServiceBaseUrl}friends/available";
  static String get requestFriend => "${config.travelAlertServiceBaseUrl}friends/request";
  static String get acceptFriendRequest => "${config.travelAlertServiceBaseUrl}friends/accept-request";
  static String get pendingRequests => "${config.travelAlertServiceBaseUrl}friends/pending-requests";
  static String get createKnownPlace => "${config.travelAlertServiceBaseUrl}safe-places/create";
}
