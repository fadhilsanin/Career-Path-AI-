// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const MyChatApp());
// }
//
// class MyChatApp extends StatelessWidget {
//   const MyChatApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//         scaffoldBackgroundColor: Color(0xFFF0F2F5),
//       ),
//       home: const MyChatPage(title: ''),
//     );
//   }
// }
//
// class MyChatPage extends StatefulWidget {
//   const MyChatPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyChatPage> createState() => _MyChatPageState();
// }
//
// class ChatMessage {
//   String messageContent;
//   String messageType;
//   String date;
//
//   ChatMessage({
//     required this.messageContent,
//     required this.messageType,
//     this.date = '',
//   });
// }
//
// class _MyChatPageState extends State<MyChatPage> {
//   String name = "";
//   Timer? _timer;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     name = widget.title;
//     _timer = Timer.periodic(Duration(seconds: 2), (_) {
//       view_message();
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _scrollController.dispose();
//     te_message.dispose();
//     super.dispose();
//   }
//
//   List<ChatMessage> messages = [];
//   TextEditingController te_message = TextEditingController();
//   bool isLoading = false;
//   bool isSending = false;
//
//   List<String> from_id_ = <String>[];
//   List<String> to_id_ = <String>[];
//   List<String> message_ = <String>[];
//   List<String> date_ = <String>[];
//
//   Future<void> view_message() async {
//     if (isLoading) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     List<String> from_id = <String>[];
//     List<String> to_id = <String>[];
//     List<String> message = <String>[];
//     List<String> date = <String>[];
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String urls = pref.getString('url').toString();
//       String url = urls + 'user_viewchat/';
//
//       var data = await http.post(Uri.parse(url), body: {
//         'from_id': pref.getString("lid").toString(),
//         'to_id': pref.getString("clid").toString()
//       });
//       var jsondata = json.decode(data.body);
//       String status = jsondata['status'];
//
//       var arr = jsondata["data"];
//       messages.clear();
//
//       for (int i = 0; i < arr.length; i++) {
//         from_id.add(arr[i]['from'].toString());
//         to_id.add(arr[i]['to'].toString());
//         message.add(arr[i]['msg']);
//         date.add(arr[i]['date'].toString());
//
//         if (pref.getString("lid").toString() == arr[i]['from'].toString()) {
//           messages.add(ChatMessage(
//             messageContent: arr[i]['msg'],
//             messageType: "sender",
//             date: arr[i]['date'].toString(),
//           ));
//         } else {
//           messages.add(ChatMessage(
//             messageContent: arr[i]['msg'],
//             messageType: "receiver",
//             date: arr[i]['date'].toString(),
//           ));
//         }
//       }
//
//       setState(() {
//         from_id_ = from_id;
//         to_id_ = to_id;
//         message_ = message;
//         date_ = date;
//         isLoading = false;
//       });
//
//       _scrollToBottom();
//     } catch (e) {
//       print("Error: " + e.toString());
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   Future<void> _sendMessage() async {
//     String message = te_message.text.trim();
//     if (message.isEmpty || isSending) {
//       return;
//     }
//
//     setState(() {
//       isSending = true;
//     });
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String ip = pref.getString("url").toString();
//       String url = ip + "flut_chat/";
//
//       var data = await http.post(Uri.parse(url), body: {
//         'message': message,
//         'from_id': pref.getString("lid").toString(),
//         'to_id': pref.getString("clid").toString()
//       });
//       var jsondata = json.decode(data.body);
//       String status = jsondata['status'];
//
//       te_message.clear();
//       await view_message();
//     } catch (e) {
//       print("Error: " + e.toString());
//     } finally {
//       setState(() {
//         isSending = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFECE5DD),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(65),
//         child: AppBar(
//           backgroundColor: Color(0xFF075E54),
//           elevation: 0,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//           titleSpacing: 0,
//           title: Row(
//             children: [
//               Hero(
//                 tag: 'avatar_$name',
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white24, width: 2),
//                   ),
//                   child: CircleAvatar(
//                     backgroundColor: Color(0xFF128C7E),
//                     radius: 20,
//                     child: Text(
//                       name.isNotEmpty ? name[0].toUpperCase() : 'U',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF25D366),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         SizedBox(width: 6),
//                         Text(
//                           'Online',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.white70,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.videocam, color: Colors.white),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.call, color: Colors.white),
//             ),
//             PopupMenuButton(
//               icon: Icon(Icons.more_vert, color: Colors.white),
//               itemBuilder: (context) => [
//                 PopupMenuItem(child: Text('View contact')),
//                 PopupMenuItem(child: Text('Media, links, and docs')),
//                 PopupMenuItem(child: Text('Search')),
//                 PopupMenuItem(child: Text('Mute notifications')),
//                 PopupMenuItem(child: Text('Wallpaper')),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(
//               'https://user-images.githubusercontent.com/15075759/28719144-86dc0f70-73b1-11e7-911d-60d70fcded21.png',
//             ),
//             fit: BoxFit.cover,
//             opacity: 0.05,
//           ),
//         ),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: messages.isEmpty
//                   ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.lock_outline,
//                       size: 80,
//                       color: Colors.teal.shade200,
//                     ),
//                     SizedBox(height: 24),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 40),
//                       child: Text(
//                         'Messages are end-to-end encrypted',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'No one outside of this chat can read them',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//                   : ListView.builder(
//                 controller: _scrollController,
//                 itemCount: messages.length,
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                 itemBuilder: (context, index) {
//                   bool isSender = messages[index].messageType == "sender";
//                   bool showAvatar = !isSender &&
//                       (index == messages.length - 1 ||
//                           messages[index + 1].messageType == "sender");
//
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 4),
//                     child: Row(
//                       mainAxisAlignment: isSender
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         if (!isSender) ...[
//                           SizedBox(
//                             width: 32,
//                             child: showAvatar
//                                 ? CircleAvatar(
//                               backgroundColor: Color(0xFF128C7E),
//                               radius: 16,
//                               child: Text(
//                                 name.isNotEmpty ? name[0].toUpperCase() : 'U',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             )
//                                 : SizedBox(),
//                           ),
//                           SizedBox(width: 4),
//                         ],
//                         Flexible(
//                           child: Container(
//                             constraints: BoxConstraints(
//                               maxWidth: MediaQuery.of(context).size.width * 0.75,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8),
//                                 topRight: Radius.circular(8),
//                                 bottomLeft: Radius.circular(isSender ? 8 : 0),
//                                 bottomRight: Radius.circular(isSender ? 0 : 8),
//                               ),
//                               color: isSender
//                                   ? Color(0xFFDCF8C6)
//                                   : Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.08),
//                                   blurRadius: 1,
//                                   offset: Offset(0, 1),
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   messages[index].messageContent,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black87,
//                                     height: 1.3,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       messages[index].date,
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                     if (isSender) ...[
//                                       SizedBox(width: 4),
//                                       Icon(
//                                         Icons.done_all,
//                                         size: 16,
//                                         color: Color(0xFF4FC3F7),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         if (isSender) SizedBox(width: 8),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFFF0F0F0),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: SafeArea(
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 2,
//                               offset: Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.emoji_emotions_outlined,
//                                 color: Colors.grey.shade600,
//                                 size: 26,
//                               ),
//                             ),
//                             Expanded(
//                               child: TextField(
//                                 controller: te_message,
//                                 maxLines: null,
//                                 textCapitalization: TextCapitalization.sentences,
//                                 decoration: InputDecoration(
//                                   hintText: "Message",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey.shade500,
//                                     fontSize: 16,
//                                   ),
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.symmetric(vertical: 10),
//                                 ),
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.attach_file,
//                                 color: Colors.grey.shade600,
//                                 size: 24,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.grey.shade600,
//                                 size: 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color(0xFF075E54),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(25),
//                           onTap: isSending ? null : _sendMessage,
//                           child: Center(
//                             child: isSending
//                                 ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.white,
//                                 ),
//                               ),
//                             )
//                                 : Icon(
//                               Icons.send,
//                               color: Colors.white,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }