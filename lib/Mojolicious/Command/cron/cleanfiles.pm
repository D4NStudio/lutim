package Mojolicious::Command::cron::cleanfiles;
use Mojo::Base 'Mojolicious::Command';
use LutimModel;
use Mojo::Util qw(slurp decode);
use Mojolicious::Plugin::Config;

has description => 'Delete expired files.';
has usage => sub { shift->extract_usage };

sub run {
    my $c = shift;

    my $config = Mojolicious::Plugin::Config->parse(decode('UTF-8', slurp 'lutim.conf'), 'lutim.conf');

    my $time = time();
    my @images = LutimModel::Lutim->select('WHERE enabled = 1 AND (delete_at_day * 86400) < (? - created_at) AND delete_at_day != 0', $time);

    for my $image (@images) {
        $image->update(enabled => 0);
        unlink $image->path();
    }
}

=encoding utf8

=head1 NAME

Mojolicious::Command::cron::cleanfiles - Delete expired files

=head1 SYNOPSIS

  Usage: script/lutim cron cleanfiles

=cut

1;