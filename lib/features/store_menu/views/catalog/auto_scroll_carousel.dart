import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollCarousel extends StatefulWidget {
  const AutoScrollCarousel({super.key});

  @override
  State<AutoScrollCarousel> createState() => _AutoScrollCarouselState();
}

class _AutoScrollCarouselState extends State<AutoScrollCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  double progressBar = 0.0;
  final List<String> _images = [
    'assets/images/placeholder.png',
    'assets/images/placeholder.png',
    'assets/images/placeholder.png',
  ];
  double _progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    const duration = Duration(milliseconds: 50);
    const totalTime = 5000; // 5 seconds
    int tick = 0;
    _timer = Timer.periodic(duration, (timer) {
      tick++;

      setState(() {
        _progress = (tick * duration.inMilliseconds / totalTime).clamp(
          0.0,
          1.0,
        );
      });
      if (_progress >= 1.0) {
        tick = 0;
        if (_pageController.hasClients) {
          setState(() {
            _currentPage = (_currentPage + 1) % _images.length;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _pauseAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  void _goToPage(int newPage) {
    if (newPage < 0 || newPage >= _images.length) return;

    setState(() => _currentPage = newPage);

    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _startAutoScroll();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: _images.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _progress = 0.0;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        if (_currentPage == index)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: LinearProgressIndicator(
                              value: _progress,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              color: Colors.red,
                              minHeight: 4,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _goToPage(_currentPage - 1),
                        onLongPress: _pauseAutoScroll,
                        onLongPressUp: _startAutoScroll,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _goToPage(_currentPage + 1),
                        onLongPress: _pauseAutoScroll,
                        onLongPressUp: _startAutoScroll,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: _currentPage == index ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.orange
                    : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
