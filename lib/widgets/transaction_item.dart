import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transactions.dart';
import 'package:personal_expenses/theme/app_theme.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.isLandscape,
    required this.removeTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final bool isLandscape;
  final Function removeTransaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color? _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.purple,
      Colors.blue,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 5,
      // color: Color.fromRGBO(220, 220, 220, 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              '\$${widget.transaction.amount}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: AppTheme.fontFamilyRoboto,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.fontFamilyRoboto,
          ),
        ),
        subtitle: Text(
          '${DateFormat.yMMMd().format(widget.transaction.date)}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: AppTheme.fontFamilyRoboto,
          ),
        ),
        trailing: (!widget.isLandscape)
            ? IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    widget.removeTransaction(widget.transaction.id))
            : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                ),
                onPressed: () =>
                    widget.removeTransaction(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              ),
      ),
    );
  }
}
