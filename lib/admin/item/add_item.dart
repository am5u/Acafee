import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const AddItemScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController itemController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String selectedSize = "Medium";
  bool isLoading = false;

  late CollectionReference items;

  @override
  void initState() {
    super.initState();
    items = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("items");
  }

  Future<void> addItem() async {
    String itemName = itemController.text.trim();
    String description = descriptionController.text.trim();
    String price = priceController.text.trim();
    String image = imageController.text.trim();

    if (itemName.isEmpty || description.isEmpty || price.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await items.add({
        "name": itemName,
        "description": description,
        "price": "$price EGP",
        "image": "assets/image/drinks/$image",
        "size": selectedSize,
        "createdAt": FieldValue.serverTimestamp(),
      });

      itemController.clear();
      descriptionController.clear();
      priceController.clear();
      imageController.clear();

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil("AdminPanel", (route) => false);
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add item: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    itemController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: itemController,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price (EGP)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: "Image Name (e.g., coffee.png)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedSize,
                    decoration: const InputDecoration(
                      labelText: "Cup Size",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Small", "Medium", "Large"].map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
      ),
    );
  }
}
