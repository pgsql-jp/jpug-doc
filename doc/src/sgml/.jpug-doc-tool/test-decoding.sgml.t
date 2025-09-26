␝<sect1 id="test-decoding" xreflabel="test_decoding">␟ <title>test_decoding &mdash; SQL-based test/example module for WAL logical decoding</title>␟ <title>test_decoding &mdash; SQLに基づくWALロジカルデコーディングのためのテストモジュール/モジュール例</title>␞␞␞
␝ <para>␟  <filename>test_decoding</filename> is an example of a logical decoding
  output plugin. It doesn't do anything especially useful, but can serve as
  a starting point for developing your own output plugin.␟<filename>test_decoding</filename>はロジカルデコーディング出力プラグインの例です。
これは特に有用なことはまったく行いませんが、独自出力プラグイン開発の開始点として使えます。␞␞ </para>␞
␝ <para>␟  <filename>test_decoding</filename> receives WAL through the logical decoding
  mechanism and decodes it into text representations of the operations
  performed.␟<filename>test_decoding</filename>はロジカルデコーディング機構を通してWALを受け取り、実行された操作のテキスト表現にデコードします。␞␞ </para>␞
␝ <para>␟  Typical output from this plugin, used over the SQL logical decoding
  interface, might be:␟このプラグインがSQLロジカルデコーディングインタフェースで使われると、そこからの典型的な出力は以下のようになるでしょう。␞␞␞
␝<para>␟  We can also get the changes of the in-progress transaction, and the typical
  output might be:␟進行中のトランザクションの変化を知ることもでき、典型的な出力は以下のようになるでしょう。␞␞␞
