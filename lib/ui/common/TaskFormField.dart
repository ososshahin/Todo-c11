import 'package:flutter/material.dart';

typedef Validator = String? Function (String? text);

class TaskFormField extends StatefulWidget {
  String title;
  int? lines;
  String hint;
  TextInputType keyboardType ;
  bool securedPassword ;
  Validator? validator = null;
  TextEditingController? controller = null;
  TaskFormField({required this.title,
    required this.hint,
   this.keyboardType = TextInputType.text,
    this.securedPassword = false,
    this.validator,
    this.controller,
    this.lines
  });

  @override
  State<TaskFormField> createState() => _TaskFormFieldState();
}

class _TaskFormFieldState extends State<TaskFormField> {
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

          TextFormField(
            maxLines: widget.lines,
            validator: widget.validator,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              label: Text(widget.title,style: TextStyle(color: Colors.blue),),
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
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
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
