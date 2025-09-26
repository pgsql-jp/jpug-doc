␝<sect1 id="intagg" xreflabel="intagg">␟ <title>intagg &mdash; integer aggregator and enumerator</title>␟ <title>intagg &mdash; 整数型の集約子と列挙子</title>␞␞␞
␝ <para>␟  The <filename>intagg</filename> module provides an integer aggregator and an
  enumerator.  <filename>intagg</filename> is now obsolete, because there
  are built-in functions that provide a superset of its capabilities.
  However, the module is still provided as a compatibility wrapper around
  the built-in functions.␟<filename>intagg</filename>モジュールは整数型の集約子と列挙子を提供します。
その能力の上位集合を提供する組み込み関数が存在しますので、<filename>intagg</filename>は現在使われません。
しかし、このモジュールは組み込み関数の互換ラッパーとして今でもまだ提供されています。␞␞ </para>␞
␝ <sect2 id="intagg-functions">␟  <title>Functions</title>␟  <title>関数</title>␞␞␞
␝ <para>␟  The aggregator is an aggregate function
  <function>int_array_aggregate(integer)</function>
  that produces an integer array
  containing exactly the integers it is fed.
  This is a wrapper around <function>array_agg</function>,
  which does the same thing for any array type.␟集約子は、正確に提供する整数のみを含む整数型配列を生成する<function>int_array_aggregate(integer)</function>集約関数です。
これは任意の配列型で同じことを行う<function>array_agg</function>のラッパーです。␞␞ </para>␞
␝ <para>␟  The enumerator is a function
  <function>int_array_enum(integer[])</function>
  that returns <type>setof integer</type>.  It is essentially the reverse
  operation of the aggregator: given an array of integers, expand it
  into a set of rows.  This is a wrapper around <function>unnest</function>,
  which does the same thing for any array type.␟列挙子は、<type>setof integer</type>を返す<function>int_array_enum(integer[])</function>関数です。
これは基本的に上記集約子の反対の操作を行います。
指定された整数型配列を行集合に拡張します。
これは任意の配列型で同じことを行う<function>unnest</function>のラッパーです。␞␞ </para>␞
␝ <sect2 id="intagg-samples">␟  <title>Sample Uses</title>␟  <title>使用例</title>␞␞␞
␝  <para>␟   Many database systems have the notion of a many to many table. Such a table
   usually sits between two indexed tables, for example:␟多くのデータベースシステムは多対多のテーブルを持ちます。
こうしたテーブルは通常、以下のように2つのインデックス用のテーブルの間に存在します。␞␞␞
␝␟  It is typically used like this:␟通常以下のように使用されます。␞␞␞
␝␟  This will return all the items in the right hand table for an entry
  in the left hand table. This is a very common construct in SQL.␟これは、左辺のテーブル内にある項目に対応した、右辺のテーブル内のすべての項目を返します。
これはSQLで非常によく使用される式です。␞␞ </para>␞
␝ <para>␟  Now, this methodology can be cumbersome with a very large number of
  entries in the <structname>many_to_many</structname> table.  Often,
  a join like this would result in an index scan
  and a fetch for each right hand entry in the table for a particular
  left hand entry. If you have a very dynamic system, there is not much you
  can do. However, if you have some data which is fairly static, you can
  create a summary table with the aggregator.␟さて、この方法論は<structname>many_to_many</structname>テーブル内に非常に多数の項目がある場合に扱いにくくなることがあり得ます。
しばしばこうした結合は、インデックススキャンと特定された左辺の項目に対応した右辺のテーブル内の項目をそれぞれ取り出すことになります。
非常に動的なシステムでは、できることは多くありません。
しかし、ほぼ静的なデータが一部にある場合、集約子を使用して要約テーブルを作成することができます。␞␞␞
␝␟  This will create a table with one row per left item, and an array
  of right items. Now this is pretty useless without some way of using
  the array; that's why there is an array enumerator.  You can do␟これは左辺項目毎に1行を持ち、右辺の項目の配列をもつテーブルを作成します。
さて、これは配列を使用する何らかの方法がないとかなり使い勝手が悪くなります。
これが配列列挙子が存在する理由です。
以下を行うことができます。␞␞␞
␝␟  The above query using <function>int_array_enum</function> produces the same results
  as␟上の<function>int_array_enum</function>を使用した問い合わせは、以下と同じ結果を生成します。␞␞␞
␝␟  The difference is that the query against the summary table has to get
  only one row from the table, whereas the direct query against
  <structname>many_to_many</structname> must index scan and fetch a row for each entry.␟違いは、要約テーブルに対する問い合わせはテーブルから1行だけを取り出す必要があるのに対し、直接<structname>many_to_many</structname>に問い合わせる場合はインデックススキャンと各項目に対し行を取り出さなければならないという点です。␞␞ </para>␞
␝ <para>␟  On one system, an <command>EXPLAIN</command> showed a query with a cost of 8488 was
  reduced to a cost of 329.  The original query was a join involving the
  <structname>many_to_many</structname> table, which was replaced by:␟あるシステムでは<command>EXPLAIN</command>を行うと8488というコストを持つ問い合わせが329というコストまで減少しました。
元の問い合わせは<structname>many_to_many</structname>テーブルを含む結合でしたが、以下のように置き換えられました。␞␞␞
