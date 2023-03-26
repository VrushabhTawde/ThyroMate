import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thyroid Diagnosis App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Thyroid Diagnosis App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  static const List<String> Symptoms = <String>[
    // hypo
    'fatigue',
    'weight gain',
    'weight loss',
  ];
  final List<String> hypoSymptoms = [
    'weight gain',
  ];

  final List<String> hyperSymptoms = [
    'weight loss',
  ];

  List<String> selectedSymptoms = [];

  String _checkSymptoms(List<String> symptoms) {
    bool hypo = true;
    bool hyper = true;

    for (var symptom in symptoms) {
      if (!Symptoms.contains(symptom)) {
        continue;
      }
      if (!hypoSymptoms.contains(symptom)) {
        hypo = false;
      }
      if (!hyperSymptoms.contains(symptom)) {
        hyper = false;
      }
    }

    if (hypo) {
      return 'Hypothyroidism';
    } else if (hyper) {
      return 'Hyperthyroidism';
    } else {
      return 'No diagnosis';
    }
  }

  void _onDiagnosePressed() {
    String diagnosis = _checkSymptoms(selectedSymptoms);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Diagnosis'),
          content: Text(diagnosis),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Autocomplete<String>(
          optionsViewBuilder: (context, onSelected, options) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final dynamic option = options.elementAt(index);
                        return TextButton(
                          onPressed: () {
                            onSelected(option);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                '#$option',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return Symptoms.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selectedTag) {
            _controller.addTag = selectedTag;
          },
          fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
            return TextFieldTags(
              textEditingController: ttec,
              focusNode: tfn,
              textfieldTagsController: _controller,
              // initialTags: const [
              //   'pick',
              //   'your',
              //   'favorite',
              //   'programming',
              //   'language',
              // ],
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (tag == 'php') {
                  return 'No, please just no';
                } else if (_controller.getTags!.contains(tag)) {
                  return 'you already entered that';
                }
                return null;
              },
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0),
                        ),
                        helperText: 'Enter language...',
                        helperStyle: const TextStyle(
                          color: Color.fromARGB(255, 74, 137, 92),
                        ),
                        hintText: _controller.hasTags ? '' : "Enter tag...",
                        errorText: error,
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: _distanceToField * 0.74),
                        prefixIcon: tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: tags.map((String tag) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      color: Color.fromARGB(255, 74, 137, 92),
                                    ),
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Text(
                                            '#$tag',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            //print("$tag selected");
                                          },
                                        ),
                                        const SizedBox(width: 4.0),
                                        InkWell(
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 14.0,
                                            color: Color.fromARGB(
                                                255, 233, 233, 233),
                                          ),
                                          onTap: () {
                                            onTagDelete(tag);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        selectedSymptoms =
                            value.split(',').map((e) => e.trim()).toList();
                        print(selectedSymptoms);
                      },
                      onSubmitted: onSubmitted,
                    ),
                  );
                });
              },
            );
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 74, 137, 92),
            ),
          ),
          onPressed: () {
            _controller.clearTags();
          },
          child: const Text('CLEAR TAGS'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 74, 137, 92),
            ),
          ),
          onPressed: () {
            _onDiagnosePressed();
          },
          child: const Text('Diagnosis'),
        ),
      ]),
    );

    // body: Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           'Select your symptoms',
    //           style: TextStyle(fontSize: 20.0),
    //         ),
    //         SizedBox(height: 16.0),
    //         TextField(
    //           decoration: InputDecoration(
    //             border: OutlineInputBorder(),
    //             labelText: 'Type your symptoms separated by commas',
    //           ),
    //           onChanged: (value) {
    //             selectedSymptoms = value.split(',').map((e) => e.trim()).toList();
    //           },
    //         ),
    //         SizedBox(height: 16.0),
    //         ElevatedButton(
    //           onPressed: _onDiagnosePressed,
    //           child: Text('Diagnose'),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  }
}
