import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String icon;
  final String label;
  final String sublabel;

  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
  });

	@override
	Widget build(BuildContext context) {
		final width = MediaQuery.of(context).size.width;
		return Container(
			width: width * 0.4,
			padding: const EdgeInsets.all(12),
			decoration: BoxDecoration(
				color: Colors.white.withAlpha((0.9 * 255).toInt()),
				borderRadius: BorderRadius.circular(16),
			),
			child: Column(
				children: [
				Image.asset(
					icon,
					width: 32,
					height: 32,
				),
				const SizedBox(height: 8),
				Text(
					label,
					style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					),
				),
				Text(
					sublabel,
					style: const TextStyle(
					fontSize: 12,
					color: Colors.black54,
					),
				),
				],
			),
		);
  	}
}
