import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RSSYle extends StatefulWidget {
  @override
  _RSSYleState createState() => _RSSYleState();
}

class _RSSYleState extends State<RSSYle> {
  late RssFeed _feed = RssFeed(title: '', items: []);
  late String _title;
  late String _url =
      'https://feeds.yle.fi/uutiset/v1/recent.rss?publisherIds=YLE_UUTISET';

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> fetchData() async {
    final client = http.Client();

    try {
      final response = await client.get(Uri.parse(_url));
      final feed = RssFeed.parse(response.body);
      updateFeed(feed);
      updateTitle(feed.title ?? 'Yle Uutiset');
    } catch (e) {
      print(e);
    }

    client.close();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _feed == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _feed.items?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final item = _feed.items?[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item?.title ?? '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(item?.pubDate?.toString() ?? ''),
                          if (item?.enclosure?.url != null)
                            Image.network(
                              item!.enclosure!.url!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            item?.description ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => print(item?.link),
                            child: const Text('Lue lisää'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
      ],
    );
  }
}
