␝<sect1 id="pgbuffercache" xreflabel="pg_buffercache">␟ <title>pg_buffercache &mdash; inspect <productname>PostgreSQL</productname>
    buffer cache state</title>␟ <title>pg_buffercache &mdash; <productname>PostgreSQL</productname>のバッファキャッシュの状態を確認する</title>␞␞␞
␝ <para>␟  The <filename>pg_buffercache</filename> module provides a means for
  examining what's happening in the shared buffer cache in real time.
  It also offers a low-level way to evict data from it, for testing
  purposes.␟<filename>pg_buffercache</filename>モジュールは、共有バッファキャッシュで何が起きているかをリアルタイムに確認する方法を提供します。
また、テスト目的で、低レベルでデータを取り出す方法も提供します。␞␞ </para>␞
␝ <para>␟  This module provides the <function>pg_buffercache_pages()</function>
  function (wrapped in the <structname>pg_buffercache</structname> view),
  the <function>pg_buffercache_summary()</function> function, the
  <function>pg_buffercache_usage_counts()</function> function and
  the <function>pg_buffercache_evict()</function> function.␟このモジュールは、<function>pg_buffercache_pages()</function>関数（<structname>pg_buffercache</structname>ビューでラップされています）、<function>pg_buffercache_summary()</function>関数、<function>pg_buffercache_usage_counts()</function>関数、および<function>pg_buffercache_evict()</function>関数を提供します。␞␞ </para>␞
␝ <para>␟  The <function>pg_buffercache_pages()</function> function returns a set of
  records, each row describing the state of one shared buffer entry. The
  <structname>pg_buffercache</structname> view wraps the function for
  convenient use.␟<function>pg_buffercache_pages()</function>関数は、各行が1つの共有バッファエントリの状態を記述するレコード集合を返します。
<structname>pg_buffercache</structname>ビューは、簡単に利用できるようにこの関数をラップしています。␞␞ </para>␞
␝ <para>␟  The <function>pg_buffercache_summary()</function> function returns a single
  row summarizing the state of the shared buffer cache.␟<function>pg_buffercache_summary()</function>関数は、共有バッファキャッシュの状態を要約した1行を返します。␞␞ </para>␞
␝ <para>␟  The <function>pg_buffercache_usage_counts()</function> function returns a set
  of records, each row describing the number of buffers with a given usage
  count.␟<function>pg_buffercache_usage_counts()</function>関数は、各行が対応する使用カウントを持つバッファの数を記述するレコード集合を返します。␞␞ </para>␞
␝ <para>␟  By default, use of the above functions is restricted to superusers and roles
  with privileges of the <literal>pg_monitor</literal> role. Access may be
  granted to others using <command>GRANT</command>.␟デフォルトでは、上記関数の使用はスーパーユーザと<literal>pg_monitor</literal>ロールの権限を持つロールに限定されています。
他のユーザに対しては<command>GRANT</command>を使用してアクセス権を付与できます。␞␞ </para>␞
␝ <para>␟  The <function>pg_buffercache_evict()</function> function allows a block to
  be evicted from the buffer pool given a buffer identifier.  Use of this
  function is restricted to superusers only.␟<function>pg_buffercache_evict()</function>関数は、バッファ識別子を指定して、ブロックをバッファプールから退避させることができます。
この関数の使用はスーパーユーザのみに制限されています。␞␞ </para>␞
␝ <sect2 id="pgbuffercache-pg-buffercache">␟  <title>The <structname>pg_buffercache</structname> View</title>␟  <title><structname>pg_buffercache</structname>ビュー</title>␞␞␞
␝  <para>␟   The definitions of the columns exposed by the view are shown in <xref linkend="pgbuffercache-columns"/>.␟ビューによって公開されている列の定義を<xref linkend="pgbuffercache-columns"/>に示します。␞␞  </para>␞
␝  <table id="pgbuffercache-columns">␟   <title><structname>pg_buffercache</structname> Columns</title>␟   <title><structname>pg_buffercache</structname>の列</title>␞␞   <tgroup cols="1">␞
␝      <entry role="catalog_table_entry"><para role="column_definition">␟       Column Type␟列 型␞␞      </para>␞
␝      <para>␟       Description␟説明␞␞      </para></entry>␞
␝      <para>␟       ID, in the range 1..<varname>shared_buffers</varname>␟1から<varname>shared_buffers</varname>までの範囲で示されるID␞␞      </para></entry>␞
␝       <structfield>relfilenode</structfield> <type>oid</type>␟       (references <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>relfilenode</structfield>)␟（参照先 <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>relfilenode</structfield>）␞␞      </para>␞
␝      <para>␟       Filenode number of the relation␟リレーションのファイルノード番号␞␞      </para></entry>␞
␝       <structfield>reltablespace</structfield> <type>oid</type>␟       (references <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>oid</structfield>）␞␞      </para>␞
␝      <para>␟       Tablespace OID of the relation␟リレーションのテーブル空間OID␞␞      </para></entry>␞
␝       <structfield>reldatabase</structfield> <type>oid</type>␟       (references <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>oid</structfield>）␞␞      </para>␞
␝      <para>␟       Database OID of the relation␟リレーションのデータベースOID␞␞      </para></entry>␞
␝      <para>␟       Fork number within the relation;  see
       <filename>common/relpath.h</filename>␟リレーション内のフォーク番号。<filename>common/relpath.h</filename>参照␞␞      </para></entry>␞
␝      <para>␟       Page number within the relation␟リレーション内のページ番号␞␞      </para></entry>␞
␝      <para>␟       Is the page dirty?␟ダーティページかどうか␞␞      </para></entry>␞
␝      <para>␟       Clock-sweep access count␟Clock-sweepアクセスカウント␞␞      </para></entry>␞
␝      <para>␟       Number of backends pinning this buffer␟このバッファをピン留めしているバックエンドの数␞␞      </para></entry>␞
␝  <para>␟   There is one row for each buffer in the shared cache. Unused buffers are
   shown with all fields null except <structfield>bufferid</structfield>.  Shared system
   catalogs are shown as belonging to database zero.␟共有キャッシュ内の各バッファに対して、1行が存在します。
未使用のバッファは、<structfield>bufferid</structfield>を除き、すべてのフィールドがNULLになります。
共有システムカタログは、OIDがゼロのデータベースに属するものとして表示されます。␞␞  </para>␞
␝  <para>␟   Because the cache is shared by all the databases, there will normally be
   pages from relations not belonging to the current database.  This means
   that there may not be matching join rows in <structname>pg_class</structname> for
   some rows, or that there could even be incorrect joins.  If you are
   trying to join against <structname>pg_class</structname>, it's a good idea to
   restrict the join to rows having <structfield>reldatabase</structfield> equal to
   the current database's OID or zero.␟キャッシュはすべてのデータベースで共有されているため、現在のデータベースに属さないリレーションのページも表示されます。
これは、一部の行に対して一致する<structname>pg_class</structname>の結合行が存在しない、間違った結合をしてしまう可能性すらあることを意味します。
<structname>pg_class</structname>に対して結合しようとする場合、現在のデータベースのOIDまたは0と等しい<structfield>reldatabase</structfield>を持つ行に限定して結合することをお勧めします。␞␞  </para>␞
␝  <para>␟   Since buffer manager locks are not taken to copy the buffer state data that
   the view will display, accessing <structname>pg_buffercache</structname> view
   has less impact on normal buffer activity but it doesn't provide a consistent
   set of results across all buffers.  However, we ensure that the information of
   each buffer is self-consistent.␟ビューが表示するバッファ状態データのコピーのために、バッファマネージャのロックを取得しません。このため、<structname>pg_buffercache</structname>ビューへのアクセスは、通常のバッファ処理への影響がより小さくなりますが、バッファすべてに渡る矛盾のない結果を提供しません。
しかしながら、各バッファの情報に自己矛盾がないことは保証されます。␞␞  </para>␞
␝ <sect2 id="pgbuffercache-summary">␟  <title>The <function>pg_buffercache_summary()</function> Function</title>␟  <title><function>pg_buffercache_summary()</function>関数</title>␞␞␞
␝  <para>␟   The definitions of the columns exposed by the function are shown in <xref linkend="pgbuffercache-summary-columns"/>.␟関数によって公開されている列の定義を<xref linkend="pgbuffercache-summary-columns"/>に示します。␞␞  </para>␞
␝  <table id="pgbuffercache-summary-columns">␟   <title><function>pg_buffercache_summary()</function> Output Columns</title>␟   <title><function>pg_buffercache_summary()</function>出力列</title>␞␞   <tgroup cols="1">␞
␝      <entry role="catalog_table_entry"><para role="column_definition">␟       Column Type␟列 型␞␞      </para>␞
␝      <para>␟       Description␟説明␞␞      </para></entry>␞
␝      <para>␟       Number of used shared buffers␟使用中の共有バッファの数␞␞      </para></entry>␞
␝      <para>␟       Number of unused shared buffers␟未使用の共有バッファの数␞␞      </para></entry>␞
␝      <para>␟       Number of dirty shared buffers␟ダーティ共有バッファの数␞␞      </para></entry>␞
␝      <para>␟       Number of pinned shared buffers␟固定された共有バッファの数␞␞      </para></entry>␞
␝      <para>␟       Average usage count of used shared buffers␟使用中の共有バッファの平均使用カウント␞␞      </para></entry>␞
␝  <para>␟   The <function>pg_buffercache_summary()</function> function returns a
   single row summarizing the state of all shared buffers. Similar and more
   detailed information is provided by the
   <structname>pg_buffercache</structname> view, but
   <function>pg_buffercache_summary()</function> is significantly cheaper.␟<function>pg_buffercache_summary()</function>関数は、すべての共有バッファの状態を要約した単一の行を返します。
同様の、より詳細な情報は<structname>pg_buffercache</structname>ビューによって提供されますが、<function>pg_buffercache_summary()</function>はかなり安価です。␞␞  </para>␞
␝  <para>␟   Like the <structname>pg_buffercache</structname> view,
   <function>pg_buffercache_summary()</function> does not acquire buffer
   manager locks. Therefore concurrent activity can lead to minor inaccuracies
   in the result.␟<structname>pg_buffercache</structname>ビューと同様に、<function>pg_buffercache_summary()</function>はバッファマネージャのロックを取得しません。
そのため、同時実行中の処理によって結果に小さな不正確さが生じる可能性があります。␞␞  </para>␞
␝ <sect2 id="pgbuffercache-usage-counts">␟  <title>The <function>pg_buffercache_usage_counts()</function> Function</title>␟  <title><function>pg_buffercache_usage_counts()</function>関数</title>␞␞␞
␝  <para>␟   The definitions of the columns exposed by the function are shown in
   <xref linkend="pgbuffercache_usage_counts-columns"/>.␟関数によって公開されている列の定義を<xref linkend="pgbuffercache_usage_counts-columns"/>に示します。␞␞  </para>␞
␝  <table id="pgbuffercache_usage_counts-columns">␟   <title><function>pg_buffercache_usage_counts()</function> Output Columns</title>␟   <title><function>pg_buffercache_usage_counts()</function>出力列</title>␞␞   <tgroup cols="1">␞
␝      <entry role="catalog_table_entry"><para role="column_definition">␟       Column Type␟列 型␞␞      </para>␞
␝      <para>␟       Description␟説明␞␞      </para></entry>␞
␝      <para>␟       A possible buffer usage count␟推定バッファ使用カウント␞␞      </para></entry>␞
␝      <para>␟       Number of buffers with the usage count␟その使用カウントのバッファの数␞␞      </para></entry>␞
␝      <para>␟       Number of dirty buffers with the usage count␟その使用カウントのダーティバッファの数␞␞      </para></entry>␞
␝      <para>␟       Number of pinned buffers with the usage count␟その使用カウントの固定されたバッファの数␞␞      </para></entry>␞
␝  <para>␟   The <function>pg_buffercache_usage_counts()</function> function returns a
   set of rows summarizing the states of all shared buffers, aggregated over
   the possible usage count values.  Similar and more detailed information is
   provided by the <structname>pg_buffercache</structname> view, but
   <function>pg_buffercache_usage_counts()</function> is significantly cheaper.␟<function>pg_buffercache_usage_counts()</function>関数は、すべての共有バッファの状態を要約した行の集合を返します。これは、推定使用カウント値に基づいて集計されます。
同様の、より詳細な情報は<structname>pg_buffercache</structname>ビューによって提供されますが、<function>pg_buffercache_usage_counts()</function>はかなり安価です。␞␞  </para>␞
␝  <para>␟   Like the <structname>pg_buffercache</structname> view,
   <function>pg_buffercache_usage_counts()</function> does not acquire buffer
   manager locks. Therefore concurrent activity can lead to minor inaccuracies
   in the result.␟<structname>pg_buffercache</structname>ビューと同様に、<function>pg_buffercache_usage_counts()</function>はバッファマネージャのロックを取得しません。
そのため、同時実行中の処理によって結果に小さな不正確さが生じる可能性があります。␞␞  </para>␞
␝ <sect2 id="pgbuffercache-pg-buffercache-evict">␟  <title>The <function>pg_buffercache_evict()</function> Function</title>␟  <title><function>pg_buffercache_evict()</function>関数</title>␞␞  <para>␞
␝  <para>␟   The <function>pg_buffercache_evict()</function> function takes a buffer
   identifier, as shown in the <structfield>bufferid</structfield> column of
   the <structname>pg_buffercache</structname> view.  It returns true on success,
   and false if the buffer wasn't valid, if it couldn't be evicted because it
   was pinned, or if it became dirty again after an attempt to write it out.
   The result is immediately out of date upon return, as the buffer might
   become valid again at any time due to concurrent activity.  The function is
   intended for developer testing only.␟<function>pg_buffercache_evict()</function>関数は、<structname>pg_buffercache</structname>ビューの<structfield>bufferid</structfield>列に示されるバッファ識別子を取ります。
成功した場合はtrueを、バッファが有効でなかった場合はfalseを、バッファが固定されていたために削除できなかった場合や、書き出そうとした後で再びダーティになった場合はfalseを返します。
バッファは同時アクティビティのためにいつでも再び有効になる可能性があるため、結果は戻されるとすぐに無効になります。
この関数は、開発者のテストのみを目的としています。␞␞  </para>␞
␝<sect2 id="pgbuffercache-sample-output">␟  <title>Sample Output</title>␟  <title>サンプル出力</title>␞␞␞
␝ <sect2 id="pgbuffercache-authors">␟  <title>Authors</title>␟  <title>作者</title>␞␞␞
␝  <para>␟   Design suggestions: Neil Conway <email>neilc@samurai.com</email>␟設計協力: Neil Conway <email>neilc@samurai.com</email>␞␞  </para>␞
␝  <para>␟   Debugging advice: Tom Lane <email>tgl@sss.pgh.pa.us</email>␟デバッグのアドバイス: Tom Lane <email>tgl@sss.pgh.pa.us</email>␞␞  </para>␞
␝␟<structfield>bufferid</structfield> <type>integer</type>␟no translation␞␞␞
␝␟<structfield>relforknumber</structfield> <type>smallint</type>␟no translation␞␞␞
␝␟<structfield>relblocknumber</structfield> <type>bigint</type>␟no translation␞␞␞
␝␟<structfield>isdirty</structfield> <type>boolean</type>␟no translation␞␞␞
␝␟<structfield>usagecount</structfield> <type>smallint</type>␟no translation␞␞␞
␝␟<structfield>pinning_backends</structfield> <type>integer</type>␟no translation␞␞␞
␝␟<structfield>buffers_used</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>buffers_unused</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>buffers_dirty</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>buffers_pinned</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>usagecount_avg</structfield> <type>float8</type>␟no translation␞␞␞
␝␟<structfield>usage_count</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>buffers</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>dirty</structfield> <type>int4</type>␟no translation␞␞␞
␝␟<structfield>pinned</structfield> <type>int4</type>␟no translation␞␞␞
␝␟Mark Kirkwood <email>markir@paradise.net.nz</email>␟no translation␞␞␞
