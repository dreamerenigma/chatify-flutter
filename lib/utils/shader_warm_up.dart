import 'dart:ui' as ui;

void preloadShader() {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);
  const ui.Size size = ui.Size(200, 200);

  final ui.Paint paint = ui.Paint();
  paint.shader = ui.Gradient.linear(
    ui.Offset.zero,
    ui.Offset(size.width, size.height),
    [
      const ui.Color(0xFF000000),
      const ui.Color(0xFFFFFFFF),
    ],
  );
  canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, size.height), paint);

  recorder.endRecording();
}
