import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class BotImageViewerScreen extends StatefulWidget {
  final String imageAsset;
  final String title;

  const BotImageViewerScreen({
    super.key,
    required this.imageAsset,
    required this.title,
  });

  @override
  State<BotImageViewerScreen> createState() => _BotImageViewerScreenState();
}

class _BotImageViewerScreenState extends State<BotImageViewerScreen> {
  final GlobalKey _viewerKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleZoom(TapDownDetails details) {
    final RenderBox box =
    _viewerKey.currentContext!.findRenderObject() as RenderBox;

    final Offset tapPosition = box.globalToLocal(details.globalPosition);
    final double scale = _isZoomed ? 1.0 : 2.0;
    final Matrix4 matrix = Matrix4.identity()
      ..translateByDouble(tapPosition.dx * (1 - scale), tapPosition.dy * (1 - scale), 0.0, 1.0)
      ..scaleByDouble(scale, scale, scale, 1.0);

    _transformationController.value = matrix;

    setState(() {
      _isZoomed = !_isZoomed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
        backgroundColor: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: InteractiveViewer(
        key: _viewerKey,
        transformationController: _transformationController,
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1,
        maxScale: 4,
        child: GestureDetector(
          onTapDown: _toggleZoom,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                alignment: Alignment.center,
                child: SvgPicture.asset(ChatifyVectors.appLogoLight, width: 250, height: 250, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
