import 'package:flutter/material.dart';
import 'package:guardians_app/auth_wrapper.dart';
import 'package:guardians_app/screens/sos_preference_page.dart';
import 'package:guardians_app/utils/asset_suppliers/contacts_page_assets.dart';

import '../../services/cache_service.dart';
import '../colors.dart';

class HomePageDrawer extends StatelessWidget {
  final int userID;
  const HomePageDrawer({
    super.key, required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.deepBlue,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(),
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(ContactsPageAssets.userProfilePic))

                ),


              ),

              Divider(),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(

                  onPressed:() async {

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SosPreferencesPage(userID: userID)));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12), // Padding inside button
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 25, color: Colors.black87,),
                          SizedBox(width: 10,),
                          Text(
                            "SOS Settings",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Spacer(),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(

                  onPressed:() async {

                    CacheService cacheService = CacheService();

                    await cacheService.removeCacheData('access_token');
                    await cacheService.removeCacheData('user_data');

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AuthWrapper()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12), // Padding inside button
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
