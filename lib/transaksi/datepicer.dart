import 'package:flutter/material.dart';
import 'package:intl/intl.dart';





class Picker extends StatefulWidget {
   const Picker({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onChange,
    this.style,required this.fd,
    this.width = 200,
    this.height = 36,
    this.prefix,
    this.dateformat = 'yyyy/MM/dd',
  }) : super(key: key);

  /// The initial date first
  final DateTime? initialDate;
final FocusNode fd;
  /// The earliest date the user is permitted to pick or input.
  final DateTime? firstDate;

  /// The latest date the user is permitted to pick or input.
  final DateTime? lastDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime?> onChange;

  /// The text style of date form field
  final TextStyle? style;

  /// The width and height of date form field
  final double width;
  final double height;

  /// The prefix of date form field
  final Widget? prefix;

  /// The date format will be displayed in date form field
  final String dateformat;

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<Picker> {
  final TextEditingController _dateController = TextEditingController();
  DateTime temp=DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:temp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
           widget.onChange.call(pickedDate);
    temp=pickedDate;

      setState(() {
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }
@override
  void initState(){
  
  if(widget.initialDate!=null){
    temp=widget.initialDate!;
      _dateController.text = "${widget.initialDate!.year}-${widget.initialDate!.month.toString().padLeft(2, '0')}-${widget.initialDate!.day.toString().padLeft(2, '0')}";

  }  

  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a date";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
