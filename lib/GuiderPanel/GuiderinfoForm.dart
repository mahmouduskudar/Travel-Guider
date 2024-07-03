import 'dart:io';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/services/cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class GuiderInfoForm extends StatefulWidget {
  @override
  _GuiderInfoFormState createState() => _GuiderInfoFormState();
}

class _GuiderInfoFormState extends State<GuiderInfoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guider Info Form'),
      ),
      body: FutureBuilder(
        future: LoginFormPage.currentCustomer.getGuiderProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!'),
            );
          }

          final guider = snapshot.data as Guider;

          return _GuiderInfoFormBody(
            key: ValueKey(guider),
            guider: guider,
          );
        },
      ),
    );
  }
}

class _GuiderInfoFormBody extends StatefulWidget {
  final Guider guider;
  const _GuiderInfoFormBody({
    super.key,
    required this.guider,
  });

  @override
  State<_GuiderInfoFormBody> createState() => __GuiderInfoFormBodyState();
}

class __GuiderInfoFormBodyState extends State<_GuiderInfoFormBody> {
  String? _imageLink;
  File? _imageFile;
  String? _fullName;
  String? _bio;
  int? _dailyPrice;
  List<Weekday> _selectedWeekdays = [];
  List<File> _myPlaces = [];
  List<String> _myPlaceLinks = [];

  // initstate
  @override
  void initState() {
    super.initState();
    _imageLink = widget.guider.guiderImage;
    _fullName = widget.guider.fullName;
    _bio = widget.guider.bio;
    _dailyPrice = widget.guider.dailyPrice;
    _selectedWeekdays = widget.guider.workingDays
        .map(
          (e) => Weekday.values[e],
        )
        .toList();
    _myPlaceLinks = widget.guider.images ?? [];
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    _imageLink = null;

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  void _selectWeekday(Weekday weekday) {
    setState(() {
      if (_selectedWeekdays.contains(weekday)) {
        _selectedWeekdays.remove(weekday);
      } else {
        _selectedWeekdays.add(weekday);
      }
    });
  }

  void _pickMyPlaces() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      _myPlaceLinks = [];
    }

    _myPlaces = pickedFiles.map(
      (pickedFile) {
        return File(
          pickedFile.path,
        );
      },
    ).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : _imageLink != null
                            ? DecorationImage(
                                image: NetworkImage(_imageLink!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 50.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _fullName = value),
                initialValue: _fullName,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onChanged: (value) => setState(() => _bio = value),
                initialValue: _bio,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Daily Price',
                  border: OutlineInputBorder(),
                  suffix: Text('\$'),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(
                  () => _dailyPrice = int.tryParse(value),
                ),
                initialValue: _dailyPrice?.toString(),
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select weekdays:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: Weekday.values.map((weekday) {
                      final isSelected = _selectedWeekdays.contains(weekday);
                      return ChoiceChip(
                        label: Text(weekday.toString().split('.').last),
                        selected: isSelected,
                        onSelected: (_) => _selectWeekday(weekday),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickMyPlaces,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Builder(
                    builder: (context) {
                      if (_myPlaceLinks.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _myPlaceLinks.length,
                          itemBuilder: (context, index) {
                            final file = _myPlaceLinks[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(file, height: 180.0),
                            );
                          },
                        );
                      }
                      if (_myPlaces.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _myPlaces.length,
                          itemBuilder: (context, index) {
                            final file = _myPlaces[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(file, height: 180.0),
                            );
                          },
                        );
                      }

                      return Center(
                        child: Text(
                          'Tap to select My Places images ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  try {
                    await EasyLoading.show(status: 'Loading...');

                    if (_imageFile != null) {
                      _imageLink =
                          await CloudStorage.instance.uploadFile(_imageFile!);
                    }

                    if (_myPlaces.isNotEmpty) {
                      for (var e in _myPlaces) {
                        try {
                          final upld =
                              await CloudStorage.instance.uploadFile(e);
                          if (upld != null) {
                            _myPlaceLinks.add(upld);
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    }

                    Map<String, dynamic> bodyStr =
                        await LoginFormPage.currentCustomer.updateGuider(
                      _fullName ?? '',
                      _selectedWeekdays.map((e) => e.index).toList(),
                      _imageLink ?? '',
                      _dailyPrice ?? 0,
                      _bio ?? '',
                      _myPlaceLinks,
                    );

                    if (bodyStr["status"] == 1) {
                      EasyLoading.showSuccess(
                          'Information updated successfully!');
                      Navigator.pop(context);
                    } else {
                      EasyLoading.showError(bodyStr["message"]);
                    }
                  } catch (e) {
                    EasyLoading.showError(e.toString());
                  }

                  EasyLoading.dismiss();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
