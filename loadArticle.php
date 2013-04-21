<?php
$url_hash = $_GET["url"];
$con = mysql_connect("localhost","ptwigger_Philip","Vokeyoil1!");
mysql_set_charset('utf8',$con);
if(!$con)
	{
	die("Could not connect: " . mysql_error());
	}
	
	mysql_select_db("ptwigger_news", $con);
	 
	$result = mysql_query("SELECT section,title,byline,updated_date,article_html FROM ptwigger_news.articles a WHERE url_hash = '".$url_hash."'"); 
	
	while ($row = mysql_fetch_array($result))
	{
		echo "<h2 class=" . $row['section'] . ">" . $row['section'] . "</h2>";
		echo "<div id='articleContent'>";
		echo "<p class='articleTitle'>" . $row['title'] . "</p>";
		echo "<p class='byline clear'>". $row['byline'] . "</p>";
		echo $row['article_html'];
		echo "<p class='date clear'> Updated: " . $row['updated_date'] . "</p>";
		echo "</div>";
	}

	mysql_close($con);
?>