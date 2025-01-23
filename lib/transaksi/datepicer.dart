import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {
  String parseToString(String dateFormat) {
    if (this == null) return '';
    return DateFormat(dateFormat).format(this!);
  }
}

extension StringExtension on String {
  DateTime parseToDateTime(String dateFormat) {
    if (length > dateFormat.length) return DateTime.now();
    try {
      return DateFormat(dateFormat).parse(this);
    } on FormatException catch (_) {
      return DateTime.now();
    }
  }
}

/// Class [Picker] helps display a date picker on web
class Picker extends StatefulWidget {
  const Picker({
    Key? key,
    this.initialDate,this.fd,
    this.firstDate,
    this.lastDate,
    required this.onChange,
    this.style,
    this.width = 200,
    this.height = 36,
    this.prefix,
    this.dateformat = 'yyyy/MM/dd',
  }) : super(key: key);

  /// The initial selected date.
  final DateTime? initialDate;
final FocusNode? fd;
  /// The earliest date the user is permitted to pick or input.
  final DateTime? firstDate;

  /// The latest date the user is permitted to pick or input.
  final DateTime? lastDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime?> onChange;

  /// The text style of the date form field
  final TextStyle? style;

  /// The width and height of the date form field
  final double width;
  final double height;

  /// The prefix of the date form field
  final Widget? prefix;

  /// The date format to display in the date form field
  final String dateformat;

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();

  late OverlayEntry _overlayEntry;
  late DateTime? _selectedDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _firstDate = widget.firstDate ?? DateTime(2000);
    _lastDate = widget.lastDate ?? DateTime(2100);

    if (_selectedDate != null) {
      _controller.text = _selectedDate?.parseToString(widget.dateformat) ?? '';
    }

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && !_isOverlayVisible) {
      _showOverlay();
    } else if (!_focusNode.hasFocus && _isOverlayVisible) {
      // _hideOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  // void _hideOverlay() {
  //   _overlayEntry.remove();
  //   setState(() {
  //     _isOverlayVisible = false;
  //   });
  // }

  void _onDateSelected(DateTime? selectedDate) {
    log("message");
    setState(() {
      _selectedDate = selectedDate;
      _controller.text = _selectedDate?.parseToString(widget.dateformat) ?? '';
      widget.onChange.call(_selectedDate);
      _overlayEntry.remove();
    setState(() {
      _isOverlayVisible = false;
     _focusNode.unfocus();

    });
    });
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 5,
            child: SizedBox(
              height: 250,
              child: CalendarDatePicker(
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: _firstDate,
                lastDate: _lastDate,
                onDateChanged: _onDateSelected,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: const OutlineInputBorder(),
            suffixIcon: widget.prefix ?? const Icon(Icons.date_range),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
