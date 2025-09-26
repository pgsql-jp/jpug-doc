␝<sect1 id="oldsnapshot" xreflabel="old_snapshot">␟ <title>old_snapshot &mdash; inspect <literal>old_snapshot_threshold</literal> state</title>␟ <title>old_snapshot &mdash; <literal>old_snapshot_threshold</literal>の状態を調査する</title>␞␞␞
␝ <para>␟  The <filename>old_snapshot</filename> module allows inspection
  of the server state that is used to implement
  <xref linkend="guc-old-snapshot-threshold" />.␟  <filename>old_snapshot</filename>モジュールは、<xref linkend="guc-old-snapshot-threshold" />を実装するために用いられているサーバの状態調査を可能にします。␞␞ </para>␞
␝ <sect2 id="oldsnapshot-functions">␟  <title>Functions</title>␟  <title>関数</title>␞␞␞
␝     <para>␟      Returns all of the entries in the server's timestamp to XID mapping.
      Each entry represents the newest xmin of any snapshot taken in the
      corresponding minute.␟サーバのタイムスタンプからXIDへのマッピングのすべてのエントリを返します。
個々のエントリは、対応する瞬間に取得されたすべてのスナップショットのうち最新のxminを表します。␞␞     </para>␞
