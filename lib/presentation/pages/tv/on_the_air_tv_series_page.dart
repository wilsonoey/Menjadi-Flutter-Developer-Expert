import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tv-series';

  @override
  _OnTheAirTVSeriesPageState createState() => _OnTheAirTVSeriesPageState();
}

class _OnTheAirTVSeriesPageState extends State<OnTheAirTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<OnTheAirTvSeriesBloc>(context, listen: false)
            .add(FetchOnTheAirTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
          builder: (_, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tvSeries = state.tvSeries[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is OnTheAirTvSeriesError) {
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
    );
  }
}