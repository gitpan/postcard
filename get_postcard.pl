#!/usr/bin/perl
#
#	Get the postcard, based on the "user name"
# The user will already have their secret code-word, which they
# will type in.  When this is entered, it will be returned to
# the second line in the program which will find the appropriate
# line in the "cardfile" and build the postcard for them.
########################################
require 'httools.pl';
&form_parse;
%messages = (
'ky_pic1.gif', 'A traditional stone fence on highway 68',
'ky_pic2.gif', 'A traditional stone fence on highway 68',
);

$word=$FORM{'word'};
if ($word eq "") {&get_word} else {&show_card};

sub get_word	{
#  Print html page requesting "password"
########################################

print <<ENDPAGE;
content-type: text/html \n\n

<html>
<head><title>Enter your code word</title></head>
<body>
Enter the code word from your e-mail message to view your postcard:<br>
<hr>
<form method=post action=/scripts/post/get_postcard.pl>
<input name=word size=10><br>
<input type=submit value="See postcard"><br>
</form>
<hr>
</body>
</html>
ENDPAGE
}

sub show_card	{

open (CARDS, "/home2/rbowen/public_html/scripts/post/cardfile");
@cards=<CARDS>;
$found=0;

foreach $card (@cards)	{
($pass,$from,$picture,$message,$date)=split(/~~~/,$card);
if ($pass eq $word)	{
	$found=1;
	last;		}
			}

if ($found)	{
# print the postcard for the user to see
print <<ENDCARD;
content-type: text/html \n\n

<html>
<head><title>Postcard</title></head>
<body>
<hr>
<h3>$messages{$picture}</h3><br clear=all>
<img hspace=10 vspace=10 align=left src=/scripts/post/images/$picture >
FROM: $from<br>
<hr>
$message<br clear=left>
<hr>
This postcard brought to you courtesy of <a href=http://www.rcbowen.com/>Rich Bowen</a>, providing custom CGI programming, and other cool stuff.<br>
  Please <a href=postcard.html>send a postcard</a> to someone else!<br>
<hr>
[ <a href="/">Rich's Home Page</a> | <a href="/perl">Rich's Perl Stuff</a> | <a href="/scripts/post/postcard.html">Send a postcard</a> ]
<hr>
</body></html>
ENDCARD
}
else	{
# User name was not found in the file
print <<ENDNOCARD;
content-type: text/html \n\n


<html>
<head><title>Not found</title></head>
Sorry - Either you mistyped the code word, or you waited too long to retreive your postcard.  We only keep them around for two weeks if they are not delivered.<br>
You could <a href=/cgi-bin/games/get_postcard>Try again</a>.<br>
This postcard service is brought to you by <a href=/index.html>AiC</a>.
Please <a href=/images/ky_photos/postcards.html>send a postcard</a> to someone else!<br>
<hr>
</body></html>
ENDNOCARD
	}
}
