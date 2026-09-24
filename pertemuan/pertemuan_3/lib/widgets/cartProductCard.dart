import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Product Image
          Image.asset(
            'assets/kc-chicken-katsu-mediumSquareAt3X-v2.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),

          const SizedBox(width: 28),

          // Product Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chicken Katsu', style: TextStyle(fontSize: 20)),

                const SizedBox(height: 4),

                Text(
                  'Chicken Katsu with Teriyaki Sauce',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Rp20.000',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Quantity
          SizedBox(
            width: 48,
            height: 48,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '5',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
