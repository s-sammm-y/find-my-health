import 'package:flutter/material.dart';
import 'package:health_sync/widgets/book_ambulance.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const SizedBox(height: 3,),
              // const GenerelSearchbar(),
            //  const SizedBox(height: 10,),
              BookAmbulanceCard(),
              const SizedBox(height: 16,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  
                  children: <Widget>[ Text(
                  'Book Ambulance',
                  textAlign: TextAlign.left,
                  
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    
                  ),
                              ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.lightBlue.withOpacity(0.5)),
                    border: InputBorder.none,
                    icon:const Icon(Icons.search, color: Colors.lightBlue),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          
            ],
          ),
        ),
      ),
    );
  }
}