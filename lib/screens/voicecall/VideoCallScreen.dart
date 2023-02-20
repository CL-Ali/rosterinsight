// import 'package:flutter/material.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';

// class VoiceCallScreen extends StatefulWidget {
//   const VoiceCallScreen({super.key});

//   @override
//   State<VoiceCallScreen> createState() => _VoiceCallScreenState();
// }

// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   final serverUrl = 'https://meet.jit.si';

//   void _joinMeeting() async {
//     try {
//       // Configure the meeting options
//       var options = JitsiMeetingOptions(room: 'eXappVoiceCallRoom')
//         ..serverURL = serverUrl
//         // ..room = 'my-room-id'
//         ..audioOnly = true
//         ..audioMuted = true;

//       // Join the meeting
//       await JitsiMeet.joinMeeting(options);
//     } catch (error) {
//       debugPrint("Error joining Jitsi meeting: $error");
//     }
//   }

//   void _leaveMeeting() async {
//     try {
//       // Leave the meeting
//       await JitsiMeet.closeMeeting();
//     } catch (error) {
//       debugPrint("Error leaving Jitsi meeting: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Jitsi Meet Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text('Join Meeting'),
//               onPressed: _joinMeeting,
//             ),
//             ElevatedButton(
//               child: Text('Leave Meeting'),
//               onPressed: _leaveMeeting,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
