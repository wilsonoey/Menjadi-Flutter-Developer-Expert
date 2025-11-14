import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  _TopRatedTVSeriesPageState createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      BlocProvider.of<TopRatedTvSeriesBloc>(context, listen: false)
        ..add(FetchTopRatedTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Provider(
        create: (_) => BlocProvider<TopRatedTvSeriesBloc>(
          create: (_) => locator<TopRatedTvSeriesBloc>()
            ..add(FetchTopRatedTvSeries()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
            builder: (_, state) {
              if (state is TopRatedTvSeriesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedTvSeriesLoaded) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    final tvSeries = state.tvSeries[index];
                    return TVSeriesCard(tvSeries);
                  },
                  itemCount: state.tvSeries.length,
                );
              } else if (state is TopRatedTvSeriesError) {
                return Center(
                  key: Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}