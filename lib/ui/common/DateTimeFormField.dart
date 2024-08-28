import 'package:flutter/material.dart';

typedef Validator = String? Function (String? text);

class DateTimeFormField extends StatefulWidget {
  String title;
   String hint;
  TextInputType keyboardType ;
  bool securedPassword ;
  Validator? validator = null;
  TextEditingController? controller = null;
  VoidCallback? onclick;
  DateTimeFormField({required this.title,
   this.keyboardType = TextInputType.text,
    this.securedPassword = false,
    this.validator,
    this.controller,
    this.onclick,
    required this.hint
  });

  @override
  State<DateTimeFormField> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends State<DateTimeFormField> {
  bool isVisibleText = true;

  @override
  void initState() {
    super.initState();
    isVisibleText = widget.securedPassword;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.blue
          ),),
          SizedBox(height: 12,),
          TextFormField(

            enableInteractiveSelection: false,
            focusNode: FocusNode(),
            onTap:   () {
              widget.onclick?.call();
            },
            validator: widget.validator,
            decoration: InputDecoration(
             hintText: widget.hint,
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 16
              ),
              suffixIcon: widget.securedPassword? InkWell(
                onTap: (){
                  setState(() {
                    isVisibleText = !isVisibleText;
                  });
                },
                child: Icon(
                    isVisibleText ? Icons.visibility_off_outlined : Icons.visibility),
              )
              :null,



              hintStyle: Theme.of(context).textTheme
                .titleSmall?.copyWith(
                color: Colors.black
              ),
            ),
            keyboardType: widget.keyboardType,
            obscureText: isVisibleText,
            controller: widget.controller,
          ),
        ],

      ),
    );
  }
}
