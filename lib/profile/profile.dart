import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/widgets/constants.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(color: Colors.white54,
            child: Column(
              children: [
                 const ListTile(
                  leading: Icon(Icons.arrow_back),
              
                ),
                const SizedBox(
                  height: 90,
                ),
            
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                   
                      CircleAvatar(
  backgroundColor: kPrimaryColor,
  radius: 77,
  child: CircleAvatar(
    radius: 75,
                      
                      backgroundImage: AssetImage("assets/images/anon.png"),
  ),
                      ),
                  
                    
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
            
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                   const Text(
                    "",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                    )
                  ],
                ),
             
              
                Container(
                  child: Expanded(
                      child: ListView(
                    children: [
                      Card(
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.privacy_tip_sharp,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Privacy',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                     
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: kPrimaryColor,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading:
                              Icon(Icons.help_outline, color: Colors.white),
                          title: Text(
                            'Help & Support',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: kPrimaryColor,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.privacy_tip_sharp,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Settings',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    
                      Card(
                        color: kPrimaryColor,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                          color: Colors.white,),
                        ),
                      )
                    ],
                    
                  )),
                )
              ],
            
            ),
            
          ),
        ));
  }
}