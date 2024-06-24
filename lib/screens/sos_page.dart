import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/models/emergency_contacts.dart';
import '../components/app_bar.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactsPage extends StatefulWidget {
  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final List<EmergencyContact> _contacts = [];
  final List<EmergencyContact> _selectedContacts = [];
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isShakeEnabled = false;
  ShakeDetector? detector;

  String? _selectedCountryCode = '+351';

  @override
  void initState() {
    super.initState();
    _initializeService();
    _fetchContacts();
    _loadPreferences();
  }

  Future<void> _initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: false,
        autoStartOnBoot: false,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  void onStart(ServiceInstance service) {
    service.on('startShakeService').listen((event) {
      detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          service.invoke('sendSOS');
        },
      );
    });

    service.on('stopShakeService').listen((event) {
      detector?.stopListening(); // Stop listening when disabled
      detector = null; // Set detector to null
    });

    service.on('sendSOS').listen((event) {
      _sendEmergencyMessage();
    });
  }

  Future<void> _fetchContacts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('emergencyContacts')
          .get();
      setState(() {
        _contacts.clear();
        for (var doc in snapshot.docs) {
          _contacts.add(EmergencyContact.fromMap(doc.data()));
        }
      });
    }
  }

  Future<void> _addContact() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newContact = EmergencyContact(
          name: _nameController.text,
          phoneNumber: '$_selectedCountryCode${_phoneController.text}',
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('emergencyContacts')
            .add(newContact.toMap());
        setState(() {
          _contacts.add(newContact);
        });
        _nameController.clear();
        _phoneController.clear();
        _savePreferences();
      }
    }
  }

  Future<void> _sendEmergencyMessage() async {
    // Request SMS permission
    final smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      final smsResult = await Permission.sms.request();
      if (!smsResult.isGranted) {
        print('SMS permission denied');
        return;
      }
    }

    // Request location permission
    final locationStatus = await Permission.locationWhenInUse.status;
    if (!locationStatus.isGranted) {
      final locationResult = await Permission.locationWhenInUse.request();
      if (!locationResult.isGranted) {
        print('Location permission denied');
        return;
      }
    }

    // Get current location
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Error getting location: $e');
      return;
    }

    for (var contact in _selectedContacts) {
      final uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {
          'body': 'You were activated as an Emergency contact. Current location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}'
        },
      );
      final uriString = uri.toString();
      await launchUrl(Uri.parse(uriString));
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isShakeEnabled', isShakeEnabled);
    List<String> selectedContactIds = _selectedContacts.map((contact) => contact.phoneNumber).toList();
    prefs.setStringList('selectedContacts', selectedContactIds);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isShakeEnabled = prefs.getBool('isShakeEnabled') ?? false;
    });

    List<String>? selectedContactIds = prefs.getStringList('selectedContacts');
    if (selectedContactIds != null) {
      for (var contact in _contacts) {
        if (selectedContactIds.contains(contact.phoneNumber)) {
          setState(() {
            _selectedContacts.add(contact);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xF7ABACFF),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.shakeToSend),
                      trailing: Switch(
                        value: isShakeEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            isShakeEnabled = newValue;
                            if (newValue) {
                              FlutterBackgroundService().invoke('startShakeService');
                            } else {
                              FlutterBackgroundService().invoke('stopShakeService');
                            }
                            _savePreferences();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                      child: Text(AppLocalizations.of(context)!.shakeDesc),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(child: Text(AppLocalizations.of(context)!.addContact)),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountryCode,
                    items: [
                      DropdownMenuItem(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/portuguese.png',
                              width: 30,
                              height: 30,
                            ),
                            Text('+351'),
                          ],
                        ),
                        value: '+351',
                      ),
                      DropdownMenuItem(
                        child: Text('+1'),
                        value: '+1',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryCode = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.countryCode,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phoneNumber),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white
              ),
              onPressed: _addContact,
              child: Text(AppLocalizations.of(context)!.addContact),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return CheckboxListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    value: _selectedContacts.contains(contact),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedContacts.add(contact);
                        } else {
                          _selectedContacts.remove(contact);
                        }
                        _savePreferences();
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white
              ),
              onPressed: _sendEmergencyMessage,
              child: Text(AppLocalizations.of(context)!.sendEmergencyMessage),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBarCustom(selectedIndex: 4),
    );
  }
}
