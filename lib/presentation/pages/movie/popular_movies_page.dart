import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<PopularMoviesBloc>(context, listen: false)
            ..add(FetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Provider(
        create: (_) => BlocProvider<PopularMoviesBloc>(
          create: (_) => locator<PopularMoviesBloc>()..add(FetchPopularMovies()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
            builder: (_, state) {
              if (state is PopularMoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularMoviesLoaded) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    final movie = state.movies[index];
                    return MovieCard(movie);
                  },
                  itemCount: state.movies.length,
                );
              } else if (state is PopularMoviesError) {
                return Center(
                  key: const Key('error_message'),
                  child: Text(state.message),
                );
              }
              else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      )
    );
  }
}
