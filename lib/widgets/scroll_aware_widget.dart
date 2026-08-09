import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps a child with a [VisibilityDetector] so it can trigger entrance
/// animations when scrolled into view. The [builder] receives [visible].
class ScrollAwareWidget extends StatefulWidget {
  final String id;
  final Widget Function(BuildContext context, bool visible) builder;
  final double visibilityThreshold;

  const ScrollAwareWidget({
    super.key,
    required this.id,
    required this.builder,
    this.visibilityThreshold = 0.15,
  });

  @override
  State<ScrollAwareWidget> createState() => _ScrollAwareWidgetState();
}

class _ScrollAwareWidgetState extends State<ScrollAwareWidget> {
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: (info) {
        if (!_hasBeenVisible &&
            info.visibleFraction >= widget.visibilityThreshold) {
          setState(() => _hasBeenVisible = true);
        }
      },
      child: widget.builder(context, _hasBeenVisible),
    );
  }
}
