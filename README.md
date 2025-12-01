# 🪶 Jokes Come True (Mobile)
**Nama:**   Joshua Montolalu<br>
**NPM:**    2306275746<br>
**Kelas:**  PBP F<br>

Versi mobile dari aplikasi web [Jokes Come True](https://github.com/HamletJr/jokes-come-true) menggunakan Flutter.

### Tugas Sebelumnya
| [Tugas 7](#7️⃣-tugas-7) | [Tugas 8](#8️⃣-tugas-8) | [Tugas 9](#9️⃣-tugas-9)
| - | - | - |

## 9️⃣ Tugas 9
### 1. Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?
Model sebenarnya tidak diperlukan, dan bisa saja tugas ini dikerjakan tanpa model sama sekali, namun model sangat berguna untuk mendefinisikan struktur dari data yang aplikasi kita akan menerima dan mengirim. Model membuat kita bisa menggunakan method-method `fromJson()` dan `toJson()` untuk melakukan serialisasi dan deserialisasi sehingga kode kita akan lebih rapi dan lebih terstruktur. Kita hanya perlu mendefinisikan *field-field* dan *property* apa saja yang dimiliki oleh model kita, dan ke depannya jika kita ingin mengolah data JSON kita hanya perlu memanggil fungsi tersebut yang terdapat dalam model kita. Tanpa model ini, kita harus secara manual mendefinisikan struktur dari JSON kita setiap kali kita menerima dan mengirim data.

### 2. Jelaskan fungsi dari library `http` yang sudah kamu implementasikan pada tugas ini
Library `http` menjadi *dependency*/*requirement* dari package `pbp_django_auth` yang digunakan pada tugas ini. Library `http` sendiri menyediakan kemampuan bagi aplikasi kita untuk melakukan request dan menerima response `http`. Library ini menyediakan berbagai fungsi yang dapat digunakan untuk melakukan *fetching* data dan transmisi data dengan berbagai method seperti GET, POST, DELETE, dan lain-lain. Pada tugas ini, library `http` digunakan untuk berkomunikasi dengan server Django dan melakukan *fetching* data produk, autentikasi user, dan mengirim data produk baru ke server. 

### 3. Jelaskan fungsi dari `CookieRequest` dan jelaskan mengapa *instance* `CookieRequest` perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
`CookieRequest` berfungsi untuk mengelola *session* yang disetel oleh server Django di dalam *cookie*. Ini membantu aplikasi kita untuk melakukan *request* ke server Django tanpa harus melakukan autentikasi setiap kali ingin melakukan *request*. Dengan kata lain, `CookieRequest` membantu membuat *request* kita menjadi *stateful*. Instance dari `CookieRequest` pun dibagi ke semua komponen di aplikasi Flutter agar setiap komponen dapat melakukan *request* menggunakan *cookie* dan info login yang sama. Dengan kata lain, setiap komponen dalam aplikasi kita akan memiliki *state* yang sama. Ini membantu untuk menjaga konsistensi data pada aplikasi kita, tetapi juga berguna untuk menghindari pengguna di-*prompt* berulang kali untuk memasukkan kredensial setiap kali ada komponen baru yang ingin melakukan *request*.

### 4. Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
Ketika user melakukan input, misalnya pada form *Add Product*, maka biasanya aplikasi Flutter akan melakukan validasi sederhana terlebih dahulu (jika diperlukan). Setelah itu, baru Flutter akan mengirim data tersebut dalam bentuk JSON ke server Django lewat request HTTP. Server Django akan menanggapi request tersebut dan melakukan proses *back-end*, seperti validasi tambahan, operasi CRUD pada database, autentikasi, pengolahan data, dan lain sebagainya. Setelah itu, server Django akan mengirim *response* berisi pesan JSON, yang kemudian akan diolah dan di-*parsing* oleh Flutter sehingga akhirnya dapat ditampilkan kepada pengguna.

### 5. Jelaskan mekanisme autentikasi dari *login*, *register*, hingga *logout*. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
Proses autentikasi mulai dari login. Jika user sudah memiliki akun, maka langkah-langkah berikut dapat dijalankan, tetapi jika belum ada maka user dapat melakukan registrasi, sebagai ber  ikut:
1. Pertama, user memasukkan informasi pada *screen* `register.dart` berupa username dan password. 
2. Setelah user melakukan submit, Flutter akan melakukan validasi input sederhana seperti memeriksa input tidak kosong dan memeriksa field password dan konfirmasi password memiliki nilai yang sama. Jika tidak lolos pada tahap ini, Flutter akan menampilkan pesan error kepada user.
3. Setelah lolos validasi, Flutter akan melakukan request POST ke server Django kita, khususnya kepada endpoint yang sudah kita definisikan pada aplikasi Django kita.
4. Django kemudian akan melakukan parsing JSON terhadap request tersebut dan melakukan *server-side validation*, seperti memeriksa apakah username yang diinginkan sudah terdaftar dan lain sebagainya.
5. Jika tidak bisa dibuat user baru dengan kredensial yang diberikan, Django akan mengembalikan response 400 dan body JSON yang berisi pesan error. Flutter kemudian akan parsing response ini dan menampilkannya kepada user.
6. Jika berhasil dibuat user baru, Django akan mengirim response 200 dengan body JSON yang berisi pesan sukses, di mana aplikasi Flutter kita dapat menampilkan pesan tersebut kepada user.

Setelah melakukan registrasi, maka user dapat melakukan login sebagai berikut:
1. Sama seperti sebelumnya, user memasukkan informasi pada *screen* `login.dart` berupa username dan password.
2. Setelah user melakukan submit, Flutter akan melakukan validasi input sederhana seperti memeriksa input tidak kosong. Jika tidak lolos pada tahap ini, Flutter akan menampilkan pesan error kepada user.
3. Setelah lolos validasi, Flutter akan melakukan request POST ke server Django kita, khususnya kepada endpoint yang sudah kita definisikan pada aplikasi Django kita.
4. Django kemudian akan melakukan parsing JSON terhadap request tersebut dan melakukan *server-side validation*, yaitu memeriksa apakah kredensial yang diberikan sudah valid dan terdaftar di sistem.
5. Jika tidak valid, Django akan mengembalikan response 400 dan body JSON yang berisi pesan error. Flutter kemudian akan parsing response ini dan menampilkannya kepada user.
6. Jika berhasil login, Django akan mengirim response 200 dengan body JSON yang berisi pesan sukses bersama dengan *session cookie*. Dengan ini, aplikasi Flutter sudah terautentikasi dan dapat menampilkan program utama kepada pengguna.

Terakhir, mekanisme untuk melakukan logout adalah sebagai berikut:
1. Ketika user menekan tombol 'Logout', Flutter akan logout *session* sekarang dan mengirim juga *request* ke endpoint Django kita.
2. Django pun akan menghapus *session cookie* dari request kita, sehingga kita kembali ke state yang tidak terautentikasi.

### 6. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).
1. Pertama, saya membuat aplikasi baru pada proyek Django saya yaitu `authentication`. Pada aplikasi ini dibuat 3 *view*, yaitu `login`, `logout`, dan `register`. Selain itu, saya juga melakukan beberapa perubahan pada `settings.py` untuk memungkinkan request dan response ke aplikasi Flutter, seperti menambah *middleware* `corsheaders` dan mengubah variabel CORS.
2. Pada aplikasi Flutter, saya menambahkan *package* `provider` dan `pbp_django_auth`. *Package* `provider` membantu membagikan informasi antar widget, dan `pbp_django_auth` membantu melakukan autentikasi ke server Django. Package `provider` ditambah ke file `main.dart`, sedangkan `pbp_django_auth` digunakan pada setiap komponen yang perlu melakukan *request* ke server Django.
3. Untuk memungkinkan semua *widget* pada aplikasi saya untuk melakukan request ke server Django, saya membuat *instance* `Provider` baru untuk menyediakan `CookieRequest`, yaitu *request* yang memiliki *session cookie*. 
4. Saya membuat 2 file *screens* baru, yaitu `login.dart` dan `register.dart`. Pada kedua halaman tersebut ditambah form dengan validasi sederhana; kedua form kemudian akan mengirim data ke endpoint yang sudah dibuat sebelumnya di langkah 1 dan akan login request sekarang jika autentikasi berhasil.
5. Untuk menyiapkan aplikasi Flutter untuk bertukar data dengan server Django, saya membuat model baru dalam file `product.dart` yang berisi definisi model `Product`. Model ini akan berguna untuk melakukan *encoding* dan *decoding* data JSON dari server Django.
6. Saya membuat file baru dalam `/screens` yaitu `product_list.dart`. Pada halaman ini akan ditampilkan semua produk yang ada dengan melakukan *data fetching* dari server Django, khususnya pada endpoint yang dibuat sebelumnya. Filtering akan dilakukan dari sisi server lewat Django dan hanya menampilkan produk yang ditambah oleh user yang sedang login saat ini.
7. Kemudian, saya juga menghubungkan form *Add Product* yang sudah ditambahkan sebelumnya pada file `product_form.dart` dengan server Django. Selain dilakukan validasi sederhana, sekarang Flutter juga akan mengirim request POST ke server Django yang berisi data dari form tersebut sehingga dapat disimpan dalam database Django. Untuk ini, saya juga membuat *endpoint* dan *view* baru pada server Django saya untuk menerima data JSON dari Flutter.
8. Lalu, saya menghubungkan tombol *Logout* pada halaman utama ke server Django. Ketika ditekan, Flutter akan logout session sekarang dan kirim request ke endpoint `/logout` pada server Django sehingga Django akan menghapus *session* kita.
9. Saya menambahkan file baru dalam direktori `/screens` yaitu `product_details.dart`. *Screen* ini akan ditampilkan jika pengguna ingin melihat detail suatu produk lebih lanjut, dan berisi informasi produk lengkap seperti nama, deskripsi, harga, dan kuantitas. Halaman ini dihubungkan ke setiap elemen list pada *screen* `product_list.dart`.
10. Sebagai tambahan, saya juga menambahkan endpoint untuk menghapus produk pada proyek Django, dan menambahkannya ke *screen* `product_details.dart` yang ditambahkan sebelumnya untuk memungkinkan penghapusan produk dari dalam Flutter.

🕛 **Terakhir di-*update*:** 19 November 2024

## 📜 Log Riwayat README

<details>
<summary><b>Tugas 7 (6/11/2024)</b></summary>

## 7️⃣ Tugas 7
### 1. Jelaskan apa yang dimaksud dengan *stateless widget* dan *stateful widget*, dan jelaskan perbedaan dari keduanya.
- ***Stateless widget***<br>
*Stateless widget* adalah *widget* yang tidak memiliki *state*. Dengan kata lain, *widget* dalam kategori ini tidak dapat berubah selama penggunaan aplikasi. Ini membuat *stateless widget* cocok untuk konten statis yang tidak akan berubah. Contoh *widget* yang *stateless* adalah `Icon` dan `Text`.

- ***Stateful widget***<br>
Stateful widget adalah *widget* yang memiliki *state*. Berbeda dengan *stateless widget*, *widget* jenis ini dapat berubah secara dinamis selama penggunaan aplikasi, baik itu deskripsinya maupun *property* lain, lewat objek `State` yang dimilikinya. Contohnya adalah widget `Slider`, yang dapat berubah penampilannya ketika digeser oleh pengguna, `Radio`, `Form`, `TextField`, dan lain sebagainya. 

### 2. Sebutkan *widget* apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.
Beberapa *widget* yang saya buat pada proyek ini adalah:
1. `MyApp`: Merupakan *widget* dasar (`MaterialApp`) yang menampung semua *widget* lain pada aplikasi. 
2. `MyHomepage`: Merupakan *widget* yang akan menampilkan *view homepage*.
3. `InfoCard`: Merupakan *widget* yang menampilkan `Card` yang berisi informasi seperti NPM, nama, dan kelas.
4. `ItemCard`: Merupakan *widget* yang menampung `InkWell` yang jika ditekan akan menampilkan `SnackBar`. 

Selain itu, *widget* di atas menggunakan beberapa *widget* dari Flutter, yaitu:
1. `MaterialApp`: *Widget* yang menjadi basis dari sebuah Material app.
2. `Scaffold`: *Widget* yang mengimplementasikan struktur *layout* dasar dari Material Design.
3. `AppBar`: *Widget* yang berada pada posisi atas aplikasi dan memiliki *toolbar* yang dapat memuat *widget* lain. Pada aplikasi ini, `AppBar` hanya menampilkan judul aplikasi. 
4. `Text`: *Widget* yang menampilkan teks di layar.
5. `TextStyle`: *Widget* yang mengandung *property style* dari teks, seperti *font size*, *weight*, dan warna.
6. `Icons`: *Widget* yang menampilkan ikon *built-in* dari Flutter.
7. `Row`: *Widget* yang dapat menyusun *widget* lain secara horizontal dalam baris.
8. `Column`: *Widget* yang dapat menyusun *widget* lain secara vertikal dalam kolom.
9. `SizedBox`: *Widget* yang memiliki bentuk kotak dengan tinggi dan lebar tertentu.
10. `Padding`: *Widget* yang memberikan *padding* pada *widget* lain.
11. `EdgeInsets`: *Widget* yang dapat digabungkan dengan `Padding` untuk memberi jarak dalam *widget*. 
12. `GridView`: *Widget* yang dapat menyusun *widget* lain dalam bentuk *grid*.
13. `Center`: *Widget* yang dapat memposisikan *widget* lain di tengah.
14. `Card`: *Widget* yang berbentuk segiempat dan dapat berisi sekumpulan informasi dan *action*. 
15. `Container`: *Widget* yang dapat menampung *widget* lain dengan *padding*, *margin*, tinggi, dan lebar tertentu. `Container` juga dapat mendefinisikan *property* lain pada *child* seperti penampilan (*painting*).
16. `MediaQuery`: *Widget* yang dapat di-*query* untuk mendapatkan informasi tentang *media* di mana aplikasi kita sedang berjalan, misalnya ukuran layar *media*-nya.
17. `InkWell`: *Widget* yang *responsive* terhadap sentuhan layar dan menampilkan animasi "ink" yang memenuhi *widget ancestor*-nya ketika ditekan.
18. `ScaffoldMessenger`: *Widget* yang mengatur *widget* `SnackBar` lain.
19. `SnackBar`: *Widget* yang menampilkan pesan singkat di posisi bawah aplikasi.

### 3. Apa fungsi dari `setState()`? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.
Fungsi `setState()` berfungsi untuk memberi tahu Flutter bahwa sebuah *widget stateful* telah berubah *state*-nya sehingga perlu di-*render* ulang oleh Flutter. Fungsi `setState()` sendiri dapat mengubah variabel-variabel yang dimiliki oleh sebuah *widget* (misalnya variabel `counter` pada *demo* Flutter yang dapat di-*increment* ketika ditekan) atau variabel-variabel lainnya yang menjadi bagian dari objek `State` dan digunakan dalam method `build()`.

### 4. Jelaskan perbedaan antara `const` dengan `final`.
`const` dan `final` sama-sama digunakan untuk menandakan sebuah variabel yang tidak dapat diganti. Namun, `const` sendiri merupakan sebuah *compile-time constant*, yang berarti nilai pada sebuah variabel `const` **harus** diketahui saat kode ingin di-*compile*. Sementara itu, `final` digunakan untuk variabel yang nilainya hanya diketahui pada *runtime*, yang artinya nilainya diketahui ketika kodenya dijalankan. Salah satu contoh di mana `const` dapat digunakan adalah untuk mendefinisikan konstanta matematika seperti berikut:
```Dart
const pi = 3.14;        // Memiliki nilai jelas saat compile time
const tau = 2 * pi;     // Dapat dihitung saat compile-time karena menggunakan variabel const lain
```
Salah satu contoh di mana `const` **tidak** dapat digunakan adalah sebagai berikut:
```Dart
const date = DateTime.now();    // Ini akan memberikan error karena variabel date hanya dapat diketahui nilainya setelah DateTime.now() dijalankan

final date = DateTime.now();    // Pada kasus ini, keyword final harus digunakan karena final memperbolehkan nilai suatu variabel diinisialisasi pada saat runtime
```
Selain kedua contoh di atas, ada juga beberapa perbedaan lain antara `const` dan `final`. Misalnya, `const` tidak dapat digunakan untuk *instance variable*, sedangkan `final` bisa. Kemudian, objek yang diinisialisasi ke variabel `const` otomatis akan bersifat `const` juga, bersama dengan semua elemen dan *field* di dalamnya, sehingga objek tersebut bersifat sepenuhnya *immutable*. Sementara itu, objek yang diinisialisasi ke variabel `final` tidak otomatis bersifat `final`, sehingga walaupun variabel itu sendiri tidak bisa diubah, isi dari objek yang disimpan dapat berubah, seperti *field*-nya dan lain-lain. 

### 5. Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.
1. Pertama, saya membuat proyek Flutter baru dengan perintah `flutter create jokes_come_true`.
2. Kemudian, saya merapikan struktur proyek dengan memisahkan isi file `main.dart` menjadi file sendiri, yaitu `menu.dart`. Ini dilakukan untuk memisahkan *logic* untuk komponen aplikasi yang berbeda-beda agar lebih rapi dan mudah di-*maintain*.
3. Saya mengubah judul dari aplikasi di `main.dart` menjadi *Jokes Come True*.
4. Pada file `menu.dart`, saya menambah *widget stateless* baru yaitu `MyHomepage` untuk menyimpan *widget-widget* lain yang akan digunakan pada *view homepage*.
5. Saya menambah *widget* `InfoCard` untuk menyimpan informasi NPM, kelas, dan nama. *Widget* ini menggunakan widget `Card` dan `Text` dari Flutter.
6. Kemudian, saya menambah *widget* `ItemCard` yang akan menyimpan tombol-tombol yang dapat ditekan. *Widget* ini menggunakan *widget* `InkWell` dari Flutter dan ditambah ikon dan teks yang sesuai. Selain itu, ada *property* `onTap` yang akan menampilkan `SnackBar` yang berisi pesan ketika tombol ditekan. Untuk mengatur isi dari setiap `ItemCard`, dibuat *class* baru yaitu `ItemHomepage`. *Class* ini mengandung 3 *instance variable*: ikon, teks, dan warna. Nantinya, `ItemCard` akan menerima sebuah *instance* `ItemHomepage` agar isinya dapat disesuaikan dengan yang diinginkan. Saya membuat tiga tombol untuk melihat produk, menambah produk, dan logout dengan warna biru, hijau, dan merah berturut-turut.
7. Widget `ItemCard` dan `InfoCard` ditambahkan ke `MyHomepage` dan disusun menggunakan `Row`, `Column`, dan `GridView`. Posisi diatur menggunakan `Padding` dan *property-property* lain yang sesuai.
8. Saya membuat repositori baru di GitHub dan melakukan *add-commit-push*.

🕛 **Terakhir di-*update*:** 5 November 2024
</details>

<details>
<summary><b>Tugas 8 (13/11/2024)</b></summary>

## 8️⃣ Tugas 8
### 1. Apa kegunaan `const` di Flutter? Jelaskan apa keuntungan ketika menggunakan `const` pada kode Flutter. Kapan sebaiknya kita menggunakan `const`, dan kapan sebaiknya tidak digunakan?
Seperti yang pernah disebut sebelumnya, `const` dalam Flutter berguna untuk menetapkan sebuah *compile-time constant*, atau konstanta yang diketahui saat di-*compile*. Ini berguna ketika kita ingin memberitahu Flutter bahwa suatu variabel tidak akan berubah nilainya selama berjalannya program kita. Misalnya, pada `menu.dart`, digunakan *widget* `Text` untuk judul `AppBar` yang didefinisikan sebagai berikut:
```Dart
return Scaffold(
    appBar: AppBar(
    title: const Text(
        'Jokes Come True',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        ),
    ),
    ...
    ),
)
```
Pada contoh di atas, diberi modifier `const` pada `Text` sehingga *property* `title` pada `AppBar` akan selalu merupakan sebuah *widget* `Text`. Tidak hanya itu, `const` menjamin bahwa isi variabel tersebut (*property*-nya) tidak akan berubah juga selama berjalannya aplikasi. Ini berarti isi *widget* `Text` juga tidak akan berubah, baik itu teksnya, *style*-nya, *color*-nya, dan semua *property* lainnya. Keuntungan menggunakan `const` dalam Flutter adalah Flutter tidak perlu melakukan *render* atau *build* ulang terhadap *widget* tersebut karena pasti tidak berubah. Selain itu, `const` juga mencegah kita dan developer lain untuk mengubah tanpa sengaja *widget* atau variabel yang seharusnya tidak berubah. `const` sebaiknya digunakan untuk *widget-widget* dan variabel-variabel yang **tidak diharapkan untuk berubah nilai-nya, khususnya saat di-*compile***. Seperti contoh di atas, judul dari aplikasi saya seharusnya tetap *Jokes Come True* selama berjalannya aplikasi, sehingga diberi modifier `const`. Sebaliknya, `const` tidak dapat digunakan untuk variabel yang tidak diketahui nilainya saat di-*compile* (gunakan `final` untuk *run-time constant*) atau variabel yang akan berubah terus, seperti *counter* pada demo Flutter.

### 2. Jelaskan dan bandingkan penggunaan *Column* dan *Row* pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
*Widget* `Column` digunakan untuk menyusun *widget* lain secara vertikal, sedangkan `Row` digunakan untuk menyusun elemen secara horizontal. Masing-masing elemen memiliki `mainAxisAlignment` (yang mengatur penempatan sejajar dengan arah masing-masing) dan `crossAxisAlignment` (yang mengatur penempatan secara tegak lurus dengan arah masing-masing).

Untuk contoh implementasinya ada dalam `menu.dart`, yaitu:
```Dart
child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Row(                            // Elemen kolom ke-1
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            InfoCard(title: 'NPM', content: npm),           // Elemen row ke-1
            InfoCard(title: 'Name', content: name),         // Elemen row ke-2
            InfoCard(title: 'Class', content: className),   // Elemen row ke-3
            ],
        ),
        const SizedBox(height: 16.0),   // Elemen kolom ke-2
        Center(                         // Elemen kolom ke-3
            child: Column(
                ...     // Elemen-elemen lain dalam kolom
            )
        )
        ]
    )
```
Dapat dilihat bahwa kedua widget tersebut dapat digunakan secara bersamaan dan di-*nesting* untuk penataan *widget* yang lebih tepat dan akurat. Terdapat `Column` pada level paling luar untuk menyimpan semua *widget* lain, kemudian disusun 3 *widget* di dalamnya secara vertikal, yaitu `Row`, `SizedBox`, dan `Center`. `Row` pun menyusun *widget* lain secara horizontal di dalamnya, yaitu `InfoCard`. Kemudian, ada `SizedBox` sebagai elemen ke-2 dan terakhir ada `Center` yang akan menempatkan *child widget*-nya di tengah. Dan ternyata ia menyimpan sebuah *widget* `Column` lain! Jadi widget `Row` dan `Column` dapat digunakan bersamaan untuk menata *widget* dalam Flutter.

### 3. Sebutkan apa saja elemen input yang kamu gunakan pada halaman *form* yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!
Pada tugas ini, saya hanya menggunakan elemen input `TextArea` untuk menerima input teks. Namun, elemen input Flutter tidak hanya terbatas pada `TextArea`, tetapi ada banyak elemen input lain yang dapat digunakan antara lain: 
- `Radio`: Untuk menerima satu input saja dari beberapa pilihan tertentu.
- `Slider`: Untuk menerima input dalam batasan tertentu.
- `DatePicker`: Untuk menerima input tanggal.
- `TimePicker`: Untuk menerima input waktu.
- `Switch`: Untuk menyediakan beberapa parameter yang dapat "dinyalakan" atau "dimatikan".
- `Checkbox`: Mirip dengan `Switch`, menyediakan beberapa parameter yang dapat di-*toggle*.
- ...dan masih banyak lagi.

### 4. Bagaimana cara kamu mengatur tema (*theme*) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
Untuk mengatur tema dalam aplikasi Flutter, Flutter menyediakan class `ThemeData` yang dapat didefinisikan dalam *widget* `MaterialApp`. Flutter akan menyimpan dan menggunakan definisi tema yang kita tentukan di sini, seperti warna dan font, sebagai default ketika kita tidak mendefinisikan tema khusus untuk *widget* dalam aplikasi kita. Sebaiknya *default theme* yang kita definisikan menggunakan `ThemeData` ini digunakan jika tidak ada keperluan *styling* khusus agar tema visual aplikasi kita tetap terjaga dan konsisten. Pada aplikasi saya, saya mendefinisikan tema warna dari aplikasi saya sebagai warna biru dalam `main.dart`. 
```Dart
theme: ThemeData(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.lightBlue,
    ).copyWith(secondary: Colors.lightBlue[400]),
),
```
Ini pun digunakan dalam *widget-widget* lain dalam aplikasi saya seperti pada `AppBar` dan `Drawer` menggunakan baris berikut:
```Dart
color: Theme.of(context).colorScheme.primary
```
Dengan demikian, widget-widget pada aplikasi saya tetap konsisten dan mengikuti warna yang ditetapkan dalam `main.dart`, bahkan jika saya misalnya ingin mengubah temanya ke warna hijau di kemudian hari.

### 5. Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?
Untuk menangani navigasi dengan banyak halaman pada Flutter, kita dapat menggunakan *widget* yang menyimpan halaman-halaman tersebut, contohnya adalah `Drawer` yang digunakan dalam tugas ini. `Drawer` ini akan menyimpan halaman-halaman yang dapat dikunjungi, dan untuk menangani navigasi antar halaman sendiri, kita dapat menggunakan class `Navigator`. Ada beberapa method yang disediakan untuk navigasi, seperti `Navigator.push()` untuk *push route* baru ke atas *stack* (halaman yang ditampilkan dalam aplikasi otomatis merupakan *route* yang paling atas pada *stack*), `Navigator.pop()` untuk *pop* route teratas dan kembali ke route sebelumnya (jika ada), dan `Navigator.pushReplacement()`, yang akan *push* dan menggantikan *route* yang sekarang. `Navigator` juga menyediakan method lain seperti `Navigator.popUntil()`, `Navigator.pushNamed()`, dan `Navigator.pushNamedAndRemoveUntil()` yang dapat digunakan untuk meningkatkan UX dari aplikasi kita. 

🕛 **Terakhir di-*update*:** 12 November 2024
</details>