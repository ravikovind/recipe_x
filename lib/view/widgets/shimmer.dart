import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.direction = const ShimmerDirection(),
    this.duration = const Duration(milliseconds: 800),
  });

  /// child is the widget to be displayed
  final Widget child;

  /// enabled is true when the shimmer effect is enabled
  final bool enabled;

  /// direction is the direction of the shimmer effect
  final ShimmerDirection direction;

  /// duration is the duration of the shimmer effect
  final Duration duration;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationOpacity;
  late Animation<double> _animationTranslation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animationOpacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animationTranslation = Tween<double>(
      begin: widget.direction.begin,
      end: widget.direction.end,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildShimmer() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animationOpacity.value,
          child: Transform.translate(
            offset: Offset(_animationTranslation.value, 0.0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled ? _buildShimmer() : widget.child;
  }
}

class ShimmerDirection extends Equatable {
  const ShimmerDirection({
    this.begin = -1.0,
    this.end = 1.0,
  });

  final double begin;
  final double end;

  @override
  List<Object> get props => [begin, end];
}
