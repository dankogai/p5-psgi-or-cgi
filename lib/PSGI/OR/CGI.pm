#
# $Id: CGI.pm,v 0.1 2010/09/09 07:31:27 dankogai Exp dankogai $
#
package PSGI::OR::CGI;
use warnings;
use strict;

our $VERSION = sprintf "%d.%02d", q$Revision: 0.1 $ =~ /(\d+)/g;

sub run {
    my $class = shift;
    my $app = shift;
    return $app unless $ENV{GATEWAY_INTERFACE};
    my $res = $app->( \%ENV );
    _respond($res);
}

sub _respond {
    my $res = shift;
    print "Status: ", $res->[0], "\n";
    while ( my ( $k, $v ) = splice @{ $res->[1] }, 0, 2 ) {
        print "$k: $v\n";
    }
    print "\n";
    if ( ref( my $fd = $res->[2][0] ) ) {
        print while <$fd>;
        close $fd;
    }
    else {
        print join "\n", @{ $res->[2] };
    }
}

1; # End of PSGI::OR::CGI
__END__

=head1 NAME

PSGI::OR::CGI - Write a PSGI app that also runs as CGI

=head1 VERSION

$Id: CGI.pm,v 0.1 2010/09/09 07:31:27 dankogai Exp dankogai $

=head1 SYNOPSIS

  #!/usr/bin/env perl
  # printenv.(psgi|cgi)
  use strict;
  use warnings;
  use Data::Dumper;
  use PSGI::OR::CGI;
  
  my $app = sub {
    my $env = shift;
    return [ 200, [ 'Content-Type' => 'text/plain' ], [ Dumper($env) ] ];
  };
  
  PSGI::OR::CGI->run($app);

=head1 EXPORT

None.

=head1 METHODS

=head2 PSGI::OR::CGI->run($app)

If CGI, prints response accordingly to L<PSGI>.
If PSGI, immediately returns C<$app>

It checks the presense of C<$ENV{GATEWAY_INTERFACE}> to check if the
script is invoked as PSGI or CGI (or mod_perl Registry which also sets
this environment variable).

=head1 AUTHOR

Dan Kogai, C<< <dankogai+cpan at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-psgi-or-cgi at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=PSGI-OR-CGI>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc PSGI::OR::CGI

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=PSGI-OR-CGI>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/PSGI-OR-CGI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/PSGI-OR-CGI>

=item * Search CPAN

L<http://search.cpan.org/dist/PSGI-OR-CGI/>

=back

=head1 ACKNOWLEDGEMENTS

L<PSGI>, L<PLACK>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Dan Kogai.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
