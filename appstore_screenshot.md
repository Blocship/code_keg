```dart
import 'dart:io';
import 'package:image/image.dart';

enum IPhone {
  pro(2688),
  se(2208),
  ;

  final int height;
  const IPhone(this.height);
}

Future<void> splitImage({
  required String input,
  required String output,
  required int splits,
  required IPhone iPhone,
}) async {
  final inputImagePath = input;

  final image = decodeImage(File(inputImagePath).readAsBytesSync())!;
  print(
    'Image Size (width x height): ${image.width} x ${image.height}',
  );
  final width = image.width;
  final height = iPhone.height;
  for (var i = 0; i < splits; i++) {
    final splitWidth = width ~/ splits;
    final splitImage = copyCrop(
      image,
      x: splitWidth * i,
      y: 0,
      width: splitWidth,
      height: height,
    );
    print(
      'Split Image Size (width x height): ${splitImage.width} x ${splitImage.height}',
    );
    final outputImagePath = '$output/split_$i.png';
    File(outputImagePath).writeAsBytesSync(encodePng(splitImage));
  }
}

Future<void> split3_5({
  required String input,
  required String output,
}) async {
  final inputImagePath = input;

  final image = decodeImage(File(inputImagePath).readAsBytesSync())!;
  print(
    'Image Size (width x height): ${image.width} x ${image.height}',
  );
  final width = (image.width ~/ 5) * 3;
  final height = image.height;

  final splitImage = copyCrop(
    image,
    x: 0,
    y: 0,
    width: width,
    height: height,
  );
  print(
    'Split Image Size (width x height): ${splitImage.width} x ${splitImage.height}',
  );
  final outputImagePath = '$output/split_3_5.png';
  File(outputImagePath).writeAsBytesSync(encodePng(splitImage));
}

void main(List<String> arguments) {
  // splitImage(
  //   input: './lib/Pro.png',
  //   output: './lib/output',
  //   splits: 5,
  //   iPhone: IPhone.se,
  // );
  split3_5(
    input: './lib/Pro.png',
    output: './lib/output',
  );
}

```