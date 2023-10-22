import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/widgets/constants.dart';

class Profile extends StatelessWidget {
  @override
  String F="hi";
  Widget build(BuildContext context) {
    return MaterialApp(
      
       debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
          
            child: Column(
              children: [
           
                const SizedBox(
                  height: 100,
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
                  children:  [
                   Text(
                    GlobalValues.name+" "+GlobalValues.Lname,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 26,),
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
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.privacy_tip_sharp,
                            color:  kPrimaryColor,
                          ),
                          title: Text(
                            'Privacy',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color:  kPrimaryColor),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color:  kPrimaryColor,
                          ),
                        ),
                      ),
                     
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading:
                              Icon(Icons.help_outline, color:  kPrimaryColor),
                          title: Text(
                            'Help & Support',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color:  kPrimaryColor),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color:  kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.privacy_tip_sharp,
                            color:  kPrimaryColor,
                          ),
                          title: Text(
                            'Settings',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color:  kPrimaryColor),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: kPrimaryColor
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.language,
                            color:  kPrimaryColor,
                          ),
                          title: Text(
                            'Change Language',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color:  kPrimaryColor),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color:  kPrimaryColor,
                          ),
                        ),
                      ),
                         const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.logout,
                            color:  kPrimaryColor,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                          color:  kPrimaryColor,),
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