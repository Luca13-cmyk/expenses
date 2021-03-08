import 'dart:ui';
import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:math';
import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';


main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp
    // ]);
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        errorColor: Colors.red[400],
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold

          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
        
              // fontSize: 20 * mediaQuery.textScaleFactor
              
              fontWeight: FontWeight.bold,
            )
          ),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> { 

  _openTransactionFormModal(BuildContext context) {

    showModalBottomSheet(context: context, builder: (_) {
      return TransactionForm(_addTransaction);
    });
  }


  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));

    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {

    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  final sw = Platform.isIOS; // toggle platform IOS = TRUE

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
          return tr.id == id;
      });
    });
  }


  Widget _getIconButton(IconData icon, Function fn) {
    return sw 
      ? 
      GestureDetector(onTap: fn, child: Icon(icon))
      : 
      IconButton(icon: Icon(icon), onPressed: fn,
      );
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final iconList = sw ? CupertinoIcons.refresh : Icons.list;
    final chartList = sw ? CupertinoIcons.refresh : Icons.show_chart;
  
    final actions = <Widget> [
          if (isLandScape) _getIconButton(
            _showChart ? iconList : chartList, () => {
            setState(() {
              _showChart = !_showChart;
            })
          } 
        ), // _getIconButton
          _getIconButton(sw ?  CupertinoIcons.add :  Icons.add, () => _openTransactionFormModal(context) ),

        ];

    final PreferredSizeWidget appBar = sw ?  
    
    CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(children: actions, mainAxisSize: MainAxisSize.min,),
    )
    
    : AppBar(
        title: Text('Despesas Pessoais',),
        actions: actions,
      );

    final availableHeight = mediaQuery.size.height 
    - appBar.preferredSize.height 
    - mediaQuery.padding.top;

    final bodyPage = SafeArea(
      
      child: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandScape)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('Exibir Grafico'),
            //     Switch.adaptive(
            //       activeColor: Theme.of(context).accentColor,
            //       value: _showChart,
            //        onChanged: (value) {
            //       setState(() {
            //         _showChart = value;
            //       });
            //     }
            //   ),
            //   ],
            // ),
          if (_showChart || !isLandScape) 
          Container(
            child: Chart(_recentTransactions),
            height: availableHeight * (isLandScape ? 0.8 : 0.3),
          ), 
          if (!_showChart || !isLandScape)
          Container(
            child: TransactionList(_transactions, _removeTransaction),
            height: availableHeight * (isLandScape ? 1 : 0.7),
            ),
          ],
        ),
      )
    );
    

    return sw 
      ?   
        CupertinoPageScaffold(navigationBar: appBar,  child: bodyPage)
    
      : Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButton: sw 
        ?
          Container() 

        : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}