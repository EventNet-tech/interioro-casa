import 'package:flutter/material.dart';
import 'package:interioro_casa/screens/design/tabbarnav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category.dart';

class CategoryBuilder extends StatelessWidget {
  CategoryBuilder({Key? key}) : super(key: key);

  Future<List<Category>> getAllCategories() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _categories.get();
    List<Category> l = [];
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return l;
  }

  final CollectionReference _categories =
      FirebaseFirestore.instance.collection('categories');

  final List<Category> categories = [
    Category('scene.jpg', 'Living Room'),
    Category('scene.jpg', 'Dining Hall'),
    Category('scene.jpg', 'Kitchen'),
    Category('scene.jpg', 'Master Bedroom'),
    Category('scene.jpg', 'Wardrobe'),
    Category('scene.jpg', 'Garage'),
    Category('scene.jpg', 'Bathroom'),
    Category('scene.jpg', 'Lounge'),
  ];

  Widget cardBuilder(BuildContext context, int index) {
    final category = categories[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Productsview(
                      passedcats: categories,
                      selectedtabindex: index,
                    )));
      },
      child: Card(
          color: const Color.fromRGBO(160, 188, 194, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: Image.asset('assets/scene.jpg')),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                category.categorytype,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    getAllCategories();
    return StreamBuilder(
        stream: _categories.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: streamSnapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) => cardBuilder(context, index));
          } else {
            return const Text("Something went wrong!!");
          }
        });
  }

  
}