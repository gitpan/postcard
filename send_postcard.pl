#!/usr/bin/perl
#
#	Processes the data from the form and sends a postcard to
#	the recipient.
###############################

$cardfile="cardfile";
require 'httools.pl';
&form_parse;

%messages=(
'ky_pic1.gif', 'A traditional stone fence on highway 68',
'ky_pic2.gif', 'A traditional stone fence on highway 68',
'ky_pic3.gif', 'A horses head',
);

$FORM{'message'} =~s/\n/<br>/g;
$FORM{'message'} =~s/\r//g;

&word; # Generate a random word.
&save; # Save the information to a file
&send; # Send the message to the recipient
&page; # Print the html page.

sub word	{
#
#  Generate a random name 

srand(time||$$);
for ($char=1; $char<=8; $char++)	{
$letter=pack("c", (int(rand(23)+65)));
$word .= $letter;			}

# print $word;
			}

sub save	{
#  Writes the postcard information to a file

&todayjulean;
open (FILE, ">>$cardfile");
print FILE "$word~~~$FORM{'from'} ($FORM{'replyto'})~~~$FORM{'picture'}~~~$FORM{'message'}~~~$today\n";
		}

sub send	{
$SENDMAIL='/usr/lib/sendmail';  # This is the location of the           
                                # sendmail program on your system       

open (MAIL, "| $SENDMAIL $FORM{'mail'}");

print MAIL "Reply-to: $FORM{'replyto'}\n";
print MAIL "From: $FORM{'from'}\n";
print MAIL "To: $FORM{'mail'}\n";
print MAIL "Subject: A Postcard!\n\n";
print MAIL "========================================================\n";
print MAIL "You have a postcard from $FORM{'from'}. ($FORM{'replyto'}\n";
print MAIL "  To retreive this postcard\n";
print MAIL "point your web browser at\n";
print MAIL "http://www.rcbowen.com/scripts/post/get_postcard.pl\n";
print MAIL "The word you will need to use to get it is $word\n";
print MAIL "Your postcard will be thrown out in two weeks if\n";
print MAIL "you have not got it by then.\n\n";
print MAIL "Sincerely, the folks at http://www.rcbowen.com/ \n\n";
close MAIL;
		}


sub page	{
&header;
&title ("Message sent");

print <<ENDOFPAGE;

<h2>Message sent!</h2>
Your postcard has been sent to $FORM{'mail'}.<br>
Your message will expire in two weeks, so make sure that they have got it by then!<br>
Your postcard will look like this:<hr>
<h3>$messages{$FORM{'picture'}}</h3><br clear=all>
<img hspace=10 vspace=10 src=/scripts/post/images/$FORM{'picture'} align=left>
FROM: $FORM{'from'} <hr>
$FORM{'message'}<br clear=left><hr>

Have a look at my awesome <a href=http://www.rcbowen.com/>website</a>, or, send a <a href=/scripts/post/postcard.html>postcard to someone else.<br>
<hr>
<center>
[ <a href="http://www.rcbowen.com/">My Home Page</a> | <a href="http://www.rcbowen.com/perl/">My Perl Stuff</a> | <a href="/scripts/post/postcard.html">Send a postcard</a> ]
</center>
</body>
ENDOFPAGE

print "</html>";}
