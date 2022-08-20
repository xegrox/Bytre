import 'dart:typed_data';
import 'package:bytre/repositories/storage/storage_interface.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:tuple/tuple.dart';

part 'storage_native.g.dart';

const String _channelName = 'io.bytre/storage';
const MethodChannel _permChannel =  MethodChannel('$_channelName/permissions');
const MethodChannel _crudChannel = MethodChannel('$_channelName/crud');

@JsonSerializable()
class StorageRepositoryNative implements IStorageRepository {

  StorageRepositoryNative(this.uri) : super();

  factory StorageRepositoryNative.fromJson(Map<String, dynamic> json) => _$StorageRepositoryNativeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StorageRepositoryNativeToJson(this);

  final Uri uri;

  Uri _resolveUri(String path) => uri.replace(path: p.join(uri.path, path));
  String _resolvePath(Uri uri) => p.relative(uri.path, from: this.uri.path);

  FileInfo _parseFileInfo(Map<String, String> args) {
    return FileInfo(
      name: args['name']!,
      path: _resolvePath(Uri.parse(args['uri']!)),
      type: FileInfoType.values.byName(args['type']!)
    );
  }

  static Future<Tuple2<StorageRepositoryNative, String>> init() async {
    final args = (await _permChannel.invokeMapMethod<String, String>('request'))!;
    final name = args['name']!;
    final repository = StorageRepositoryNative(Uri.parse(args['uri']!));
    return Tuple2(repository, name);
  }

  @override
  String get defaultGroupName => 'Device';

  @override
  Future<void> open() async {}

  @override
  Future<void> close() async {}

  @override
  Future<FileInfo> createFile(String path, String name) async {
    final args = (await _crudChannel.invokeMapMethod<String, String>('createFile', { 'uri': _resolveUri(path).toString(), name: name }))!;
    return _parseFileInfo(args);
  }

  @override
  Future<FileInfo> createDirectory(String path, String name) async {
    final args = (await _crudChannel.invokeMapMethod<String, String>('createDirectory', { 'uri': _resolveUri(path).toString(), name: name }))!;
    return _parseFileInfo(args);
  }

  @override
  Future<Uint8List> readFile(String path) async {
    return (await _crudChannel.invokeMethod<Uint8List>('readFile', { 'uri': _resolveUri(path).toString() }))!;
  }

  @override
  Future<void> writeFile(String path, Uint8List data) async {
    await _crudChannel.invokeMethod<void>('writeFile', { 'uri': _resolveUri(path).toString(), 'data': data });
  }

  @override
  Future<bool> deleteRecursively(String path) async {
    return (await _crudChannel.invokeMethod<bool>('deleteRecursively', { 'uri': _resolveUri(path).toString() }))!;
  }

  @override
  Future<Iterable<FileInfo>> listDirectory(String path) async {
    final children = (await _crudChannel.invokeListMethod<Map<dynamic, dynamic>>('listDirectory', { 'uri': _resolveUri(path).toString()}))!;
    return children.map((args) => _parseFileInfo(args.cast<String, String>()));
  }

  @override
  String getDisplayPath(String path) {
    // For Android
    final fullPath = Uri.decodeComponent(_resolveUri(path).pathSegments.last);
    final rootPath = Uri.decodeComponent(uri.pathSegments.last);
    return p.normalize(p.join('/', p.relative(fullPath, from: rootPath)));
  }
}