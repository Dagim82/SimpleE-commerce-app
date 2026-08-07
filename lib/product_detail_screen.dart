import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'cart_provider.dart';
import 'cart_screen.dart';
import 'models.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final quantityInCart = ref.watch(cartProvider).quantityOf(product.id);
    final cartController = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              color: colorScheme.surfaceContainerHighest,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert01,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedStar,
                  size: 18,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '${product.rating.rate} (${product.rating.count} reviews)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 12),
                Chip(label: Text(product.category)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: quantityInCart == 0
              ? FilledButton.icon(
                  onPressed: () => cartController.add(product),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingCartAdd01,
                    size: 20,
                  ),
                  label: const Text('Add to cart'),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.outlined(
                            tooltip: 'Decrease',
                            onPressed: () =>
                                cartController.decrement(product.id),
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedMinusSign,
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$quantityInCart',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton.outlined(
                            tooltip: 'Increase',
                            onPressed: () =>
                                cartController.increment(product.id),
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedPlusSign,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        },
                        child: const Text('Go to cart'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
