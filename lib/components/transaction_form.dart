import 'package:flutter/material.dart';
import './adaptative_button.dart';
import './adaptative_textfield.dart';
import './adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {


  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {

  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {

    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0; // Caso n der certo. coloque o valor 0

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate); // Widget heranca assim como o context tbm recebe heranca
                      
  }

  

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
                bottom: 10 + MediaQuery.of(context).viewInsets.bottom
              ),
              child: Column(
                children: [
                  AdaptativeTextField(
                    label: 'Titulo',
                    controller: _titleController,
                    onSubmitted: (_) => _submitForm(), // Clica em concluir e fecha o teclado e submete
                  ),
                  AdaptativeTextField(
                    label: 'Valor (R\$)',
                    controller: _valueController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _submitForm(), // Clica em concluir e fecha o teclado e submete
                  ),
                  AdaptativeDatePicker(
                    selectedDate: _selectedDate,
                    onDateChanged: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    } ,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AdaptiveButton(
                        label: 'Nova Transacao',
                        onPressed: _submitForm,
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
    );
  }
}