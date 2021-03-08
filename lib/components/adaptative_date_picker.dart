import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AdaptativeDatePicker extends StatelessWidget {


  final DateTime selectedDate;
  final Function (DateTime) onDateChanged; // Notificar o pai

  AdaptativeDatePicker({
    this.selectedDate,
    this.onDateChanged
  });

_showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020), 
      lastDate: DateTime.now()
    ).then((value) {
      if (value == null) {
        return;
      }
      onDateChanged(value);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS 
    
    ? Container(
      height: 180,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        minimumDate: DateTime(2020),
        maximumDate: DateTime.now(),
        onDateTimeChanged: onDateChanged,
      ),
    )
    
    : Container(
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate == null ?  'Nenhuma data selecionada!' 
                : 'Data Selecionada: ${DateFormat('dd/MM/y').format(selectedDate)}'
              ),
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: () =>  _showDatePicker(context),
              child: Text(
                'Selecionar Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            )
          ],
        ),
      );
  }
}