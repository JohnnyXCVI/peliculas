import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = ['Luca', 'Rapido y Furiuioso 9', 'Infinite'];

  final peliculasRecientes = ['Cruella', 'Disomnia', 'Luca'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultaods que vamos a mostrar
    return Center(
        child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.blueAccent,
            child: Text(seleccion)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPeliculas(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                }
              );
            }).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    //final listaBusqueda = (query.isEmpty)
    //    ? peliculasRecientes
    //    : peliculas
    //        .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
    //        .toList();
    //return ListView.builder(
    //  itemCount: listaBusqueda.length,
    //  itemBuilder: (context, i) {
    //    return ListTile(
    //      leading: Icon(Icons.movie),
    //      title: Text(listaBusqueda[i]),
    //      onTap: () {
    //        seleccion = listaBusqueda[i];
    //        showResults(context);
    //      },
    //    );
    //  },
    //);
  }
}
