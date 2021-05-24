import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bullet journal',
      home: BulletJournals(),
    );
  }
}

class BulletJournals extends StatefulWidget {
  @override
  _BulletJournalsState createState() => _BulletJournalsState();
}

class _BulletJournalsState extends State<BulletJournals> {
  final _journal = <String>[];
  // final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildJournals() {
    return ListView.builder(
        itemCount: _journal.length,
        itemBuilder: (context, i) {
          // return const Text('data');
          // if (_journal.length == 0) {
          //   return null;
          // }
          // if (_journal.length <= i) {
          //   return null;
          // }
          // // if (i.isOdd) {
          // //   return const Divider();
          // // }
          return _buildRow(_journal[i]);
        });
  }

  Widget _buildRow(String journal) {
    List<DropdownMenuItem<int>> _items = List();
    int _selectItem = 0;

    void setItems() {
      _items
        ..add(DropdownMenuItem(
          child: Text(
            '・',
            style: TextStyle(fontSize: 40.0),
          ),
          value: 1,
        ))
        ..add(DropdownMenuItem(
          child: Text(
            '×',
            style: TextStyle(fontSize: 40.0),
          ),
          value: 2,
        ))
        ..add(DropdownMenuItem(
          child: Text(
            '＞',
            style: TextStyle(fontSize: 40.0),
          ),
          value: 3,
        ));
    }

    @override
    void initState() {
      super.initState();
      setItems();
      _selectItem = _items[0].value;
    }

    return ListTile(
      title: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'input task'),
      ),
      trailing: DropdownButton(
        items: _items,
        value: _selectItem,
        onChanged: (int value) => {
          setState(() {
            _selectItem = value;
          }),
        },
      ),
      // Text(
      //   journal,
      //   style: _biggerFont,
      // ),
    );
  }

  void _addJournal() {
    setState(() {
      _journal.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bullet journal'),
      ),
      body: _buildJournals(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addJournal,
        tooltip: '追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RondomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RondomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    final icon = Icon(
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
    );
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: icon,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }
}
