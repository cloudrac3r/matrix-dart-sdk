/*
 *   Famedly Matrix SDK
 *   Copyright (C) 2019, 2020, 2021 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:core';

import '../client.dart';

extension MxcUriExtension on Uri {
  /// Returns a download Link to this content.
  String getDownloadLink(Client matrix) => isScheme('mxc')
      ? matrix.homeserver != null
          ? '${matrix.homeserver.toString()}/_matrix/client/v1/media/download/$host$path'
          : ''
      : toString();

  /// Returns a scaled thumbnail link to this content with the given `width` and
  /// `height`. `method` can be `ThumbnailMethod.crop` or
  /// `ThumbnailMethod.scale` and defaults to `ThumbnailMethod.scale`.
  /// If `animated` (default false) is set to true, an animated thumbnail is requested
  /// as per MSC2705. Thumbnails only animate if the media repository supports that.
  String getThumbnail(Client matrix,
      {num width,
      num height,
      ThumbnailMethod method = ThumbnailMethod.crop,
      bool animated = false}) {
    if (!isScheme('mxc')) return toString();
    if (matrix.homeserver == null) {
      return '';
    }
    return Uri(
      scheme: matrix.homeserver.scheme,
      host: matrix.homeserver.host,
      path: '/_matrix/client/v1/media/thumbnail/$host$path',
      queryParameters: {
        if (width != null) 'width': width.round().toString(),
        if (height != null) 'height': height.round().toString(),
        if (method != null) 'method': method.toString().split('.').last,
        if (animated != null) 'animated': animated.toString(),
      },
    ).toString();
  }
}

enum ThumbnailMethod { crop, scale }
