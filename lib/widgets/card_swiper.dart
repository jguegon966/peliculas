import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas/models/movie.dart';

class CardSwiper extends StatefulWidget {
  const CardSwiper({super.key, required this.movies});

  final List<Movie> movies;

  @override
  State<CardSwiper> createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  final SwiperController swiperController = SwiperController();

  @override
  void initState() {
    super.initState();

    swiperController.addListener(() {
      //if (swiperController.index >= swiperController.index - 3) {
      print('hola');
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (widget.movies.isEmpty) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      //color: Colors.red,
      child: Swiper(
        controller: swiperController,
        itemCount: widget.movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.55,
        itemHeight: size.height * 0.45,
        itemBuilder: (_, int index) {
          final movie = widget.movies[index];

          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(movie.fullPosterImg),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
