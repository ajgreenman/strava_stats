import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AnimatedFab extends StatefulWidget {
  final Function(String) onClick;
  final IconData openIcon;
  Map<String, bool> activeIcons;

  AnimatedFab({Key key, this.onClick, this.openIcon, this.activeIcons}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final double expandedSize = 170.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = ColorTween(begin: Colors.deepOrange, end: Colors.deepOrange[900]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildExpandedBackground(),
              _buildOption(MdiIcons.run, 'Run', 14 / 9 * math.pi),
              _buildOption(MdiIcons.bike, 'Ride', 12 / 9 * math.pi),
              _buildOption(MdiIcons.swim, 'Swim', 10 / 9 * math.pi),
              _buildOption(MdiIcons.biathlon, 'Other', 8 / 9 * math.pi),
              _buildFabCore()
            ],
          );
        },
      ),
    );
  }

  Widget _buildExpandedBackground() {
    double size = hiddenSize + (expandedSize - hiddenSize) * _animationController.value;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepOrange),
    );
  }

  Widget _buildOption (IconData icon, String type, double angle) {
    double iconSize = 0.0;
    if(_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }

    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: IconButton(
            onPressed: () => _onIconClick(type),
            icon: Transform.rotate(
              angle: -angle,
              child: Icon(icon, color: widget.activeIcons[type] ? Colors.black : Colors.white),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();

    return FloatingActionButton(
      onPressed: _onFabTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(1.0, scaleFactor),
        child: Icon(_animationController.value > 0.5 ? Icons.close : widget.openIcon,
          color: Colors.white,
          size: 26
        )
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  _onIconClick(String type) {
    widget.onClick(type);
    close();
  }

  _onFabTap() {
    if(_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  open() {
    if(_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if(_animationController.isCompleted) {
      _animationController.reverse();
    }
  }
}