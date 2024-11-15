// import 'package:flutter/material.dart';
// import 'package:flutter_application_3/controllers/movie_controller.dart';
// import 'package:flutter_application_3/widgets/buttom_nav.dart';

// class MovieView extends StatelessWidget {
//   MovieView({super.key});
//   MovieController movies = MovieController();

//   get modal => null;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         title: Text(
// //           "Movie",
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //       body: ListView.builder(
// //         itemCount: movies.movie.length,
// //         itemBuilder: (context, index) {
// //           return Card(

// //             child: Row(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Image(
// //                     image: AssetImage(movies.movie[index].posterPath),
// //                     width: 100.0,
// //                   ),
// //                 ),
// //                 Column(
// //                   children: [
// //                     Text(movies.movie[index].title),
// //                     Row(
// //                       children: [
// //                         Text("ID :" + movies.movie[index].id.toString()),
// //                         SizedBox(
// //                           width: 20,
// //                         ),
// //                         Text("Vote :" +
// //                             movies.movie[index].voteAverage.toString())
// //                       ],
// //                     )
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   width: 200,
// //                 ),
// //                 Text(
// //                   movies.movie[index].reating,
// //                 )
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //       bottomNavigationBar: BottomNav(3),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_3/controllers/movie_controller.dart';
import 'package:flutter_application_3/controllers/perpus_controller.dart';
import 'package:flutter_application_3/models/movie.dart';
import 'package:flutter_application_3/models/perpus.dart';
import 'package:flutter_application_3/views/detail_perpus.dart';
import 'package:flutter_application_3/widgets/buttom_nav.dart';
import 'package:flutter_application_3/widgets/modal.dart';

class MovieView extends StatefulWidget {
  MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieController movie = MovieController();
  PerpusController perpus = PerpusController();
  TextEditingController titleInput = TextEditingController();
  TextEditingController gambarInput = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ModalWidget modal = ModalWidget();

  List<String> listAct = ["Ubah", "Hapus"];
  List? film;
  int? film_id;
  List<Perpus>? Buku;
  int? Buku_id;

  getBuku() {
    setState(() {
      Buku = perpus.perpus;
    });
  }

  addBuku(data) {
    Buku!.add(data);
    getBuku();
  }

  getFilm() {
    setState(() {
      film = movie.movie;
    });
  }

  addFilm(data) {
    setState(() {
      film!.add(data);
      getFilm();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFilm();
    getBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perpus"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  film_id = null;
                });
                titleInput.text = '';
                gambarInput.text = '';

                modal.showFullModal(context, fromTambah(null));
              },
              icon: Icon(Icons.add_sharp))
        ],
      ),
      body: film != null
          ? ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: film!.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  leading: Text(
                    film![index].reating,
                    style: TextStyle(fontSize: 20),
                  ),
                  titleAlignment: ListTileTitleAlignment.top,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PeprpusDetail(
                                  perpus: film![index],
                                  isi: Buku![index],
                                );
                              }));
                            },
                            child: Image(
                              image: AssetImage(film![index].posterPath),
                              width: 500,
                            ),
                          ),
                          Text(film![index].title,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Text(Buku![index].Id.toString()),
                      //     Text(Buku![index].Judul),
                      //     Text(Buku![index].Deskripsi),
                      //     Text(Buku![index].Stok.toString()),
                      //     Text(Buku![index].Karya),
                      //     Text(Buku![index].Penerbit),
                      //   ],
                      // )
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30.0,
                    ),
                    // onSelected: choiceAction,
                    itemBuilder: (BuildContext context) {
                      return listAct.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                          onTap: () {
                            if (choice == "Ubah") {
                              setState(() {
                                film_id = film![index].id;
                              });

                              titleInput.text = film![index].title;
                              gambarInput.text = film![index].posterPath;

                              modal.showFullModal(context, fromTambah(index));
                            } else if (choice == "Hapus") {
                              film!.removeWhere(
                                  (item) => item.id == film![index].id);
                              getFilm();
                            }
                          },
                        );
                      }).toList();
                    },
                  ),
                ));
              })
          : Text("Data Kosong"),
      bottomNavigationBar: BottomNav(3),
    );
  }

  Widget fromTambah(index) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text("Tambah Data"),
          TextFormField(
            controller: titleInput,
            decoration: InputDecoration(label: Text("Title")),
            validator: (value) {
              if (value!.isEmpty) {
                return 'harus diisi';
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: gambarInput,
            decoration: InputDecoration(label: Text("Gambar")),
            validator: (value) {
              if (value!.isEmpty) {
                return 'harus diisi';
              } else {
                return null;
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (index != null) {
                    film![index].id = film_id!;
                    film![index].title = titleInput.text;
                    film![index].posterPath = gambarInput.text;

                    getFilm();
                  } else {
                    film_id = film!.length + 1;

                    Movie data = Movie(
                      id: film_id!,
                      title: titleInput.text,
                      posterPath: gambarInput.text,
                      reating: '',
                    );
                    addFilm(data);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text("Simpan"))
        ],
      ),
    );
  }
}
