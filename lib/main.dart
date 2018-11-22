import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

/*
SETTINGS
*/

const String _name = 'Nob Ody';

/*
THEME DATA
*/

// iOS theme.
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

// Default and Android theme.
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.lime,
);

/*
MAIN APP
*/

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo3',
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

/*
CHAT ROUTE
*/

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Demo3 | Friendlychat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
      body: new Container(
        child: new Column(
          children: <Widget>[

            // List of chat messages.
            new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),

            // A divider between the chat messages and the input box.
            new Divider(height: 1.0),

            // The message input box.
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            ),

          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(
            border: new Border(
              top: new BorderSide(
                color: Colors.grey[200]
              ),
            ),
          )
          : null
        ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[

            // Text input field.
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(hintText: 'Write some stuff'),
              ),
            ),

            // Send text button.
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                ? new CupertinoButton(
                  child: new Text('Send'),
                  onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
                  )
                : new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
                ),
              ),

          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {

    // Delete the text from the text input field.
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    // Add the message to the list.
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 666),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

}

// The chat message box itself.
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(   // 2do: Add "FadeTransition" instead!
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // Avatar icon.
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),

            // Message box.
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Name of user.
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  // Chat message.
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}
