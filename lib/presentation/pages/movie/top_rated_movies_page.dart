import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TopRatedMoviesBloc>(context, listen: false)
            ..add(FetchTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Provider(
          create: (_) => BlocProvider<TopRatedMoviesBloc>(
            create: (_) => locator<TopRatedMoviesBloc>()..add(FetchTopRatedMovies()),
          ),
          child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
            builder: (_, state) {
              if (state is TopRatedMoviesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedMoviesLoaded) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    final movie = state.movies[index];
                    return MovieCard(movie);
                  },
                  itemCount: state.movies.length,
                );
              } else if (state is TopRatedMoviesError) {
                return Center(
                  key: Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        )
      ),
    );
  }
}
