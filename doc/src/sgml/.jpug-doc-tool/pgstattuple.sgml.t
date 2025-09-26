␝<sect1 id="pgstattuple" xreflabel="pgstattuple">␟ <title>pgstattuple &mdash; obtain tuple-level statistics</title>␟ <title>pgstattuple &mdash; タプルレベルの統計情報を入手する</title>␞␞␞
␝ <para>␟  The <filename>pgstattuple</filename> module provides various functions to
  obtain tuple-level statistics.␟<filename>pgstattuple</filename>モジュールはタプルレベルの統計情報を入手するための各種関数を提供します。␞␞ </para>␞
␝ <para>␟  Because these functions return detailed page-level information, access is
  restricted by default.  By default, only the
  role <literal>pg_stat_scan_tables</literal> has <literal>EXECUTE</literal>
  privilege.  Superusers of course bypass this restriction.  After the
  extension has been installed, users may issue <command>GRANT</command>
  commands to change the privileges on the functions to allow others to
  execute them.  However, it might be preferable to add those users to
  the <literal>pg_stat_scan_tables</literal> role instead.␟これらの関数は詳細なページレベルの情報を返しますので、デフォルトではアクセスが制限されています。
デフォルトでは<literal>pg_stat_scan_tables</literal>ロールだけが<literal>EXECUTE</literal>権限を持っています。
スーパーユーザは、当然、この制限を無視します。
拡張がインストールされた後、ユーザは<command>GRANT</command>コマンドを発行して他のユーザがそれらを実行できるよう関数に対する権限を変更できます。
しかしながら、その代わりに<literal>pg_stat_scan_tables</literal>ロールにそのユーザを追加する方が好ましいでしょう。␞␞ </para>␞
␝ <sect2 id="pgstattuple-funcs">␟  <title>Functions</title>␟  <title>関数</title>␞␞␞
␝     <para>␟      <function>pgstattuple</function> returns a relation's physical length,
      percentage of <quote>dead</quote> tuples, and other info. This may help users
      to determine whether vacuum is necessary or not.  The argument is the
      target relation's name (optionally schema-qualified) or OID.
      For example:␟<function>pgstattuple</function>はリレーションの物理的な長さ、<quote>無効</quote>なタプルの割合、およびその他の情報を返します。
これはバキュームが必要かどうかユーザが判断する時に有用かもしれません。
引数は対象とするリレーションの名前（スキーマ修飾可）もしくはOIDです。
以下に例を示します。␞␞<programlisting>␞
␝</programlisting>␟     The output columns are described in <xref linkend="pgstattuple-columns"/>.␟出力列を<xref linkend="pgstattuple-columns"/>で説明します。␞␞    </para>␞
␝    <table id="pgstattuple-columns">␟     <title><function>pgstattuple</function> Output Columns</title>␟     <title><function>pgstattuple</function>の出力列</title>␞␞     <tgroup cols="3">␞
␝       <row>␟        <entry>Column</entry>␟        <entry>列</entry>␞␞␞
␝        <entry>Column</entry>␟        <entry>Type</entry>␟        <entry>型</entry>␞␞␞
␝        <entry>Type</entry>␟        <entry>Description</entry>␟        <entry>説明</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Physical relation length in bytes</entry>␟        <entry>リレーションのバイト単位の物理長</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of live tuples</entry>␟        <entry>有効なタプル数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Total length of live tuples in bytes</entry>␟        <entry>有効なタプルの物理長（バイト単位）</entry>␞␞       </row>␞
␝        <entry><type>float8</type></entry>␟        <entry>Percentage of live tuples</entry>␟        <entry>有効タプルの割合</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of dead tuples</entry>␟        <entry>無効なタプル数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Total length of dead tuples in bytes</entry>␟        <entry>バイト単位の総無効タプル長</entry>␞␞       </row>␞
␝        <entry><type>float8</type></entry>␟        <entry>Percentage of dead tuples</entry>␟        <entry>無効タプルの割合</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Total free space in bytes</entry>␟        <entry>バイト単位の総空き領域</entry>␞␞       </row>␞
␝        <entry><type>float8</type></entry>␟        <entry>Percentage of free space</entry>␟        <entry>空き領域の割合</entry>␞␞       </row>␞
␝     <para>␟      The <literal>table_len</literal> will always be greater than the sum
      of the <literal>tuple_len</literal>, <literal>dead_tuple_len</literal>
      and <literal>free_space</literal>. The difference is accounted for by
      fixed page overhead, the per-page table of pointers to tuples, and
      padding to ensure that tuples are correctly aligned.␟<literal>table_len</literal>は、<literal>tuple_len</literal>、<literal>dead_tuple_len</literal>、<literal>free_space</literal>の合計よりも常に大きいです。
違いの原因は、固定ページのオーバーヘッド、ページ毎のタプルへのポインタのテーブル、タプルが正しく整列することを確実にするためのパディングです。␞␞     </para>␞
␝    <para>␟     <function>pgstattuple</function> acquires only a read lock on the
     relation. So the results do not reflect an instantaneous snapshot;
     concurrent updates will affect them.␟<function>pgstattuple</function> はリレーション上で読み取りロックのみを獲得します。
ですので、結果はこの瞬間のスナップショットを考慮しません。つまり、同時実行の更新がその結果に影響を与えます。␞␞    </para>␞
␝    <para>␟     <function>pgstattuple</function> judges a tuple is <quote>dead</quote> if
     <function>HeapTupleSatisfiesDirty</function> returns false.␟<function>pgstattuple</function>は、<function>HeapTupleSatisfiesDirty</function>が偽を返すかどうかで、タプルが<quote>無効</quote>かどうか判定します。␞␞    </para>␞
␝     <para>␟      This is the same as <function>pgstattuple(regclass)</function>, except
      that the target relation is specified as TEXT. This function is kept
      because of backward-compatibility so far, and will be deprecated in
      some future release.␟TEXTで対象リレーションを指定する点を除き、これは<function>pgstattuple(regclass)</function>と同じです。
この関数は今までのところ後方互換のために残されており、近い将来のリリースでは廃止予定になるでしょう。␞␞     </para>␞
␝     <para>␟      <function>pgstatindex</function> returns a record showing information
      about a B-tree index.  For example:␟<function>pgstatindex</function>はB-treeインデックスに関する情報を示すレコードを返します。
以下は例です。␞␞<programlisting>␞
␝    <para>␟     The output columns are:␟出力列は以下の通りです。␞␞␞
␝       <row>␟        <entry>Column</entry>␟        <entry>列</entry>␞␞␞
␝        <entry>Column</entry>␟        <entry>Type</entry>␟        <entry>型</entry>␞␞␞
␝        <entry>Type</entry>␟        <entry>Description</entry>␟        <entry>説明</entry>␞␞       </row>␞
␝        <entry><type>integer</type></entry>␟        <entry>B-tree version number</entry>␟        <entry>B-treeバージョン番号</entry>␞␞       </row>␞
␝        <entry><type>integer</type></entry>␟        <entry>Tree level of the root page</entry>␟        <entry>ルートページのツリーレベル</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Total index size in bytes</entry>␟        <entry>バイト単位のインデックスサイズ</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Location of root page (zero if none)</entry>␟        <entry>ルートページの場所（存在しない場合はゼロ）</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of <quote>internal</quote> (upper-level) pages</entry>␟        <entry><quote>内部</quote>（上位レベル）ページ数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of leaf pages</entry>␟        <entry>リーフページ数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of empty pages</entry>␟        <entry>空ページ数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of deleted pages</entry>␟        <entry>削除ページ数</entry>␞␞       </row>␞
␝        <entry><type>float8</type></entry>␟        <entry>Average density of leaf pages</entry>␟        <entry>リーフページの平均密度</entry>␞␞       </row>␞
␝        <entry><type>float8</type></entry>␟        <entry>Leaf page fragmentation</entry>␟        <entry>リーフページの断片化</entry>␞␞       </row>␞
␝    <para>␟     The reported <literal>index_size</literal> will normally correspond to one more
     page than is accounted for by <literal>internal_pages + leaf_pages +
     empty_pages + deleted_pages</literal>, because it also includes the
     index's metapage.␟報告される<literal>index_size</literal>は、通常、<literal>internal_pages + leaf_pages + empty_pages + deleted_pages</literal>が占めるより1多いページに相当するでしょう。
これは、index_sizeがインデックスメタページも含むためです。␞␞    </para>␞
␝    <para>␟     As with <function>pgstattuple</function>, the results are accumulated
     page-by-page, and should not be expected to represent an
     instantaneous snapshot of the whole index.␟<function>pgstattuple</function>同様、結果はページ毎に累積されます。
この瞬間のインデックス全体のスナップショットが存在すると想定してはいけません。␞␞    </para>␞
␝     <para>␟      This is the same as <function>pgstatindex(regclass)</function>, except
      that the target index is specified as TEXT. This function is kept
      because of backward-compatibility so far, and will be deprecated in
      some future release.␟TEXTで対象インデックスを指定する点を除き、これは<function>pgstatindex(regclass)</function>と同じです。
この関数は今までのところ後方互換のために残されており、近い将来のリリースでは廃止予定になるでしょう。␞␞     </para>␞
␝     <para>␟      <function>pgstatginindex</function> returns a record showing information
      about a GIN index.  For example:␟<function>pgstatginindex</function>は、GINインデックスに関する情報を示すレコードを返します。
以下に例を示します。␞␞<programlisting>␞
␝    <para>␟     The output columns are:␟出力列は以下の通りです。␞␞␞
␝       <row>␟        <entry>Column</entry>␟        <entry>列</entry>␞␞␞
␝        <entry>Column</entry>␟        <entry>Type</entry>␟        <entry>型</entry>␞␞␞
␝        <entry>Type</entry>␟        <entry>Description</entry>␟        <entry>説明</entry>␞␞       </row>␞
␝        <entry><type>integer</type></entry>␟        <entry>GIN version number</entry>␟        <entry>GINバージョン番号</entry>␞␞       </row>␞
␝        <entry><type>integer</type></entry>␟        <entry>Number of pages in the pending list</entry>␟        <entry>待機中リスト内のページ数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of tuples in the pending list</entry>␟        <entry>待機中リスト内のタプル数</entry>␞␞       </row>␞
␝     <para>␟      <function>pgstathashindex</function> returns a record showing information
      about a HASH index.  For example:␟<function>pgstathashindex</function>は、HASHインデックスに関する情報を示すレコードを返します。
以下に例を示します。␞␞<programlisting>␞
␝    <para>␟     The output columns are:␟出力列は以下の通りです。␞␞␞
␝       <row>␟        <entry>Column</entry>␟        <entry>列</entry>␞␞␞
␝        <entry>Column</entry>␟        <entry>Type</entry>␟        <entry>型</entry>␞␞␞
␝        <entry>Type</entry>␟        <entry>Description</entry>␟        <entry>説明</entry>␞␞       </row>␞
␝        <entry><type>integer</type></entry>␟        <entry>HASH version number</entry>␟        <entry>HASHバージョン番号</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of bucket pages</entry>␟        <entry>バケットページの数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of overflow pages</entry>␟        <entry>オーバーフローページの数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of bitmap pages</entry>␟        <entry>ビットマップページの数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of unused pages</entry>␟        <entry>使われていないページの数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of live tuples</entry>␟        <entry>有効なタプルの数</entry>␞␞       </row>␞
␝        <entry><type>bigint</type></entry>␟        <entry>Number of dead tuples</entry>␟        <entry>無効なタプルの数</entry>␞␞       </row>␞
␝        <entry><type>float</type></entry>␟        <entry>Percentage of free space</entry>␟        <entry>空き領域の割合</entry>␞␞       </row>␞
␝     <para>␟      <function>pg_relpages</function> returns the number of pages in the
      relation.␟<function>pg_relpages</function>はリレーション内のページ数を返します。␞␞     </para>␞
␝     <para>␟      This is the same as <function>pg_relpages(regclass)</function>, except
      that the target relation is specified as TEXT. This function is kept
      because of backward-compatibility so far, and will be deprecated in
      some future release.␟TEXTで対象リレーションを指定する点を除き、これは<function>pg_relpages(regclass)</function>と同じです。
この関数は今までのところ後方互換のために残されており、近い将来のリリースでは廃止予定になるでしょう。␞␞     </para>␞
␝     <para>␟      <function>pgstattuple_approx</function> is a faster alternative to
      <function>pgstattuple</function> that returns approximate results.
      The argument is the target relation's name or OID.
      For example:␟<function>pgstattuple_approx</function>は<function>pgstattuple</function>の代わりとなる高速なバージョンで、近似の結果を返します。
引数は対象のリレーションの名前またはOIDです。
以下に例を示します。␞␞<programlisting>␞
␝</programlisting>␟      The output columns are described in <xref linkend="pgstatapprox-columns"/>.␟出力列については<xref linkend="pgstatapprox-columns"/>で説明します。␞␞     </para>␞
␝     <para>␟      Whereas <function>pgstattuple</function> always performs a
      full-table scan and returns an exact count of live and dead tuples
      (and their sizes) and free space, <function>pgstattuple_approx</function>
      tries to avoid the full-table scan and returns exact dead tuple
      statistics along with an approximation of the number and
      size of live tuples and free space.␟<function>pgstattuple</function>が常に全件スキャンを実行し、有効タプルと無効タプルの正確な数（およびそのサイズ）と空き領域を返すのに対し、<function>pgstattuple_approx</function>は全件スキャンを避けようとし、無効タプルの正確な統計情報および有効タプルと空き領域の数とサイズの近似値を返します。␞␞     </para>␞
␝     <para>␟      It does this by skipping pages that have only visible tuples
      according to the visibility map (if a page has the corresponding VM
      bit set, then it is assumed to contain no dead tuples). For such
      pages, it derives the free space value from the free space map, and
      assumes that the rest of the space on the page is taken up by live
      tuples.␟可視性マップに従えば可視のタプルしかないページ（ページに対応するVMビットがセットされているなら、無効タプルが含まれていないとみなします）についてスキップすることで、これを実現します。
そのようなページについて空き領域の値を空き領域マップから導き、ページ上の残りのスペースは有効タプルによって占められているとみなします。␞␞     </para>␞
␝     <para>␟      For pages that cannot be skipped, it scans each tuple, recording its
      presence and size in the appropriate counters, and adding up the
      free space on the page. At the end, it estimates the total number of
      live tuples based on the number of pages and tuples scanned (in the
      same way that VACUUM estimates pg_class.reltuples).␟スキップできないページについては、各タプルをスキャンし、その存在とサイズを適切なカウンタに記録し、ページ上の空き領域を加算します。
最後に有効タプルの合計数をスキャンしたページとタプルの数に基づいて推定します（VACUUMがpg_class.reltuplesを推定するのと同じ方法です）。␞␞     </para>␞
␝     <table id="pgstatapprox-columns">␟      <title><function>pgstattuple_approx</function> Output Columns</title>␟      <title><function>pgstattuple_approx</function>の出力列 </title>␞␞      <tgroup cols="3">␞
␝        <row>␟         <entry>Column</entry>␟         <entry>列</entry>␞␞␞
␝         <entry>Column</entry>␟         <entry>Type</entry>␟         <entry>型</entry>␞␞␞
␝         <entry>Type</entry>␟         <entry>Description</entry>␟         <entry>説明</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Physical relation length in bytes (exact)</entry>␟         <entry>リレーションの物理的なバイト長（正確）</entry>␞␞        </row>␞
␝         <entry><type>float8</type></entry>␟         <entry>Percentage of table scanned</entry>␟         <entry>スキャンしたテーブルの割合</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Number of live tuples (estimated)</entry>␟         <entry>有効タプル数（推定）</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Total length of live tuples in bytes (estimated)</entry>␟         <entry>有効タプルの合計のバイト長（推定）</entry>␞␞        </row>␞
␝         <entry><type>float8</type></entry>␟         <entry>Percentage of live tuples</entry>␟         <entry>有効タプルの割合</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Number of dead tuples (exact)</entry>␟         <entry>無効タプル数（正確）</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Total length of dead tuples in bytes (exact)</entry>␟         <entry>無効タプルの合計のバイト長（正確）</entry>␞␞        </row>␞
␝         <entry><type>float8</type></entry>␟         <entry>Percentage of dead tuples</entry>␟         <entry>無効タプルの割合</entry>␞␞        </row>␞
␝         <entry><type>bigint</type></entry>␟         <entry>Total free space in bytes (estimated)</entry>␟         <entry>空き領域の合計バイト数（推定）</entry>␞␞        </row>␞
␝         <entry><type>float8</type></entry>␟         <entry>Percentage of free space</entry>␟         <entry>空き領域の割合</entry>␞␞        </row>␞
␝     <para>␟      In the above output, the free space figures may not match the
      <function>pgstattuple</function> output exactly, because the free
      space map gives us an exact figure, but is not guaranteed to be
      accurate to the byte.␟上記の出力で、空き領域の数字は<function>pgstattuple</function>の出力と正確には一致しないかもしれません。
これは空き領域マップは正確な数字を提供しますが、バイト単位で正確であることまでは保証されていないためです。␞␞     </para>␞
␝ <sect2 id="pgstattuple-authors">␟  <title>Authors</title>␟  <title>作者</title>␞␞␞
␝  <para>␟   Tatsuo Ishii, Satoshi Nagayasu and Abhijit Menon-Sen␟   Tatsuo Ishii、Satoshi Nagayasu、Abhijit Menon-Sen␞␞  </para>␞
␝␟<function>pgstattuple(regclass) returns record</function>␟no translation␞␞␞
␝␟<function>pgstatindex(regclass) returns record</function>␟no translation␞␞␞
␝␟<function>pgstatginindex(regclass) returns record</function>␟no translation␞␞␞
␝␟<function>pgstathashindex(regclass) returns record</function>␟no translation␞␞␞
␝␟<function>pg_relpages(regclass) returns bigint</function>␟no translation␞␞␞
␝␟<function>pgstattuple_approx(regclass) returns record</function>␟no translation␞␞␞
