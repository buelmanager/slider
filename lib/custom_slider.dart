import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slider/slider_thumb_image.dart';
import 'dart:ui' as ui;

class CustomSlider extends StatefulWidget {
  final String thumUrl;
  final String activeUrl;
  final double width;
  final double height;
  final Color backColor;

  const CustomSlider({
    Key? key,
    required this.thumUrl,
    required this.width,
    required this.height,
    required this.backColor,
    required this.activeUrl,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _value = 0;
  ui.Image? customImage = null;

  Future<ui.Image> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();

    return fi.image;
  }

  @override
  void initState() {
    loadImage(widget.thumUrl).then((image) {
      setState(() {
        customImage = image;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildCustomSlider(context);
  }

  Container buildCustomSlider(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.activeUrl,
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          customImage != null
              ? SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 20.0,
                    trackShape: const RoundedRectSliderTrackShape(),
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: widget.backColor,
                    thumbShape: SliderThumbImage(
                        image: customImage!, width: 100, height: 100),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 0.0),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: 100.0,
                    value: _value,
                    label: '${_value.round()}',
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
