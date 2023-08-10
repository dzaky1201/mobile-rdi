import 'package:cashflow_rdi/home/presentation/entities/register_request_model.dart';
import 'package:cashflow_rdi/home/respository/home_repository.dart';
import 'package:cashflow_rdi/login/login.dart';
import 'package:cashflow_rdi/summary/presentation/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static const appTitle = 'Drawer Menu';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          listTileTheme:
              const ListTileThemeData(selectedColor: Colors.deepOrange)),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;
  var title = '';

  var homeRepository = HomeRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SummaryPage(),
    Text(
      'Index 1: Operasional',
      style: optionStyle,
    ),
    Text(
      'Index 2: Invest',
      style: optionStyle,
    ),
    Text(
      'Index 3: Keuangan',
      style: optionStyle,
    ),
    Text(
      'Index 4: Akun',
      style: optionStyle,
    ),
    Text(
      'Index 5: Periode',
      style: optionStyle,
    ),
    Text(
      'Index 6: keluar',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (prefs.getString('token') == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah user'),
          content: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _name,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Masukan nama !";
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('nama'),
                          hintText: "Isikan nama"),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Masukan email !";
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('email'),
                            hintText: "Isikan email"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        controller: _password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Masukan password !";
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text('password'),
                          hintText: "masukan password",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Text(_nameValue)
                  ],
                )),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
                _name.text = '';
                _email.text = '';
                _password.text = '';
              },
            ),
            TextButton(
              child: const Text('Tambah user'),
              onPressed: () {
                setState(() {
                  homeRepository
                      .registerAccount(RegisterRequestModel(
                          name: _name.text.trim(),
                          email: _email.text.trim(),
                          password: _password.text))
                      .then((value) {
                    if (value.code == 200) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('User berhasil ditambahkan')));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value.status)));
                      Navigator.of(context).pop();
                    }
                  });
                });
                // signUp();
              },
            ),
          ],
        );
      },
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Pagi';
    }
    if (hour < 17) {
      return 'Sore';
    }
    return 'Malam';
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedIndex) {
      case == 0:
        {
          title = "Ringkasan kas";
        }
        break;
      case == 1:
        {
          title = 'Operasional';
        }
        break;
      case == 2:
        {
          {
            title = 'Invest';
          }
          break;
        }
      case == 3:
        {
          {
            title = 'Keuangan';
          }
          break;
        }
      case == 4:
        {
          {
            title = 'Akun';
          }
          break;
        }
      case == 5:
        {
          {
            title = 'Periode';
          }
          break;
        }
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepOrange),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Text('Selamat ${greeting()}',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.summarize),
              title: const Text('Ringkasan'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text('Operasional'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Invest'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.paid),
              title: const Text('keuangan'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            const Divider(height: 25, thickness: 1),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Akun'),
              selected: _selectedIndex == 4,
              onTap: () async {
                setState(() async {
                  await _showMyDialog();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Periode'),
              selected: _selectedIndex == 5,
              onTap: () {
                // Update the state of the app
                _onItemTapped(5);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: const Text(
                                        'Apakah anda yakin ingin keluar ?')),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => {
                                                logout(),
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          // HomeLayout(loginData: data.data, token: value!)
                                                          const LoginPages()),
                                                )
                                              },
                                          child: const Text('Ya',
                                              style: TextStyle(
                                                  color: Colors.deepOrange))),
                                      TextButton(
                                          onPressed: () =>
                                              {Navigator.pop(context)},
                                          child: const Text('Tidak',
                                              style: TextStyle(
                                                  color: Colors.deepOrange)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
