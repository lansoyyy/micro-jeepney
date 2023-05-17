import 'package:flutter/material.dart';
import 'package:jeepney/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  final queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: TextRegular(text: 'Jeepney', fontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 325,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                decoration: const InputDecoration(
                    hintText: 'Search Location',
                    hintStyle: TextStyle(fontFamily: 'QRegular'),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    )),
                controller: queryController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBold(
                      text: 'Jeepney No.', fontSize: 16, color: Colors.black),
                  TextRegular(
                      text: 'Proximity', fontSize: 14, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      child: ListTile(
                        leading: TextBold(
                            text: 'Jeepney #$index',
                            fontSize: 14,
                            color: Colors.black),
                        trailing: TextRegular(
                            text: '60ms away',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
