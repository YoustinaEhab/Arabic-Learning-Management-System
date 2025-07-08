import 'package:flutter/material.dart';

class CardPlanetData {
  final String title;
  final String subtitle;
  final Widget image;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? background;

  const CardPlanetData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.background,
  });
}

class CardPlanet extends StatelessWidget {
  const CardPlanet({
    required this.data,
    Key? key,
  }) : super(key: key);

  final CardPlanetData data;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: [
        if (data.background != null) data.background!,
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.05,
            horizontal: screenSize.width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: isPortrait ? 3 : 1),
              Flexible(
                flex: isPortrait ? 20 : 10,
                child: data.image,
              ),
              Spacer(flex: 1),
              Text(
                data.title.toUpperCase(),
                style: TextStyle(
                  color: data.titleColor,
                  fontSize: isPortrait 
                      ? screenSize.height * 0.03
                      : screenSize.width * 0.03,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                maxLines: 1,
              ),
              Spacer(flex: 1),
              Text(
                data.subtitle,
                style: TextStyle(
                  color: data.subtitleColor,
                  fontSize: isPortrait 
                      ? screenSize.height * 0.025
                      : screenSize.width * 0.025,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              Spacer(flex: isPortrait ? 10 : 5),
            ],
          ),
        ),
      ],
    );
  }
}