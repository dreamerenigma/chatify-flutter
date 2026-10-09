import 'package:flutter/material.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../core/services/media/yandex/yandex_disk_api.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class ReplyImagePreviewWidget extends StatefulWidget {
  final String imagePath;
  final MessageType type;

  const ReplyImagePreviewWidget({
    super.key,
    required this.imagePath,
    required this.type,
  });

  @override
  State<ReplyImagePreviewWidget> createState() => _ReplyImagePreviewWidgetState();
}

class _ReplyImagePreviewWidgetState extends State<ReplyImagePreviewWidget> {
  final YandexDiskApi _yandexDiskApi = YandexDiskApi();
  String? _imageUrl;
  bool _isLoading = true;

  bool get _isGif => widget.type == MessageType.gif;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final url = await _yandexDiskApi.getDownloadUrl(widget.imagePath);

    if (!mounted) return;

    setState(() {
      _imageUrl = url;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      child: SizedBox(width: 56, height: 56, child: _buildImage()),
    );
  }

  Widget _buildImage() {
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

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(_imageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _buildPlaceholder());
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ChatifyColors.youngNight,
      alignment: Alignment.center,
      child: Icon(_isGif ? Icons.gif_box_outlined : Icons.image_outlined, size: 24, color: ChatifyColors.textSecondary),
    );
  }
}
