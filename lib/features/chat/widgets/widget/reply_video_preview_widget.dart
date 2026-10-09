import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/services/media/yandex/yandex_disk_api.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class ReplyVideoPreviewWidget extends StatefulWidget {
  final String videoPath;

  const ReplyVideoPreviewWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<ReplyVideoPreviewWidget> createState() => _ReplyVideoPreviewWidgetState();
}

class _ReplyVideoPreviewWidgetState extends State<ReplyVideoPreviewWidget> {
  final YandexDiskApi _yandexDiskApi = YandexDiskApi();
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo() async {
    final url = await _yandexDiskApi.getDownloadUrl(widget.videoPath);

    if (!mounted) return;

    if (url == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _videoUrl = url;
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      await controller.dispose();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
      child: SizedBox(width: 56, height: 52, child: _buildVideo()),
    );
  }

  Widget _buildVideo() {
    if (_isLoading) {
      return Container(
        color: ChatifyColors.youngNight,
        alignment: Alignment.center,
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 1.5),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return _buildError();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(width: _controller!.value.size.width, height: _controller!.value.size.height, child: VideoPlayer(_controller!)),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      color: ChatifyColors.youngNight,
      alignment: Alignment.center,
      child: Icon(Icons.videocam_outlined, size: 24, color: ChatifyColors.textSecondary),
    );
  }
}
