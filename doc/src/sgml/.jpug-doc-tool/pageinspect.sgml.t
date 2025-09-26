␝<sect1 id="pageinspect" xreflabel="pageinspect">␟ <title>pageinspect &mdash; low-level inspection of database pages</title>␟ <title>pageinspect &mdash; データベースページの低レベルな調査</title>␞␞␞
␝ <para>␟  The <filename>pageinspect</filename> module provides functions that allow you to
  inspect the contents of database pages at a low level, which is useful for
  debugging purposes.  All of these functions may be used only by superusers.␟<filename>pageinspect</filename>モジュールは、デバッグの際に有用となる低レベルなデータベースページの内容を調べることができる関数を提供します。
これらの関数はすべて、スーパーユーザのみが使用することができます。␞␞ </para>␞
␝ <sect2 id="pageinspect-general-funcs">␟  <title>General Functions</title>␟  <title>一般的な関数</title>␞␞␞
␝     <para>␟      <function>get_raw_page</function> reads the specified block of the named
      relation and returns a copy as a <type>bytea</type> value.  This allows a
      single time-consistent copy of the block to be obtained.
      <replaceable>fork</replaceable> should be <literal>'main'</literal> for
      the main data fork, <literal>'fsm'</literal> for the
      <link linkend="storage-fsm">free space map</link>,
      <literal>'vm'</literal> for the
      <link linkend="storage-vm">visibility map</link>, or
      <literal>'init'</literal> for the initialization fork.␟<function>get_raw_page</function>は指定された名前付きリレーションの指定されたブロックを読み取り、<type>bytea</type>値としてそのコピーを返します。
これにより、単一ブロックの時間的に一貫性を持つコピーを入手することができます。
<replaceable>fork</replaceable>は、主データフォークでは<literal>'main'</literal>、<link linkend="storage-fsm">空き領域マップ</link>では<literal>'fsm'</literal>、<link linkend="storage-vm">可視性マップ</link>では<literal>'vm'</literal>、初期化フォークでは<literal>'init'</literal>としなければなりません。␞␞     </para>␞
␝     <para>␟      A shorthand version of <function>get_raw_page</function>, for reading
      from the main fork.  Equivalent to
      <literal>get_raw_page(relname, 'main', blkno)</literal>␟<function>get_raw_page</function>の簡略形であり、主フォークから読み取ります。
<literal>get_raw_page(relname, 'main', blkno)</literal>と同じです。␞␞     </para>␞
␝     <para>␟      <function>page_header</function> shows fields that are common to all
      <productname>PostgreSQL</productname> heap and index pages.␟<function>page_header</function>は、すべての<productname>PostgreSQL</productname>ヒープとインデックスページで共通するフィールドを表示します。␞␞     </para>␞
␝     <para>␟      A page image obtained with <function>get_raw_page</function> should be
      passed as argument.  For example:␟<function>get_raw_page</function>で得られたページイメージを引数として渡さなければなりません。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      The returned columns correspond to the fields in the
      <structname>PageHeaderData</structname> struct.
      See <filename>src/include/storage/bufpage.h</filename> for details.␟返される列は、<structname>PageHeaderData</structname>構造体のフィールドに対応します。
詳細は<filename>src/include/storage/bufpage.h</filename>を参照してください。␞␞     </para>␞
␝     <para>␟      The <structfield>checksum</structfield> field is the checksum stored in
      the page, which might be incorrect if the page is somehow corrupted.  If
      data checksums are not enabled for this instance, then the value stored
      is meaningless.␟<structfield>checksum</structfield>フィールドはページに保存されたチェックサムであり、ページがどういうわけか壊れていれば正しくないでしょう。
このインスタンスに対してデータチェックサムが有効になっていなければ、保存されている値には意味がありません。␞␞     </para>␞
␝     <para>␟      <function>page_checksum</function> computes the checksum for the page, as if
      it was located at the given block.␟<function>page_checksum</function>は指定されたブロックに位置するかのようにページのチェックサムを計算します。␞␞     </para>␞
␝     <para>␟      A page image obtained with <function>get_raw_page</function> should be
      passed as argument.  For example:␟<function>get_raw_page</function>で得られたページイメージを引数として渡さなければなりません。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      Note that the checksum depends on the block number, so matching block
      numbers should be passed (except when doing esoteric debugging).␟チェックサムはブロック番号に依存するので、(難解なデバッグをする場合以外は)対応するブロック番号を渡さなければならないことに注意してください。␞␞     </para>␞
␝     <para>␟      The checksum computed with this function can be compared with
      the <structfield>checksum</structfield> result field of the
      function <function>page_header</function>.  If data checksums are
      enabled for this instance, then the two values should be equal.␟この関数で計算されたチェックサムは、<function>page_header</function>関数の<structfield>checksum</structfield>結果フィールドと比較できます。
このインスタンスに対してデータチェックサムが有効になっていれば、二つの値は等しくならなければなりません。␞␞     </para>␞
␝     <para>␟      <function>fsm_page_contents</function> shows the internal node structure
      of an <acronym>FSM</acronym> page.  For example:␟<function>fsm_page_contents</function>は、<acronym>FSM</acronym>ページの内部ノード構造を表示します。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      The output is a multiline string, with one line per node in the binary
      tree within the page.  Only those nodes that are not zero are printed.
      The so-called "next" pointer, which points to the next slot to be
      returned from the page, is also printed.␟出力は複数行からなる文字列で、各行がページ内のバイナリツリー（二分木）の1ノードを表します。
それらのノードのうち、非ゼロのノードのみが出力されます。
そのページから返される次のスロットを指し示すための"next（次）"と呼ばれるポインタも出力されます。␞␞     </para>␞
␝     <para>␟      See <filename>src/backend/storage/freespace/README</filename> for more
      information on the structure of an <acronym>FSM</acronym> page.␟ <acronym>FSM</acronym>ページの構造に関する更に詳しい情報は、<filename>src/backend/storage/freespace/README</filename>を参照してください。␞␞     </para>␞
␝ <sect2 id="pageinspect-heap-funcs">␟  <title>Heap Functions</title>␟  <title>ヒープ関数</title>␞␞␞
␝     <para>␟      <function>heap_page_items</function> shows all line pointers on a heap
      page.  For those line pointers that are in use, tuple headers as well
      as tuple raw data are also shown. All tuples are shown, whether or not
      the tuples were visible to an MVCC snapshot at the time the raw page
      was copied.␟<function>heap_page_items</function>はヒープページ上の行ポインタをすべて表示します。
使用中の行ポインタでは、タプルヘッダおよびタプルの生データも表示されます。
生ページがコピーされた時点のMVCCスナップショットでタプルが可視かどうかは関係なく、すべてのタプルが表示されます。␞␞     </para>␞
␝     <para>␟      A heap page image obtained with <function>get_raw_page</function> should
      be passed as argument.  For example:␟<function>get_raw_page</function>で得られたヒープページイメージを引数として渡さなければなりません。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      See <filename>src/include/storage/itemid.h</filename> and
      <filename>src/include/access/htup_details.h</filename> for explanations of the fields
      returned.␟返されるフィールドの説明については、<filename>src/include/storage/itemid.h</filename>および<filename>src/include/access/htup_details.h</filename>を参照してください。␞␞     </para>␞
␝     <para>␟      The <function>heap_tuple_infomask_flags</function> function can be
      used to unpack the flag bits of <structfield>t_infomask</structfield>
      and <structfield>t_infomask2</structfield> for heap tuples.␟<function>heap_tuple_infomask_flags</function>関数を使用すると、ヒープタプルの<structfield>t_infomask</structfield>および<structfield>t_infomask2</structfield>のフラグビットを展開することができます。␞␞     </para>␞
␝     <para>␟      <function>tuple_data_split</function> splits tuple data into attributes
      in the same way as backend internals.␟<function>tuple_data_split</function>はバックエンドの内部がするのと同じ方法で、タプルデータを属性に分割します。␞␞<screen>␞
␝</screen>␟      This function should be called with the same arguments as the return
      attributes of <function>heap_page_items</function>.␟この関数は<function>heap_page_items</function>の戻り値の属性と同じ引数で呼び出してください。␞␞     </para>␞
␝     <para>␟      If <parameter>do_detoast</parameter> is <literal>true</literal>,
      attributes will be detoasted as needed. Default value is
      <literal>false</literal>.␟<parameter>do_detoast</parameter>が<literal>true</literal>の場合、属性は必要に応じて非TOAST化されます。
デフォルト値は<literal>false</literal>です。␞␞     </para>␞
␝     <para>␟      <function>heap_page_item_attrs</function> is equivalent to
      <function>heap_page_items</function> except that it returns
      tuple raw data as an array of attributes that can optionally
      be detoasted by <parameter>do_detoast</parameter> which is
      <literal>false</literal> by default.␟<function>heap_page_item_attrs</function>は<function>heap_page_items</function>と同じですが、タプルの生データを<parameter>do_detoast</parameter>（デフォルトは<literal>false</literal>）によって非TOAST化可能な属性の配列として返すところが異なります。␞␞     </para>␞
␝     <para>␟      A heap page image obtained with <function>get_raw_page</function> should
      be passed as argument.  For example:␟<function>get_raw_page</function>で取得できるヒープページのイメージを引数として渡してください。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>heap_tuple_infomask_flags</function> decodes the
      <structfield>t_infomask</structfield> and
      <structfield>t_infomask2</structfield> returned by
      <function>heap_page_items</function> into a human-readable
      set of arrays made of flag names, with one column for all
      the flags and one column for combined flags. For example:␟<function>heap_tuple_infomask_flags</function>は、<function>heap_page_items</function>から返される<structfield>t_infomask</structfield>および<structfield>t_infomask2</structfield>を、フラグ名で構成される人間が見てわかる形式の配列セットにデコードします。
このとき、すべてのフラグ用の列が一つ、結合されたフラグ用の列が一つあります。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      This function should be called with the same arguments as the return
      attributes of <function>heap_page_items</function>.␟この関数は<function>heap_page_items</function>の戻り値の属性と同じ引数で呼び出してください。␞␞     </para>␞
␝     <para>␟      Combined flags are displayed for source-level macros that take into
      account the value of more than one raw bit, such as
      <literal>HEAP_XMIN_FROZEN</literal>.␟結合されたフラグは、 <literal>HEAP_XMIN_FROZEN</literal>など、複数のrawビットの値を考慮するソースレベルのマクロから得られたビットを表示します。␞␞     </para>␞
␝     <para>␟      See <filename>src/include/access/htup_details.h</filename> for
      explanations of the flag names returned.␟返されるフラグ名の説明については、<filename>src/include/access/htup_details.h</filename>を参照して下さい。␞␞     </para>␞
␝ <sect2 id="pageinspect-b-tree-funcs">␟  <title>B-Tree Functions</title>␟  <title>B-tree関数</title>␞␞␞
␝     <para>␟      <function>bt_metap</function> returns information about a B-tree
      index's metapage.  For example:␟<function>bt_metap</function>はB-treeインデックスのメタページに関する情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>bt_page_stats</function> returns summary information about
      a data page of a B-tree index.  For example:␟<function>bt_page_stats</function>は、B-treeインデックスのデータページについての要約情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>bt_multi_page_stats</function> returns the same information
      as <function>bt_page_stats</function>, but does so for each page of the
      range of pages beginning at <parameter>blkno</parameter> and extending
      for <parameter>blk_count</parameter> pages.
      If <parameter>blk_count</parameter> is negative, all pages
      from <parameter>blkno</parameter> to the end of the index are reported
      on.  For example:␟<function>bt_multi_page_stats</function>は<function>bt_page_stats</function>と同じ情報を返しますが、<parameter>blkno</parameter>から始まり<parameter>blk_count</parameter>ページ及ぶ範囲の各ページについて行ないます。
<parameter>blk_count</parameter>が負の場合、<parameter>blkno</parameter>からindexの最後までのすべてのページが報告されます。
例えば、次のようになります。␞␞<screen>␞
␝     <para>␟      <function>bt_page_items</function> returns detailed information about
      all of the items on a B-tree index page.  For example:␟<function>bt_page_items</function>は、B-treeインデックスページ上の全項目についての詳細情報を返します。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      This is a B-tree leaf page.  All tuples that point to the table
      happen to be posting list tuples (all of which store a total of
      100 6 byte TIDs).  There is also a <quote>high key</quote> tuple
      at <literal>itemoffset</literal> number 1.
      <structfield>ctid</structfield> is used to store encoded
      information about each tuple in this example, though leaf page
      tuples often store a heap TID directly in the
      <structfield>ctid</structfield> field instead.
      <structfield>tids</structfield> is the list of TIDs stored as a
      posting list.␟これはB-treeのリーフページです。
テーブルを指し示すすべてのタプルは、ポスティングリストのタプルになっています（これらはすべて6バイトTIDが合計100個格納されます）。
また、<literal>itemoffset</literal>番号１には<quote>ハイキー(high key)</quote>タプルもあります。
この例では、各タプルに関するエンコードされた情報を格納するために<structfield>ctid</structfield>が使用されていますが、リーフページタプルでは、ヒープTIDが直接<structfield>ctid</structfield>フィールドに格納されることがよくあります。
<structfield>tids</structfield>はポスティングリストとして格納されるTIDのリストです。␞␞     </para>␞
␝     <para>␟      In an internal page (not shown), the block number part of
      <structfield>ctid</structfield> is a <quote>downlink</quote>,
      which is a block number of another page in the index itself.
      The offset part (the second number) of
      <structfield>ctid</structfield> stores encoded information about
      the tuple, such as the number of columns present (suffix
      truncation may have removed unneeded suffix columns).  Truncated
      columns are treated as having the value <quote>minus
       infinity</quote>.␟内部ページ（示されていません）では、<structfield>ctid</structfield>のブロック番号部分は、<quote>ダウンリンク(downlink)</quote>であり、インデックス内の他のページのブロック番号です。
<structfield>ctid</structfield>のオフセット部分（２番め）には、存在する列の数など、タプルに関するエンコードされた情報が格納されます（サフィックスの切り捨てによって、不要なサフィックス列が削除されている場合があります）。
切り捨てられた列は、<quote>マイナス無限大(minus infinity)</quote>を持つものとして扱われます。␞␞     </para>␞
␝     <para>␟      <structfield>htid</structfield> shows a heap TID for the tuple,
      regardless of the underlying tuple representation.  This value
      may match <structfield>ctid</structfield>, or may be decoded
      from the alternative representations used by posting list tuples
      and tuples from internal pages.  Tuples in internal pages
      usually have the implementation level heap TID column truncated
      away, which is represented as a NULL
      <structfield>htid</structfield> value.␟<structfield>htid</structfield>は、基礎となるタプル表現に関係なく、タプルのヒープTIDを示します。
この値は、<structfield>ctid</structfield>と一致する場合もあれば、ポスティングリストのタプルおよび内部ページのタプルが使用する別の表現からデコードされる場合もあります。
内部ページのタプルでは、実装レベルのヒープTID列が切り捨てられ、NULL <structfield>htid</structfield>値として表されます。␞␞     </para>␞
␝     <para>␟      Note that the first item on any non-rightmost page (any page with
      a non-zero value in the <structfield>btpo_next</structfield> field) is the
      page's <quote>high key</quote>, meaning its <structfield>data</structfield>
      serves as an upper bound on all items appearing on the page, while
      its <structfield>ctid</structfield> field does not point to
      another block.  Also, on internal pages, the first real data
      item (the first item that is not a high key) reliably has every
      column truncated away, leaving no actual value in its
      <structfield>data</structfield> field.  Such an item does have a
      valid downlink in its <structfield>ctid</structfield> field,
      however.␟右端以外のページ（<structfield>btpo_next</structfield>フィールドの値が0でないページ）において、最初の項目はページの<quote>ハイキー</quote>であることに注意してください。
つまりそのページに現れるすべての項目の上限となる<structfield>data</structfield>になりますが、一方でその<structfield>ctid</structfield>フィールドは別のブロックを指していないことを意味します。
また、内部ページでは、最初の実データ項目（ハイキーでない最初の項目）は、確実にすべての列が切り捨てられ、その<structfield>data</structfield>フィールドに実際の値は残りません。
しかし、そのような項目でも、その<structfield>ctid</structfield>フィールドには有効なダウンリンクが入っています。␞␞     </para>␞
␝     <para>␟      For more details about the structure of B-tree indexes, see
      <xref linkend="btree-structure"/>.  For more details about
      deduplication and posting lists, see <xref
       linkend="btree-deduplication"/>.␟B-Treeインデックスの構造についての詳細は<xref linkend="btree-structure"/>を参照してください。
重複排除とポスティングリストについての詳細は<xref linkend="btree-deduplication"/>を参照してください。␞␞     </para>␞
␝     <para>␟      It is also possible to pass a page to <function>bt_page_items</function>
      as a <type>bytea</type> value.  A page image obtained
      with <function>get_raw_page</function> should be passed as argument.  So
      the last example could also be rewritten like this:␟ページを<function>bt_page_items</function>に<type>bytea</type>の値として渡すことも可能です。
<function>get_raw_page</function>で得られたページイメージを引数として渡さなければなりません。
なので、最後の例は以下のように書き直すこともできます。␞␞<screen>␞
␝</screen>␟      All the other details are the same as explained in the previous item.␟その他の詳細はすべて前の項目で説明したものと同じです。␞␞     </para>␞
␝ <sect2 id="pageinspect-brin-funcs">␟  <title>BRIN Functions</title>␟  <title>BRIN関数</title>␞␞␞
␝     <para>␟      <function>brin_page_type</function> returns the page type of the given
      <acronym>BRIN</acronym> index page, or throws an error if the page is
      not a valid <acronym>BRIN</acronym> page.  For example:␟<function>brin_page_type</function>は指定の<acronym>BRIN</acronym>インデックスページのページ種別を返します。
ページが有効な<acronym>BRIN</acronym>ページでないときはエラーが発生します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>brin_metapage_info</function> returns assorted information
      about a <acronym>BRIN</acronym> index metapage.  For example:␟<function>brin_metapage_info</function>は<acronym>BRIN</acronym>インデックスのメタページについて様々な情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>brin_revmap_data</function> returns the list of tuple
      identifiers in a <acronym>BRIN</acronym> index range map page.
      For example:␟<function>brin_revmap_data</function>は<acronym>BRIN</acronym>インデックスの範囲マップページのタプル識別子のリストを返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>brin_page_items</function> returns the data stored in the
      <acronym>BRIN</acronym> data page.  For example:␟<function>brin_page_items</function>は<acronym>BRIN</acronym>データページに記録されているデータを返します。
以下に例を示します。␞␞<screen>␞
␝</screen>␟      The returned columns correspond to the fields in the
      <structname>BrinMemTuple</structname> and <structname>BrinValues</structname> structs.
      See <filename>src/include/access/brin_tuple.h</filename> for details.␟返される列は<structname>BrinMemTuple</structname>構造体および<structname>BrinValues</structname>構造体のフィールドに対応します。
詳しくは<filename>src/include/access/brin_tuple.h</filename>を参照して下さい。␞␞     </para>␞
␝ <sect2 id="pageinspect-gin-funcs">␟  <title>GIN Functions</title>␟  <title>GIN関数</title>␞␞␞
␝     <para>␟      <function>gin_metapage_info</function> returns information about
      a <acronym>GIN</acronym> index metapage.  For example:␟<function>gin_metapage_info</function>は<acronym>GIN</acronym>インデックスのメタページに関する情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>gin_page_opaque_info</function> returns information about
      a <acronym>GIN</acronym> index opaque area, like the page type.
      For example:␟<function>gin_page_opaque_info</function>はページ種別のような<acronym>GIN</acronym>インデックスの不透明な領域についての情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>gin_leafpage_items</function> returns information about
      the data stored in a compressed <acronym>GIN</acronym> leaf page.  For example:␟<function>gin_leafpage_items</function>は圧縮された<acronym>GIN</acronym>のリーフページに格納されているデータについての情報を返します。
以下に例を示します。␞␞<screen>␞
␝ <sect2 id="pageinspect-gist-funcs">␟  <title>GiST Functions</title>␟  <title>GiST関数</title>␞␞␞
␝     <para>␟      <function>gist_page_opaque_info</function> returns information from
      a <acronym>GiST</acronym> index page's opaque area, such as the NSN,
      rightlink and page type.
      For example:␟<function>gist_page_opaque_info</function>はNSN、rightlink、ページ種別などの<acronym>GiST</acronym>インデックスの不透明な領域についての情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>gist_page_items</function> returns information about
      the data stored in a page of a <acronym>GiST</acronym> index.  For example:␟<function>gist_page_items</function>は<acronym>GiST</acronym>のインデックスのページに格納されているデータについての情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      Same as <function>gist_page_items</function>, but returns the key data
      as a raw <type>bytea</type> blob.  Since it does not attempt to decode
      the key, it does not need to know which index is involved.  For
      example:␟<function>gist_page_items</function>と同じですが、キーデータを生<type>bytea</type>blobとして返します。
キーをデコードしようとしないので、どのインデックスが含まれているかを知る必要はありません。
以下に例を示します。␞␞<screen>␞
␝ <sect2 id="pageinspect-hash-funcs">␟  <title>Hash Functions</title>␟  <title>Hash関数</title>␞␞␞
␝     <para>␟      <function>hash_page_type</function> returns page type of
      the given <acronym>HASH</acronym> index page.  For example:␟<function>hash_page_type</function>は与えられた<acronym>HASH</acronym>インデックスページのページ種別を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>hash_page_stats</function> returns information about
      a bucket or overflow page of a <acronym>HASH</acronym> index.
      For example:␟<function>hash_page_stats</function>は<acronym>HASH</acronym>インデックスのバケットページやオーバーフローページに関する情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>hash_page_items</function> returns information about
      the data stored in a bucket or overflow page of a <acronym>HASH</acronym>
      index page.  For example:␟<function>hash_page_items</function>は<acronym>HASH</acronym>インデックスページのバケットページやオーバーフローページに保存されたデータに関する情報を返します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>hash_bitmap_info</function> shows the status of a bit
      in the bitmap page for a particular overflow page of <acronym>HASH</acronym>
      index. For example:␟<function>hash_bitmap_info</function>は<acronym>HASH</acronym>インデックスの特定のオーバーフローページに対するビットマップページのビットの状態を表示します。
以下に例を示します。␞␞<screen>␞
␝     <para>␟      <function>hash_metapage_info</function> returns information stored
      in the meta page of a <acronym>HASH</acronym> index.  For example:␟<function>hash_metapage_info</function>は<acronym>HASH</acronym>インデックスのメタページに保存された情報を返します。
以下に例を示します。␞␞<screen>␞
