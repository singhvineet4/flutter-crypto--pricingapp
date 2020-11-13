import 'package:flutter/material.dart';

@immutable
class PriceWidget extends StatelessWidget {
  PriceWidget({
    @required this.name,
    @required this.price,
  });

  final String name;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          '${price.toStringAsFixed(3)}\$',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
