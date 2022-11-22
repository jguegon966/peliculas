import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/credits_response.dart';
import 'package:peliculas/models/popular_response.dart';

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '57b768579acb56e6c5ddb5836c5e31a6';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _displayPage = 1;

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    _displayPage++;
    final jsonData = await _getJsonData('3/movie/now_playing', _displayPage);
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = [...onDisplayMovies, ...nowPlayingResponse.results];
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    print('Pidiendo info al servidor - Cast');

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }
}
