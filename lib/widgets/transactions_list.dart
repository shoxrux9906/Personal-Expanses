import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transactions.dart';
import 'package:personal_expenses/widgets/transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeTransaction;

  TransactionsList(
    this.transactions,
    this.removeTransaction,
  );

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return ListView(
      children:  transactions.map((tr) {
        return TransactionItem(
          key: ValueKey(tr.id),
          transaction: tr,
          isLandscape: isLandscape,
          removeTransaction: removeTransaction,
        );
      }).toList(),
    );
  }
}
