// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The path to local assets folder.
  static const localAssetsPrefix = 'assets/';

  static final controlAssets = [
    'assets/images/hint_on.png',
    'assets/images/hint_off.png',
    'assets/images/sound_on.png',
    'assets/images/sound_off.png',
  ];

  static final audioAssets = [
    'assets/audio/click.mp3',
    'assets/audio/slide.mp3',
    'assets/audio/countdown.mp3',
    'assets/audio/landing.mp3',
  ];

  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _platformHelper = widget._platformHelperFactory();

    _timer = Timer(const Duration(milliseconds: 20), () {
      for (var i = 1; i <= 8; i++) {
        precacheImage(
          Image.asset('assets/images/$i.png').image,
          context,
        );
      }

      precacheImage(
        Image.asset('assets/images/spaceship_small.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/spaceship_medium.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/spaceship_large.png').image,
        context,
      );

      precacheImage(
        Image.asset('assets/images/logo.png').image,
        context,
      );

      precacheImage(
        Image.asset('assets/images/moon.png').image,
        context,
      );

      for (final audioControlAsset in controlAssets) {
        precacheImage(
          Image.asset(audioControlAsset).image,
          context,
        );
      }

      for (final audioAsset in audioAssets) {
        prefetchToMemory(audioAsset);
      }
    });
  }

  /// Prefetches the given [filePath] to memory.
  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      // We rely on browser caching here. Once the browser downloads the file,
      // the native implementation should be able to access it from cache.
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
    throw UnimplementedError(
      'The function `prefetchToMemory` is not implemented '
      'for platforms other than Web.',
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astro Puzzle',
      home: PuzzlePage(),
    );
  }
}
