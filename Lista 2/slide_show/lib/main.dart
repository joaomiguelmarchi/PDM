import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Imagens PageView',
      home: _ImagensPageView(),
    );
  }
}

class _ImagensPageView extends StatefulWidget {
  const _ImagensPageView({Key? key}) : super(key: key);

  @override
  _ImagensPageViewState createState() => _ImagensPageViewState();
}

class _ImagensPageViewState extends State<_ImagensPageView> {
  final List<String> imagens = [
    'assets/images/cachorro.jpg',
    'assets/images/gardem.jpg',
    'assets/images/happy.jpg',
    'assets/images/patinho.jpg',
    'assets/images/porquinho.jpg',
  ];

  int _currentPageIndex = 0;

  void _voltar() {
    setState(() {
      _currentPageIndex = _currentPageIndex != 0 ? _currentPageIndex - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagens PageView'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: imagens.length,
            controller: PageController(
              initialPage: _currentPageIndex,
            ),
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                imagens[index],
              );
            },
          ),
          Positioned(
            top: 50,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                print(_currentPageIndex);
                _voltar;
                print(_currentPageIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
