<?php
header('Content-Type: text/html; charset=utf-8');
$con = mysql_connect("localhost","ptwigger_Philip","Vokeyoil1!");
if(!$con)
	{
	die("Could not connect: " . mysql_error());
	}
	
	mysql_select_db("ptwigger_news", $con);
	mysql_set_charset('utf8',$con);
	/*	This code is to test character encoding -- currently using UTF-8 throughout application. 
		$charset = mysql_client_encoding($con);
		echo "The current character set is: $charset\n";	
	*/
	
	/*	This sequel below is for Business, World, US, Travel, Technology, Style, Fashion & Style, Sports, Science, NY, Health, Dining & Wine, or Arts.
	$result = mysql_query("SELECT section,title,abstract,url,updated_date,url_hash FROM ptwigger_news.articles a WHERE section='Business Day' or section='Business' or section='World' or section='U.S.' or section='Travel' or section='Technology' or section='Style' or section='Fashion & Style' or section='Sports' or section='Science' or section='N.Y. / Region' or section='Health' or section='Dining & Wine' or section='Arts' order by updated_date desc LIMIT 100");	
	*/
	/* This sequel below is for Business, World, US, Technology, and Sports. */
	 
	
	$result = mysql_query("SELECT section,title,abstract,source,url,updated_date,url_hash FROM ptwigger_news.articles a WHERE section='Business Day' or section='Business' or section='World' or section='U.S.' or section='Technology' or section='Sports' order by updated_date desc LIMIT 50");	

	/* This sequel below is for Wall Street Journal 
	
	$result = mysql_query("SELECT section,title,abstract,source,url,updated_date,url_hash FROM ptwigger_news.articles a WHERE source='Wall Street Journal' and(section='Business Day' or section='Business' or section='Technology' or section='Sports' or section='Science' or section='Health' or section='Travel') group by title order by updated_date desc LIMIT 100");	
	*/
	/* This sequel below is for New York Times 	
	
	$result = mysql_query("SELECT section,title,abstract,source,url,updated_date,url_hash FROM ptwigger_news.articles a WHERE source='The New York Times' and(section='Business Day' or section='Business' or section='Technology' or section='Sports' or section='Science' or section='Health' or section='Travel') group by title order by updated_date desc LIMIT 100");
	*/	

	/* This sequel below is for everything. 
	
	$result = mysql_query("SELECT section,title,abstract,url,updated_date,url_hash,source FROM ptwigger_news.articles a WHERE section='Business Day' or section='Business' or section='World' or section='U.S.' or section='Travel' or section='Technology' or section='Style' or section='Fashion & Style' or section='Sports' or section='Science' or section='N.Y. / Region' or section='Health' or section='Dining & Wine' or section='Arts' order by updated_date DESC LIMIT 100"); 
	*/
	
	/* Business Week 
	$result = mysql_query("SELECT section,title,abstract,source,url,updated_date,url_hash FROM ptwigger_news.articles a WHERE source='Business Week' and(section='Business Day' or section='Business' or section='Technology' or section='Sports' or section='Science' or section='Health' or section='Travel') group by title order by updated_date desc LIMIT 100"); */

// Image for NYT Logo: <img src='../images/icons/nytimes_transparent_icon.png' height='15 px' width='15 px' style='float:left; padding-right:15px; padding-top:2 px;' />
	$rows = array();
		while($r = mysql_fetch_assoc($result)) {
		$rows[] = $r;
	}
	print json_encode($rows);

	// while ($row = mysql_fetch_array($result))
	// {
	// 	$iso_date = date("c", strtotime($row['updated_date']));
		
	// 	echo "<div onclick=" . "loadArticle('" . $row['url_hash'] . "') class='newsItem span-12 left'>";
	// 	echo "<h2 class=" . $row['section'] . ">" . $row['section'] . "</h2>";
	// 	echo "<p class='title'>" . $row['title'] . "</p>";
	// 	echo "<p class='abstract'>" . $row['abstract'] . "</p>";
	// 	echo "<p class='update_date' title='" . $iso_date . "'>" . $iso_date . "</abbr>";
	// 	echo "<p class='url'><a href=" . $row['url'] . "> Source: " . $row['source'] . "</a> </div>";
	// }
	
	mysql_close($con);
?>