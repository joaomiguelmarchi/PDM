import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ApplicationWithIcon>? _apps;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
      includeAppIcons: true,
    );
    setState(() {
      _apps = apps.cast<ApplicationWithIcon>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Launcher'),
        ),
        body: _apps == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: _apps!.length,
                itemBuilder: (context, index) {
                  ApplicationWithIcon app = _apps![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Container(
                        child: app.icon.isEmpty
                            ? Image.memory(
                                app.icon,
                                width: 50,
                                height: 50,
                              )
                            : Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.image),
                                ),
                              ),
                      ),
                      title: Text(
                        app.appName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        DeviceApps.openApp(app.packageName);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.black,
                  );
                },
              ),
      ),
    );
  }
}
