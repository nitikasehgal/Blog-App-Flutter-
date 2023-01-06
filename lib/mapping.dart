// import 'package:blog_app/firebasefunction.dart';
// import 'package:blog_app/loginRegisterPage.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// enum Authstatus { notsignin, signin }

// class MappingPage extends StatefulWidget {
//   @override
//   State<MappingPage> createState() => _MappingPageState();
// }

// class _MappingPageState extends State<MappingPage> {
//   Authstatus authstatus = Authstatus.notsignin;
//   @override
//   void initState() {
//     // TODO: implement initState
//     getcurrentuser().then((firebaseUserid) {
//       setState(() {
//         authstatus =
//             firebaseUserid == null ? Authstatus.notsignin : Authstatus.signin;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (authstatus) {
//       case Authstatus.notsignin:
//         return LoginRegister();
//     }
//     return null;
//   }
// }
