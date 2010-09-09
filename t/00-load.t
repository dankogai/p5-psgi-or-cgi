#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'PSGI::OR::CGI' ) || print "Bail out!
";
}

diag( "Testing PSGI::OR::CGI $PSGI::OR::CGI::VERSION, Perl $], $^X" );
