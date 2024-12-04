import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Amount extends ConsumerWidget {
  const Amount({
    super.key,
    required this.amount,
    this.currencyFontSize = 12,
    this.amountFontSize = 20,
    required this.color,
    this.boldness = FontWeight.bold,
    this.align = TextAlign.start,
  });

  final double amount;
  final double currencyFontSize;
  final double amountFontSize;
  final Color color;
  final FontWeight boldness;
  final TextAlign align;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: align,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(0.0, -4.0),
              child: Text(
                'Rs.',
                style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: currencyFontSize,
                  color: color,
                  fontWeight: boldness,
                ),
              ),
            ),
          ),
          TextSpan(
            text: ' ${NumberFormat.decimalPattern().format(amount)}',
            style: TextStyle(
              fontFamily: 'Blinker',
              fontSize: amountFontSize,
              color: color,
              fontWeight: boldness,
            ),
          ),
        ],
      ),
    );
  }
}
