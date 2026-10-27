import 'package:flutter/material.dart';

import 'budget_api.dart';
import 'budget_model.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late Future<List<BudgetProduct>> products;

  @override
  void initState() {
    super.initState();

    products = BudgetApi.getApiProducts();
  }

  void refreshProducts() {
    setState(() {
      products = BudgetApi.getApiProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'BudgetBuddy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: refreshProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ====================================
          // PAGE HEADER
          // ====================================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Products & Services',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text(
                  'Products retrieved from API',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // ====================================
          // API LIST
          // ====================================
          Expanded(
            child: FutureBuilder<List<BudgetProduct>>(
              future: products,

              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.cloud_off,
                            size: 65,
                            color: Colors.grey.shade500,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Unable to load products',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: refreshProducts,

                            icon: const Icon(Icons.refresh),

                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // EMPTY
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final productList = snapshot.data!;

                // LIST VIEW
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 90),

                  itemCount: productList.length,

                  itemBuilder: (context, index) {
                    final product = productList[index];

                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ========================================
      // ADD ITEM BUTTON
      // ========================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add Item selected')));
        },

        icon: const Icon(Icons.add),

        label: const Text('Add Item'),
      ),
    );
  }
}

// =================================================
// PRODUCT CARD
// =================================================

class ProductCard extends StatelessWidget {
  final BudgetProduct product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================
            // IMAGE
            // ==================================
            ClipRRect(
              borderRadius: BorderRadius.circular(14),

              child: SizedBox(
                width: double.infinity,

                height: 180,

                child: Image.network(
                  product.image,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,

                      child: const Icon(
                        Icons.shopping_bag,
                        size: 55,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 13),

            // ==================================
            // NAME
            // ==================================
            Text(
              product.name,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 7),

            // ==================================
            // CATEGORY
            // ==================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,

                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                product.category,

                style: TextStyle(
                  color: Colors.blue.shade700,

                  fontSize: 12,

                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 9),

            // ==================================
            // DESCRIPTION
            // ==================================
            Text(
              product.description,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 10),

            // ==================================
            // PRICE
            // ==================================
            Text(
              '${product.currency} '
              '${product.price.toStringAsFixed(2)}',

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ==================================
            // BUTTONS
            // ==================================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showProductDetails(context, product);
                    },

                    icon: const Icon(Icons.info_outline),

                    label: const Text('Details'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to budget.'),
                        ),
                      );
                    },

                    icon: const Icon(Icons.add),

                    label: const Text('Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// PRODUCT DETAILS
// =================================================

void showProductDetails(BuildContext context, BudgetProduct product) {
  showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        title: Text(product.name),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(product.description),

              const SizedBox(height: 15),

              Text(
                'Category: '
                '${product.category}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Price: '
                '${product.currency} '
                '${product.price.toStringAsFixed(2)}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Product ID: '
                '${product.id}',
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
