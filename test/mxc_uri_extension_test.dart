/*
 *   Famedly Matrix SDK
 *   Copyright (C) 2019, 2020 Famedly GmbH
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

import 'package:famedlysdk/famedlysdk.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';
import 'package:famedlysdk/src/client.dart';
import 'package:famedlysdk/src/utils/uri_extension.dart';

import 'fake_matrix_api.dart';

void main() {
  /// All Tests related to the MxContent
  group('MxContent', () {
    Logs().level = Level.error;
    test('Formatting', () async {
      var client = Client('testclient', httpClient: FakeMatrixApi());
      await client.checkHomeserver('https://fakeserver.notexisting',
          checkWellKnown: false);
      final mxc = 'mxc://exampleserver.abc/abcdefghijklmn';
      final content = Uri.parse(mxc);
      expect(content.isScheme('mxc'), true);

      expect(content.getDownloadLink(client),
          '${client.homeserver.toString()}/_matrix/media/r0/download/exampleserver.abc/abcdefghijklmn');
      expect(content.getThumbnail(client, width: 50, height: 50),
          '${client.homeserver.toString()}/_matrix/media/r0/thumbnail/exampleserver.abc/abcdefghijklmn?width=50&height=50&method=crop&animated=false');
      expect(
          content.getThumbnail(client,
              width: 50,
              height: 50,
              method: ThumbnailMethod.scale,
              animated: true),
          '${client.homeserver.toString()}/_matrix/media/r0/thumbnail/exampleserver.abc/abcdefghijklmn?width=50&height=50&method=scale&animated=true');
    });
  });
}
