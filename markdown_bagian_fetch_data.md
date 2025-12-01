### Melakukan Fetch Data dari Django

1. Buatlah berkas baru pada direktori `lib/screens` dengan nama `list_newsentry.dart`.

2. Pada berkas `list_newsentry.dart`, impor _library_ yang dibutuhkan. 

:::warning
Ubahlah [APP_NAME] sesuai dengan nama proyek Flutter yang kalian buat.
:::

```dart
import 'package:flutter/material.dart';
import 'package:[APP_NAME]/models/news_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
...
```

3. Salinlah potongan kode berikut dan _paste_ pada `list_newsentry.dart`. Jangan lupa untuk mengimpor file atau modul yang diperlukan.

**Note:** Kita akan buat halaman detail (`news_detail.dart`) di langkah berikutnya, jadi untuk sementara kita comment dulu bagian navigasi ke detail.

```dart
import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';
import 'package:football_news/widgets/left_drawer.dart';
// import 'package:football_news/screens/news_detail.dart'; // Will be created later
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsEntryPage extends StatefulWidget {
  const NewsEntryPage({super.key});

  @override
  State<NewsEntryPage> createState() => _NewsEntryPageState();
}

class _NewsEntryPageState extends State<NewsEntryPage> {
  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    // TODO: Change the URL and don't forget to add trailing slash (/) at the end of URL!
    // final response = await request.get('http://[YOUR_APP_URL]/json/');
    final response = await request.get('http://localhost:8000/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to NewsEntry objects
    List<NewsEntry> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'There is no news in football news yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: InkWell(
                    onTap: () {
                      // TODO: Uncomment this after creating news_detail.dart
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => NewsDetailPage(
                      //       news: snapshot.data![index],
                      //     ),
                      //   ),
                      // );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Detail page will be created in next step!'),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                snapshot.data![index].thumbnail,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Title
                            Text(
                              snapshot.data![index].title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Category
                            Text('Category: ${snapshot.data![index].category}'),
                            const SizedBox(height: 6),

                            // Content preview
                            Text(
                              snapshot.data![index].content.length > 100
                                  ? '${snapshot.data![index].content.substring(0, 100)}...'
                                  : snapshot.data![index].content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 6),

                            // Featured indicator
                            if (snapshot.data![index].isFeatured)
                              const Text('Featured',
                                  style: TextStyle(
                                      color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
```

4. Sekarang buatlah halaman detail untuk menampilkan informasi lengkap dari setiap berita. Buatlah berkas baru pada direktori `lib/screens` dengan nama `news_detail.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntry news;

  const NewsDetailPage({super.key, required this.news});

  String _formatDate(DateTime date) {
    // Simple date formatter without intl package
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            if (news.thumbnail.isNotEmpty)
              Image.network(
                news.thumbnail,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured badge
                  if (news.isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                        'Featured',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category and Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          news.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(news.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Views count
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${news.newsViews} views',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 32),

                  // Full content
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
```

5. Sekarang kembali ke file `list_newsentry.dart` dan uncomment bagian import dan navigasi ke detail page:

```dart
// Uncomment this line at the top
import 'package:football_news/screens/news_detail.dart';

// Uncomment the onTap navigation inside InkWell
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewsDetailPage(
        news: snapshot.data![index],
      ),
    ),
  );
},
```

6. Tambahkan halaman `list_newsentry.dart` ke `widgets/left_drawer.dart` dengan menambahkan kode berikut.

```dart
// ListTile Menu code
...
ListTile(
    leading: const Icon(Icons.newspaper),
    title: const Text('News List'),
    onTap: () {
        // Route to news list page
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsEntryPage()),
        );
    },
),
...
```

7. Ubah fungsi tombol `See Football News` pada halaman utama agar mengarahkan ke halaman `NewsPage`. Kamu dapat melakukan _redirection_ dengan menambahkan `else if` setelah kode `if(...){...}` di bagian akhir `onTap: () { }` yang ada pada file `widgets/news_card.dart`.

```dart
...
else if (item.name == "See Football News") {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => const NewsEntryPage()
        ),
    );
}
...
```

8. Impor _file_ yang dibutuhkan saat menambahkan `NewsEntryPage` ke `left_drawer.dart` dan `news_card.dart`.

9. Jalankan aplikasi dan cobalah untuk menambahkan beberapa `NewsEntry` di situs web kamu. Kemudian, coba lihat hasilnya melalui halaman `Daftar News` yang baru saja kamu buat di aplikasi Flutter. Klik salah satu item untuk melihat detail lengkap berita tersebut.