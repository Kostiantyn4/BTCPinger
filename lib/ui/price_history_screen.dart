import 'package:flutter/material.dart';

import '../l10n/gen/localization.dart';

class PriceHistoryScreen extends StatelessWidget {
  const PriceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Localization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.priceHistoryTitle),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.show_chart,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              localization.priceHistoryPlaceholder,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
