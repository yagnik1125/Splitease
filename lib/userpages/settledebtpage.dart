import 'package:auhackathon/models/group_model.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettleDebtPage extends StatefulWidget {
  final Map<String, double> netAmountMap;
  final GroupModel group;
  const SettleDebtPage(
      {super.key, required this.netAmountMap, required this.group});
  @override
  State<SettleDebtPage> createState() => _SettleDebtPageState();
}

class _SettleDebtPageState extends State<SettleDebtPage> {
  Map<String, double>? netAmountMap;
  final curuserid = FirebaseAuth.instance.currentUser!.uid;
  List<List<String>> trans = [];
  @override
  void initState() {
    netAmountMap = widget.netAmountMap;
    super.initState();
    calcSettleDebt();
  }

  String getUserNameById(String uid) {
    final user = widget.group.members.firstWhere((member) => member.uid == uid);
    return user.username;
  }

  void calcSettleDebt() {
    PriorityQueue<MapEntry<double, String>> minHeap =
        PriorityQueue<MapEntry<double, String>>(
      (a, b) => a.key.compareTo(b.key),
    );
    PriorityQueue<MapEntry<double, String>> maxHeap =
        PriorityQueue<MapEntry<double, String>>(
      (a, b) => b.key.compareTo(a.key),
    );

    netAmountMap!.forEach((key, value) {
      if (value < 0) {
        minHeap.add(MapEntry(value, key));
      } else if (value > 0) {
        maxHeap.add(MapEntry(value, key));
      }
    });

    while (minHeap.isNotEmpty) {
      var a = minHeap.removeFirst();
      var b = maxHeap.removeFirst();

      if (a.key + b.key < 0) {
        minHeap.add(MapEntry(a.key + b.key, a.value));
        if (a.value == curuserid || b.value == curuserid) {
          trans.add([a.value, b.value, b.key.toString()]);
        }
      } else {
        maxHeap.add(MapEntry(a.key + b.key, b.value));
        if (a.value == curuserid || b.value == curuserid) {
          trans.add([b.value, a.value, a.key.abs().toString()]);
        }
      }
    }
    // print(trans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        // backgroundColor: Colors.blue,
        gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        title: "Your debts",
        // // url: friend!.profileImageUrl,
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 236, 188, 249),
          radius: 24,
          child: Icon(Icons.groups),
        ),
        onReload: () {},
      ),
      body: trans.isEmpty
          ? const Center(child: Text('No debts to settle.'))
          : ListView.builder(
              itemCount: trans.length,
              itemBuilder: (context, index) {
                final transaction = trans[index];
                final payerId = transaction[0];
                final receiverId = transaction[1];
                final amount = transaction[2];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromARGB(255, 173, 235, 246),
                    child: ListTile(
                      title: payerId == curuserid
                          ? Text(
                              "You will pay $amount to ${getUserNameById(receiverId)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              "You will receive $amount from ${getUserNameById(payerId)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                      // subtitle: Text(
                      //   "From ${getUserNameById(payerId)}",
                      //   style: const TextStyle(fontWeight: FontWeight.bold),
                      // ),
                    ),
                  ),
                );
                // return Container(
                //   margin: const EdgeInsets.symmetric(
                //       vertical: 12.0, horizontal: 16.0),
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(
                //         255, 173, 235, 246), // Light blue background
                //     borderRadius: BorderRadius.circular(8.0), // Rounded corners
                //   ),
                //   child: ListTile(
                //     contentPadding: const EdgeInsets.all(
                //         16.0), // Padding inside the ListTile
                //     title:
                //         Text('Pay $amount to ${getUserNameById(receiverId)}'),
                //     subtitle: Text('From ${getUserNameById(payerId)}'),
                //   ),
                // );
              },
            ),
    );
  }
}

class PriorityQueue<E> {
  final List<E> _heap = [];
  final int Function(E, E) _compare;

  PriorityQueue(this._compare);

  bool get isNotEmpty => _heap.isNotEmpty;
  bool get isEmpty => _heap.isEmpty;

  void add(E value) {
    _heap.add(value);
    _heapifyUp(_heap.length - 1);
  }

  E removeFirst() {
    if (_heap.isEmpty) throw StateError('No elements in queue');
    final first = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _heapifyDown(0);
    }
    return first;
  }

  void _heapifyUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) >> 1;
      if (_compare(_heap[index], _heap[parentIndex]) >= 0) break;
      _swap(index, parentIndex);
      index = parentIndex;
    }
  }

  void _heapifyDown(int index) {
    final lastIndex = _heap.length - 1;
    while (true) {
      final leftChildIndex = (index << 1) + 1;
      final rightChildIndex = leftChildIndex + 1;

      int minIndex = index;

      if (leftChildIndex <= lastIndex &&
          _compare(_heap[leftChildIndex], _heap[minIndex]) < 0) {
        minIndex = leftChildIndex;
      }

      if (rightChildIndex <= lastIndex &&
          _compare(_heap[rightChildIndex], _heap[minIndex]) < 0) {
        minIndex = rightChildIndex;
      }

      if (minIndex == index) break;

      _swap(index, minIndex);
      index = minIndex;
    }
  }

  void _swap(int i, int j) {
    final tmp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = tmp;
  }
}

class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  final VoidCallback onReload;
  final dynamic leading;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    required this.onReload,
    required this.leading,
  });

  @override
  State<GradientAppBar> createState() => _GradientAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 26.0);
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: widget.gradient,
      ),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.leading,
            SizedBox(
              width: MediaQuery.of(context).size.width / 8,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
          ],
        ),
        // leading: CircleAvatar(
        //   backgroundImage: CachedNetworkImageProvider(widget.url),
        //   radius: 24,
        // ),
        // leading: InkWell(child: widget.leading,onTap: Navigator.pop(context),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       widget.onReload();
        //     },
        //     icon: const Icon(Icons.replay_outlined),
        //   ),
        // ],
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final double? buttonWidth;
  final VoidCallback onPressed;
  final dynamic backgroundColor;
  final String text;
  final dynamic icon;
  const CustomElevatedButton(
      {Key? key,
      this.buttonWidth,
      required this.onPressed,
      this.backgroundColor,
      required this.text,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: buttonWidth ?? MediaQuery.of(context).size.width - 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
