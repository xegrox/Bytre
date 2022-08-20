import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class ImageCropperScreen extends StatelessWidget {

  ImageCropperScreen(this.imageData, {Key? key}) : super(key: key);

  final Uint8List imageData;
  final GlobalKey<CropState> _cropKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Crop(
              key: _cropKey,
              image: Image.memory(imageData).image,
              aspectRatio: 3/2,
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text('Crop Image', style: Theme.of(context).textTheme.bodyText1),
                  onPressed: () async {
                    final scale = _cropKey.currentState!.scale;
                    final area = _cropKey.currentState!.area;
                    if (area != null) {
                      final croppedData = await ImageCrop.cropImage(imageData: imageData, area: area, scale: scale);
                      if (croppedData != null) Navigator.of(context).pop(croppedData);
                    }
                  }
                ),
                TextButton(
                  child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1),
                  onPressed: () => Navigator.of(context).pop()
                )
              ]
            )
          )
        ]
      )
    );
  }

}