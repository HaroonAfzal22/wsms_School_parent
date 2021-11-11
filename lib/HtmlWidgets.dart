
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wsms/Shared_Pref.dart';

class HtmlWidgets extends StatefulWidget {
  const HtmlWidgets({
    Key? key,
    required this.responseHtml,
  }) : super(key: key);

  final  responseHtml;

  @override
  State<HtmlWidgets> createState() => _HtmlWidgetsState();
}

class _HtmlWidgetsState extends State<HtmlWidgets> {
  var newColor=SharedPref.getSchoolColor();



  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      '${widget.responseHtml.outerHtml}',
      customStylesBuilder: (element) {
        if (element.classes.contains('absent')) {
          return {
            'color': '#FF0000',
            'text-align': 'center',
            'font-size': '13px',
            'align': 'center'
          };
        }
        if (element.localName == 'th') {
          return {
            'color': '#ffffff',
            'font-weight': 'bold',
            'background-color': '#${newColor!.substring(newColor!.length - 6)}',
            'font-size': '16px',
            'text-align': 'center',
            'padding': '4px',
          };
        }

        if (element.localName == 'td') {
          return {
            'color': '#${newColor!.substring(newColor!.length - 6)}',
            'font-size': '13px',
            'text-align': 'center',
            'padding': '4px',
            'font-weight': 'bold',
          };
        }

        return null;
      },
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder:
          (context, element, loadingProgress) =>
          CircularProgressIndicator(),
      renderMode: RenderMode.listView,
      textStyle: TextStyle(
        fontSize: 15,
      ),
    );
  }
}
