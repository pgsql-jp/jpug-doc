␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP INDEX</refname>␟  <refpurpose>remove an index</refpurpose>␟  <refpurpose>インデックスを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP INDEX</command> drops an existing index from the database
   system. To execute this command you must be the owner of
   the index.␟<command>DROP INDEX</command>はデータベースシステムから既存のインデックスを削除します。
このコマンドを実行するには、そのインデックスを所有していなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Drop the index without locking out concurrent selects, inserts, updates,
      and deletes on the index's table.  A normal <command>DROP INDEX</command>
      acquires an <literal>ACCESS EXCLUSIVE</literal> lock on the table,
      blocking other accesses until the index drop can be completed.  With
      this option, the command instead waits until conflicting transactions
      have completed.␟インデックスのテーブルに対して同時に実行される選択、挿入、更新、削除をロックすることなくインデックスを削除します。
通常の<command>DROP INDEX</command>ではテーブルに対する<literal>ACCESS EXCLUSIVE</literal>ロックを獲得し、インデックスの削除が完了するまで他のアクセスをブロックします。
このオプションを使うと、競合するトランザクションが完了するまでコマンドは待たされます。␞␞     </para>␞
␝     <para>␟      There are several caveats to be aware of when using this option.
      Only one index name can be specified, and the <literal>CASCADE</literal> option
      is not supported.  (Thus, an index that supports a <literal>UNIQUE</literal> or
      <literal>PRIMARY KEY</literal> constraint cannot be dropped this way.)
      Also, regular <command>DROP INDEX</command> commands can be
      performed within a transaction block, but
      <command>DROP INDEX CONCURRENTLY</command> cannot.
      Lastly, indexes on partitioned tables cannot be dropped using this
      option.␟このオプションを使用する時に注意すべき、複数の警告があります。
指定できるインデックス名は１つだけであり、また、<literal>CASCADE</literal>オプションはサポートされません。
（したがって<literal>UNIQUE</literal>または<literal>PRIMARY KEY</literal>制約をサポートするインデックスをこの方法で削除することはできません。）
また、通常の<command>DROP INDEX</command>はトランザクションブロックの中で行うことができますが、<command>DROP INDEX CONCURRENTLY</command>はできません。
最後に、パーティションテーブルのインデックスをこのオプションで削除することはできません。␞␞     </para>␞
␝     <para>␟      For temporary tables, <command>DROP INDEX</command> is always
      non-concurrent, as no other session can access them, and
      non-concurrent index drop is cheaper.␟一時テーブルに対しては<command>DROP INDEX</command>は常に同時削除ではありません。他のセッションはアクセスできませんし、同時でないインデックス削除の方がより安価だからです。␞␞     </para>␞
␝     <para>␟      Do not throw an error if the index does not exist. A notice is issued
      in this case.␟インデックスが存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an index to remove.␟削除するインデックスの名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the index,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟そのインデックスに依存しているオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the index if any objects depend on it.  This is
      the default.␟依存しているオブジェクトがある場合、そのインデックスの削除を拒否します。
こちらがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   This command will remove the index <literal>title_idx</literal>:␟次のコマンドはインデックス<literal>title_idx</literal>を削除します。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP INDEX</command> is a
   <productname>PostgreSQL</productname> language extension.  There
   are no provisions for indexes in the SQL standard.␟<command>DROP INDEX</command>は<productname>PostgreSQL</productname>の言語拡張です。
標準SQLにはインデックスに関する規定はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP INDEX title_idx; </programlisting></para> </programlisting></para>␟no translation␞␞␞
