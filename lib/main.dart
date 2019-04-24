import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// main method : entry point of program
void main() => runApp(MyApp());

// Root class of App : which set appbar and it's property
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // MaterialApp : provide material component like appBar and it's property
    return MaterialApp(
        title: "Words List",
        theme: ThemeData(          // Add the 3 lines from here...
          primaryColor: Colors.white,
        ),
        home: RandomWords()
    );
  }
}
//
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // words array
  final _biggerFont = const TextStyle(fontSize: 18.0); // font size
  final Set<WordPair> _saved = Set<WordPair>(); // set of words

  @override
  Widget build(BuildContext context) {
    // Scaffold : provide Appbar on Top and cover whole screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Words List'),
        actions: <Widget>[
          // IconButton : provide default icon
          // onPressed : use for click event
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  // use for Listview
  Widget _buildSuggestions() {
    // Listview :
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      //itemBuilder : provide each row in
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;

        //        print(" #### : Index $index ");

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRoW(_suggestions[index]);
      },
    );
  }

  Widget _buildRoW(WordPair word) {
    final bool alreadySaved = _saved.contains(word);
    return ListTile(
      title: Text(
        word.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.pink : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(word);
          } else {
            _saved.add(word);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text('Favorite List'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
