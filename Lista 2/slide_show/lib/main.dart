import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imagens PageView',
      home: ImagensPageView(),
    );
  }
}

class ImagensPageView extends StatefulWidget {
  const ImagensPageView({Key? key}) : super(key: key);

  @override
  ImagensPageViewState createState() => ImagensPageViewState();
}

class ImagensPageViewState extends State<ImagensPageView> {
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
      _currentPageIndex = _currentPageIndex > 0 ? _currentPageIndex - 1 : 0;
    });
  }

  void _voltarPrimeira() {
    setState(() {
      _currentPageIndex = 0;
    });
  }

  void _avancar() {
    setState(() {
      _currentPageIndex = _currentPageIndex < imagens.length - 1
          ? _currentPageIndex + 1
          : _currentPageIndex;
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
            onPageChanged: (index) {
              setState(
                () {
                  _currentPageIndex = index;
                },
              );
            },
            itemBuilder: (BuildContext context, int index) {
              index = _currentPageIndex;
              return Image.asset(
                imagens[index],
                errorBuilder: (context, error, stacktrace) {
                  return const CircularProgressIndicator();
                },
              );
            },
          ),
          Positioned(
            top: 50,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _voltar();
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 190,
            child: IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: () {
                _voltarPrimeira();
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _avancar();
              },
            ),
          ),
        ],
      ),
    );
  }
}
