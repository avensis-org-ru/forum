<?php
//
// Basic Configuration
// How Many Topics you want to display?
$topicnumber = 20;
// Scrolling towards up or down?
// Обязательно пропишите свой путь к форуму
$urlPath = "http://avensis.org.ru/forum/";

// Database Configuration (Where your phpBB config.php file is located
include 'config.php';

// Connecting & Selecting Databases
$table_topics = $table_prefix. "topics";
$table_forums = $table_prefix. "forums";
$table_posts = $table_prefix. "posts";
$table_users = $table_prefix. "users";
$link = mysql_connect("$dbhost", "$dbuser", "$dbpasswd") or die("Could not connect");
mysql_select_db("$dbname") or die("Could not select database");
mysql_query("SET NAMES cp1251");

// Perform Sql Query
$query = "SELECT t.topic_id, t.topic_title, t.topic_last_post_id, t.forum_id, p.post_id, p.poster_id, p.post_time, u.user_id, u.username
FROM $table_topics t, $table_forums f, $table_posts p, $table_users u
WHERE t.topic_id = p.topic_id AND 
f.forum_id = t.forum_id AND 
t.topic_status <> 2 AND 
p.post_id = t.topic_last_post_id AND 
p.poster_id = u.user_id
ORDER BY p.post_id DESC LIMIT $topicnumber";
$result = mysql_query($query) or die("Query failed");

// Outcome of the HTML
// Be carefull when you edit these!
print "
<table>
</table>
<center>
<table cellpadding='0' cellSpacing='0' width='100%'  border='1' 
<tr>
<td><center>Название темы</center></td>
</tr>";
while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
echo  "<tr valign='top'><td><div align=\"left\"><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"0\"><font color=\"#FFCC00\"><b><a href=\"$urlPath/viewtopic.php?t=$row[topic_id]&f=$row[forum_id]\">" .
$row["topic_title"] .
"</a></div></td></font></b>
<td><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"0\"><font color=\"#676767\">" .
//date('F j, Y, G:i', $row["post_time"]) .
"</td></tr></font>";
}
print "</table></center>";

// Free Result
mysql_free_result($result);

// Close the Connection
mysql_close($link);
?>
