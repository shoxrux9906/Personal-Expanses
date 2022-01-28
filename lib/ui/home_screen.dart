import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_expenses/theme/app_theme.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transactions_list.dart';
import 'package:personal_expenses/models/transactions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Transaction> transactions = [];

  List<Transaction> get _recentTransactions {
    return transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state->$state}");
    super.didChangeAppLifecycleState(state);
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _addNewTransaction(String trTitle, double trAmount, DateTime date) {
    final newTr = Transaction(
      id: DateTime.now().toString(),
      title: trTitle,
      amount: trAmount,
      date: date,
    );

    setState(() {
      transactions.add(newTr);
    });
  }

  void _removeTransaction(String id) {
    setState(() {
      transactions.removeWhere(
        (tr) {
          return tr.id == id;
        },
      );
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeWidget(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (!isLandscape)
                  ? (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3
                  : (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.6,
              child: Chart(_recentTransactions),
            )
          : Container(),
      transactions.isNotEmpty ? txListWidget : Container(),
    ];
  }

  List<Widget> _buildPortraitWidget(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return [
      Column(
        children: [
          Container(
            height: (isLandscape)
                ? (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.6
                : (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
            child: Chart(_recentTransactions),
          ),
        ],
      ),
      transactions.isEmpty ? Container() : txListWidget,
    ];
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = _buildAppbar();

    double heightEntire = mediaQuery.size.height;
    double heightAppBar = appBar.preferredSize.height;
    double heightStatusBar = mediaQuery.padding.top;

    final noTrWidget = Container(
      height: (heightEntire - heightAppBar - heightStatusBar) * 0.7,
      child: Column(
        children: [
          Container(
            child: Text(
              "No Transactions yet!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.fontFamilyRoboto,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            'assets/images/search.png',
            width: 128,
            height: 128,
          ),
        ],
      ),
    );

    final txListWidget = Container(
      height: (heightEntire - heightAppBar - heightStatusBar) * 0.7,
      child: TransactionsList(transactions, _removeTransaction),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: transactions.isEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isLandscape)
                    ..._buildLandscapeWidget(mediaQuery, appBar, txListWidget),
                  if (!isLandscape)
                    ..._buildPortraitWidget(mediaQuery, appBar, txListWidget),
                  noTrWidget,
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (isLandscape)
                    ..._buildLandscapeWidget(mediaQuery, appBar, txListWidget),
                  if (!isLandscape)
                    ..._buildPortraitWidget(mediaQuery, appBar, txListWidget),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}
