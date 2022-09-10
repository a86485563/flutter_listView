

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords()
      );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
           IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return  ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return  ListTile(
      title:  Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing:  Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      _createRoute()
    );
  }

  Route _createRoute(){
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => FavorTitleScreen(saved: _saved),
        //製造動畫的
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

          //由右至左
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }

    );
  }
}

class FavorTitleScreen extends StatelessWidget{
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> saved;

  const FavorTitleScreen({required this.saved});


  @override
  Widget build(BuildContext context) {

     Iterable<ListTile> tiles = saved.map(
           (WordPair pair) {
         return  ListTile(
           title:  Text(
             pair.asPascalCase,
             style: _biggerFont,
           ),
         );
       },
     );

     final List<Widget> divided = ListTile
         .divideTiles(context: context, tiles: tiles).toList();

     return  Scaffold(
       appBar:  AppBar(title: const Text('Saved Suggestions')),
       body: ListView(children: divided)
     );
  }
}