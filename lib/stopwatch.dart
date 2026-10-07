// Meet Kathiriya's Code

// import 'package:flutter/material.dart';
// import 'dart:async';
//
// class StopwatchExample extends StatefulWidget {
//   const StopwatchExample({super.key});
//
//   @override
//   State<StopwatchExample> createState() => StopwatchExampleState();
// }
//
// class StopwatchExampleState extends State<StopwatchExample> {
//   int milliseconds = 0;
//   late Timer timer;
//   bool isRunning = false;
//   final laps = <int>[];
//
//   void _lap(){
//     setState(() {
//       laps.add(milliseconds);
//       milliseconds = 0;
//     });
//     print(laps);
//   }
//   void _clear(){
//     setState(() {
//       laps.clear();
//       milliseconds = 0;
//     });
//   }
//
//   Widget _buildCounter(BuildContext context){
//     return Container(
//       color: Theme.of(context).primaryColor,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           Text('Lap ${laps.length + 1}',style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
//           Text(_millisToSecond(milliseconds),
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(color: Colors.white)),
//         ],
//       ),
//
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void _onTick(Timer timer) {
//     setState(() {
//       if(isRunning){
//         //seconds++;
//         milliseconds += 100;
//       }
//     });
//   }
//
//   void _startTimer() {
//     timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
//     setState(() {
//       //seconds = 0;
//       milliseconds = 0;
//       isRunning = true;
//     });
//   }
//
//   void _stopTimer() {
//     timer.cancel();
//     setState(() {
//       isRunning = false;
//     });
//   }
//
//
//   String _millisToSecond(millis) {
//     final seconds = (millis / 1000);
//     return '$seconds seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Stopwatch'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Text(
//                 _millisToSecond(milliseconds),
//                 style: const TextStyle(fontSize: 30),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: _startTimer,
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
//                     foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   ),
//                   child: const Text('Start'),
//                 ),
//                 const SizedBox(width: 20),
//
//                 ElevatedButton(
//                   onPressed:  _lap,
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 54, 98, 244)),
//                     foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   ),
//                   child: const Text('Lap'),
//                 ),
//                 const SizedBox(width: 20),
//
//                 ElevatedButton(
//                   onPressed: _clear,
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 244, 152, 54)),
//                     foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   ),
//                   child: const Text('Clear'),
//                 ),
//                 const SizedBox(width: 20),
//
//                 ElevatedButton(
//                   onPressed: _stopTimer,
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
//                     foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   ),
//                   child: const Text('Stop'),
//                 ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//           ],)
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchExample extends StatefulWidget {
  const StopWatchExample({super.key});

  @override
  State<StopWatchExample> createState() => _StopWatchExampleState();
}

class _StopWatchExampleState extends State<StopWatchExample> {
  int second = 0;
  int milliseconds = 0;
  late Timer time;
  bool isRunning = false;

  List<Map<String, dynamic>> laps = [];
  int lapStartSecond = 0;
  int lapStartMillisecond = 0;
  int lapCounter = 1;

  @override
  void initState() {
    super.initState();
    time = Timer.periodic(const Duration(milliseconds: 10), _onTick);
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }

  void _onTick(Timer time) {
    if (isRunning) {
      setState(() {
        milliseconds += 10;
        if (milliseconds >= 1000) {
          milliseconds = 0;
          second++;
        }
      });
    }
  }

  void _reset() {
    setState(() {
      second = 0;
      milliseconds = 0;
      isRunning = false;
      laps.clear();
      lapCounter = 1;
      lapStartSecond = 0;
      lapStartMillisecond = 0;
    });
  }

  void _startStop() {
    setState(() {
      isRunning = !isRunning;
      if (isRunning) {
        lapStartSecond = second;
        lapStartMillisecond = milliseconds;
      }
    });
  }

  void _addLap() {
    if (isRunning) {
      setState(() {
        int lapSeconds = second - lapStartSecond;
        int lapMillis = milliseconds - lapStartMillisecond;

        if (lapMillis < 0) {
          lapMillis += 1000;
          lapSeconds--;
        }

        int totalSeconds = second;
        int totalMillis = milliseconds;

        laps.add({
          'number': lapCounter,
          'lapSeconds': lapSeconds,
          'lapMillis': lapMillis,
          'totalSeconds': totalSeconds,
          'totalMillis': totalMillis,
        });

        lapCounter++;

        lapStartSecond = second;
        lapStartMillisecond = milliseconds;
      });
    }
  }

  String _formatTime(int seconds, int millis) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    int ms = millis ~/ 10;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
    }
  }

  String _secondToText() {
    return _formatTime(second, milliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Watch'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _secondToText(),
            style: Theme.of(context).textTheme.displayLarge,
          ),

          const SizedBox(height: 10),

          Text(
            'Lap ${lapCounter - 1}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 40),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start/Pause Button
              ElevatedButton(
                onPressed: _startStop,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: isRunning ? Colors.redAccent : Colors.lightGreenAccent,
                ),
                child: Text(
                  isRunning ? 'Pause' : 'Start',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 10),

              // Lap Button
              ElevatedButton(
                onPressed: isRunning ? _addLap : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  'Lap',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isRunning ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Reset Button
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.yellowAccent,
                ),
                child: Text(
                  'Reset',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Lap List
          Expanded(
            child: laps.isEmpty
                ? Center(
              child: Text(
                'No laps recorded',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            )
                : ListView.builder(
              itemCount: laps.length,
              reverse: true,
              itemBuilder: (context, index) {
                final lap = laps[laps.length - 1 - index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal:20,
                    vertical: 3,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        '${lap['number']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    title: Text(
                      'Lap ${lap['number']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Total: ${_formatTime(lap['totalSeconds'], lap['totalMillis'])}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      _formatTime(lap['lapSeconds'], lap['lapMillis']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    isThreeLine: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}