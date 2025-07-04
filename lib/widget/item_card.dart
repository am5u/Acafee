import 'package:ammarcafe/contest/colors.dart';
import 'package:ammarcafe/models/item_class.dart';
import 'package:ammarcafe/screen/signleitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onAddToCart;
  const ItemCard({super.key, 
    required this.item,
    required this.onAddToCart,
  });



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cardAccent,
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardBackground,
              spreadRadius: 1,
              blurRadius: 8,
            ), // BoxShadow
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  SingleItemScreen(item:item )));
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image(
                image: AssetImage(item.imageUrl),
                width: 120,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.center,
              child: Column(children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cardText),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "best Coffe",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  "${item.price}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(width: 30,),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: onAddToCart,
 
                    icon: const Icon(
                      CupertinoIcons.add,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
