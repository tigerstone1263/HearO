import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

class InfiniteForestMap extends PositionComponent
    with HasGameRef<FlameGame> {
  InfiniteForestMap({
    this.configPath = 'assets/tiles/forest/forest.json',
    this.renderTileScale = 4.0,
    this.visiblePaddingChunks = 1,
  });

  final String configPath;
  final double renderTileScale;
  final int visiblePaddingChunks;

  late final _ForestTileConfig _config;
  final Map<int, ui.Image> _tileImages = {};
  final Map<Point<int>, _ForestChunk> _chunks = {};
  bool _isReady = false;
  double _tileWorldSize = 64;
  double _chunkWorldSize = 2048;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _config = await _ForestTileConfig.load(configPath);
    _tileWorldSize = _config.tileSize * renderTileScale;
    _chunkWorldSize = _tileWorldSize * _config.chunkTiles;
    for (final entry in _config.tileFiles.entries) {
      _tileImages[entry.key] = await _loadImage(entry.value);
    }
    priority = -50;
    _isReady = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isReady) {
      return;
    }
    _updateVisibleChunks();
  }

  void _updateVisibleChunks() {
    final view = gameRef.camera.visibleWorldRect;
    final minChunkX =
        (view.left / _chunkWorldSize).floor() - visiblePaddingChunks;
    final maxChunkX =
        (view.right / _chunkWorldSize).floor() + visiblePaddingChunks;
    final minChunkY =
        (view.top / _chunkWorldSize).floor() - visiblePaddingChunks;
    final maxChunkY =
        (view.bottom / _chunkWorldSize).floor() + visiblePaddingChunks;

    final needed = <Point<int>>{};
    for (var cy = minChunkY; cy <= maxChunkY; cy++) {
      for (var cx = minChunkX; cx <= maxChunkX; cx++) {
        final key = Point<int>(cx, cy);
        needed.add(key);
        if (_chunks.containsKey(key)) {
          continue;
        }
        final chunk = _ForestChunk(
          chunkX: cx,
          chunkY: cy,
          chunkTiles: _config.chunkTiles,
          tileWorldSize: _tileWorldSize,
          config: _config,
          tileImages: _tileImages,
        )..position = Vector2(cx * _chunkWorldSize, cy * _chunkWorldSize);
        add(chunk);
        _chunks[key] = chunk;
      }
    }

    final toRemove = <Point<int>>[];
    for (final entry in _chunks.entries) {
      if (!needed.contains(entry.key)) {
        entry.value.removeFromParent();
        toRemove.add(entry.key);
      }
    }
    for (final key in toRemove) {
      _chunks.remove(key);
    }
  }

  Future<ui.Image> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class _ForestChunk extends PositionComponent {
  _ForestChunk({
    required this.chunkX,
    required this.chunkY,
    required this.chunkTiles,
    required this.tileWorldSize,
    required this.config,
    required this.tileImages,
  });

  final int chunkX;
  final int chunkY;
  final int chunkTiles;
  final double tileWorldSize;
  final _ForestTileConfig config;
  final Map<int, ui.Image> tileImages;
  final ui.Paint _paint = ui.Paint()..filterQuality = ui.FilterQuality.none;
  late final List<int> _tiles;
  late final Map<int, ui.Rect> _sourceRects;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(chunkTiles * tileWorldSize, chunkTiles * tileWorldSize);
    _tiles = _generateTiles();
    _sourceRects = {
      for (final entry in tileImages.entries)
        entry.key: ui.Rect.fromLTWH(
          0,
          0,
          entry.value.width.toDouble(),
          entry.value.height.toDouble(),
        ),
    };
    priority = -40;
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    for (var y = 0; y < chunkTiles; y++) {
      for (var x = 0; x < chunkTiles; x++) {
        final id = _tiles[y * chunkTiles + x];
        final image = tileImages[id];
        final source = _sourceRects[id];
        if (image == null || source == null) {
          continue;
        }
        final dest = ui.Rect.fromLTWH(
          x * tileWorldSize,
          y * tileWorldSize,
          tileWorldSize,
          tileWorldSize,
        );
        canvas.drawImageRect(image, source, dest, _paint);
      }
    }
  }

  List<int> _generateTiles() {
    final rng = Random(_seed(chunkX, chunkY));
    final total = chunkTiles * chunkTiles;
    final base = List<int>.filled(total, 0);
    for (var i = 0; i < total; i++) {
      base[i] = _pickWeighted(
        rng,
        config.baseTileIds,
        config.baseWeights,
      );
    }
    final output = List<int>.from(base);
    for (var y = 0; y < chunkTiles; y++) {
      for (var x = 0; x < chunkTiles; x++) {
        for (final rule in config.rules) {
          if (!_hasNeighbor(base, x, y, rule.whenNearTileIds)) {
            continue;
          }
          if (rng.nextDouble() > rule.strength) {
            continue;
          }
          output[y * chunkTiles + x] =
              rule.biasTowardTileIds[rng.nextInt(rule.biasTowardTileIds.length)];
        }
      }
    }
    return output;
  }

  bool _hasNeighbor(List<int> tiles, int x, int y, List<int> ids) {
    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) {
          continue;
        }
        final nx = x + dx;
        final ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= chunkTiles || ny >= chunkTiles) {
          continue;
        }
        if (ids.contains(tiles[ny * chunkTiles + nx])) {
          return true;
        }
      }
    }
    return false;
  }

  int _pickWeighted(Random rng, List<int> ids, List<double> weights) {
    var totalWeight = 0.0;
    for (final w in weights) {
      totalWeight += w;
    }
    var roll = rng.nextDouble() * totalWeight;
    for (var i = 0; i < ids.length; i++) {
      roll -= weights[i];
      if (roll <= 0) {
        return ids[i];
      }
    }
    return ids.last;
  }

  int _seed(int x, int y) {
    var seed = 0x1F1F1F1F;
    seed ^= x * 73856093;
    seed ^= y * 19349663;
    return seed & 0x7fffffff;
  }
}

class _ForestTileConfig {
  _ForestTileConfig({
    required this.tileSize,
    required this.chunkTiles,
    required this.tileFiles,
    required this.baseTileIds,
    required this.baseWeights,
    required this.rules,
  });

  final int tileSize;
  final int chunkTiles;
  final Map<int, String> tileFiles;
  final List<int> baseTileIds;
  final List<double> baseWeights;
  final List<_ForestRule> rules;

  static Future<_ForestTileConfig> load(String path) async {
    final raw = await rootBundle.loadString(path);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final meta = data['meta'] as Map<String, dynamic>;
    final tileSize = meta['tileSize'] as int;
    final chunkTiles = meta['chunkTiles'] as int;
    final tileset = data['tileset'] as Map<String, dynamic>;
    final files = tileset['files'] as Map<String, dynamic>;
    final tileFiles = <int, String>{};
    for (final entry in files.entries) {
      tileFiles[int.parse(entry.key)] = entry.value as String;
    }
    final generation = data['generation'] as Map<String, dynamic>;
    final baseFill = generation['baseFill'] as Map<String, dynamic>;
    final baseTileIds =
        (baseFill['tileIds'] as List<dynamic>).map((e) => e as int).toList();
    final baseWeights = (baseFill['weights'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    final rules = <_ForestRule>[];
    if (generation['rules'] is List<dynamic>) {
      for (final ruleRaw in generation['rules'] as List<dynamic>) {
        final rule = ruleRaw as Map<String, dynamic>;
        rules.add(
          _ForestRule(
            whenNearTileIds: (rule['whenNearTileIds'] as List<dynamic>)
                .map((e) => e as int)
                .toList(),
            biasTowardTileIds: (rule['biasTowardTileIds'] as List<dynamic>)
                .map((e) => e as int)
                .toList(),
            strength: (rule['strength'] as num).toDouble(),
          ),
        );
      }
    }
    return _ForestTileConfig(
      tileSize: tileSize,
      chunkTiles: chunkTiles,
      tileFiles: tileFiles,
      baseTileIds: baseTileIds,
      baseWeights: baseWeights,
      rules: rules,
    );
  }
}

class _ForestRule {
  _ForestRule({
    required this.whenNearTileIds,
    required this.biasTowardTileIds,
    required this.strength,
  });

  final List<int> whenNearTileIds;
  final List<int> biasTowardTileIds;
  final double strength;
}
