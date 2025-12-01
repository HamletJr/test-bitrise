import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jokes_come_true/models/product.dart';
import 'package:jokes_come_true/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jokes_come_true/screens/product_list.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.fields.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset('assets/images/jade_feather.png', width: 20),
                const SizedBox(width: 5),
                Text("${product.fields.price} Jade Feathers"),
              ],
            ),
            const SizedBox(height: 10),
            Text(product.fields.description.toString().trim()),
            const SizedBox(height: 10),
            Text(
              "Stock: ${product.fields.quantity}",
              style: TextStyle(
                color: product.fields.quantity > 10
                    ? Colors.green
                    : product.fields.quantity > 0
                        ? const Color.fromARGB(255, 204, 154, 15)
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Colors.red),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0)),
              ),
              onPressed: () async {
                final response = await request.postJson(
                  "http://127.0.0.1:8000/delete-flutter",
                  jsonEncode(<String, String>{
                    'id': product.pk.toString(),
                  }),
                );
                if (context.mounted) {
                  if (response['status'] == 'success') {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                        content: Text("${product.fields.name} has been sucessfully deleted."),
                      ));
                      // hanya remove product page yang paling baru, tidak menangani case dimana user
                      // udah pernah ke product page sebelumnya (males tanganin)
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const ProductPage()),
                      );
                  } else {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                        content:
                          Text("An error occured, please try again."),
                      ));
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );       
  }
}