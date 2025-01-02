import 'package:flutter/material.dart';
import 'package:lokuro/components/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,    
  });


  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {



  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

   void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // Update the shimmer painting.

      });
    }
  }   



  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }
    // Collect ancestor shimmer information.
    final shimmer = Shimmer.of(context);
    if (shimmer == null || !shimmer.isSized) {
      // The ancestor Shimmer widget isn't laid out yet.
      // Return an empty box.
      return const SizedBox();
    }

    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;

    final renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      // Return a fallback in case the render object is null or not a RenderBox.
      return const SizedBox();
    }

    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: renderObject,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
