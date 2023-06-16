import 'package:flutter/material.dart';

import 'githubItem.dart';
import 'api.dart';
import 'repo.dart';

class GithubProject extends StatefulWidget {
  @override
  _GithubProjectState createState() => _GithubProjectState();
}

class _GithubProjectState extends State<GithubProject> {
  List<Repo> _repos = List();
  bool _isFetching = false;
  String _error;

  @override
  void initState() {
    super.initState();
    loadTrendingRepos();
  }

  void loadTrendingRepos() async {
    setState(() {
      _isFetching = true;
      _error = null;
    });

    final repos = await Api.getUsersRepositories();
    setState(() {
      _isFetching = false;
      if (repos != null) {
        this._repos = repos;
      } else {
        _error = 'Error fetching repos';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Github Repository'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_isFetching) {
      return Container(
          alignment: Alignment.center, child: Icon(Icons.timelapse));
    } else if (_error != null) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            _error,
            style: Theme.of(context).textTheme.headline,
          ));
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _repos.length,
          itemBuilder: (BuildContext context, int index) {
            return GithubItem(_repos[index]);
          });
    }
  }
}
