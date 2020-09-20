import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'API.dart';
import 'dart:convert';

import 'messageupload.dart';

class Home extends StatefulWidget {
  final String sid;final String rid;
  Home({this.rid,this.sid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleTranslator translator = new GoogleTranslator();
  String url;
  String out = "";
  String res = "";
  var data;

  var languages = {
    "afrikaans": "af",
    "albanian": "sq",
    "amharic": "am",
    "arabic": "ar",
    "armenian": "hy",
    "azerbaijani": "az",
    "basque": "eu",
    "belarusian": "be",
    "bengali": "bn",
    "bosnian": "bs",
    "bulgarian": "bg",
    "catalan": "ca",
    "cebuano": "ceb",
    "chinese simplified": "zh",
    "chinese traditional": "zh-TW ",
    "corsican": "co",
    "croatian": "hr",
    "czech": "cs",
    "danish": "da",
    "dutch": "nl",
    "english": "en",
    "esperanto": "eo",
    "estonian": "et",
    "finnish": "fi",
    "french": "fr",
    "frisian": "fy",
    "galician": "gl",
    "georgian": "ka",
    "german": "de",
    "greek": "el",
    "gujarati": "gu",
    "haitian": "ht",
    "hausa": "ha",
    "hawaiian": "haw",
    "hebrew": "he",
    "hindi": "hi",
    "hmong": "hmn",
    "hungarian": "hu",
    "icelandic": "is",
    "igbo": "ig",
    "indonesian": "id",
    "irish": "ga",
    "italian": "it",
    "japanese": "ja",
    "javanese": "jv",
    "kannada": "kn",
    "kazakh": "kk",
    "khmer": "km",
    "kinyarwanda": "rw",
    "korean": "ko",
    "kurdish": "ku",
    "kyrgyz": "ky",
    "lao": "lo",
    "latin": "la",
    "latvian": "lv",
    "lithuanian": "lt",
    "luxembourgish": "lb",
    "macedonian": "mk",
    "malagasy": "mg",
    "malay": "ms",
    "malayalam": "ml",
    "maltese": "mt",
    "maori": "mi",
    "marathi": "mr",
    "mongolian": "mn",
    "myanmar": "my",
    "burmese": "my",
    "nepali": "ne",
    "norwegian": "no",
    "nyanja": "ny",
    "odia": "or",
    "pashto": "ps",
    "persian": "fa",
    "polish": "pl",
    "portuguese": "pt",
    "punjabi": "pa",
    "romanian": "ro",
    "russian": "ru",
    "samoan": "sm",
    "scots": "gd",
    "serbian": "sr",
    "sesotho": "st",
    "shona": "sn",
    "sindhi": "sd",
    "sinhala": "si",
    "slovak": "sk",
    "slovenian": "sl",
    "somali": "so",
    "spanish": "es",
    "sundanese": "su",
    "swahili": "sw",
    "swedish": "sv",
    "tagalog": "tl",
    "tajik": "tg",
    "tamil": "ta",
    "tatar": "tt",
    "telugu": "te",
    "thai": "th",
    "turkish": "tr",
    "turkmen": "tk",
    "ukrainian": "uk",
    "urdu": "ur",
    "uyghur": "ug",
    "uzbek": "uz",
    "vietnamese": "vi",
    "welsh": "cy",
    "xhosa": "xh",
    "yiddish": "yi",
    "yoruba": "yo",
    "zulu": "zu",
  };

  final lang = TextEditingController();


  void trans(String res) {
    translator
        .translate(res, to: languages[lang.text.toLowerCase()])
        .then((output) {
      setState(() {
        out = output.toString();
      });
      print(output);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(" Mischief Translator")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             
              TextField(
                textAlign: TextAlign.center,
                decoration: new InputDecoration(hintText: 'Text'),
                style: TextStyle(fontSize: 20),
                onChanged: (value) {
                  url =
                      "https://sillytranslator.herokuapp.com/translate?text=" +
                          value.toString();
                },
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: new InputDecoration(hintText: 'Language'),
                style: TextStyle(fontSize: 20),
                controller: lang,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  data = await Getdata(url);
                  var decodedData = jsonDecode(data);
                  setState(() {
                    res = decodedData['result'];
                  });
                  trans(res);
                },
                child: Text('Translate!', style: TextStyle(fontSize: 17)),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      out.toString(),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  if (out.length != 0) ...[
                    RaisedButton(onPressed: () {
                      MessageSend().sendMessage(widget.sid, widget.rid, out);
                    }, child: Text('SEND'))
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}










