import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';

enum _Type {
  folder,
  file
}

class FilesystemIconTheme extends StatelessWidget {
  const FilesystemIconTheme.folder(this.name, {
    Key? key,
    this.size
  }) : type = _Type.folder, super(key: key);

  const FilesystemIconTheme.file(this.name, {
    Key? key,
    this.size
  }) : type = _Type.file, super(key: key);

  final String name;
  final _Type type;
  final double? size;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _Type.folder:
        return Icon(
          const IconData(
            0xE02F,
            fontFamily: 'Seti',
            fontPackage: 'file_icon'
          ),
          size: size,
          color: const Color(0xff519aba),
        );
      case _Type.file:
        return FileIcon(name, size: size);
    }
  }}