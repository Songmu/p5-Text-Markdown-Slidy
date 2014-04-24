package Text::Markdown::Slidy;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";
use parent 'Exporter';

our @EXPORT = qw/markdown separate_markdown/;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

sub markdown {
    my ($self, $text) = @_;

    # Detect functional mode, and create an instance for this run
    unless (ref $self) {
        if ( $self ne __PACKAGE__ ) {
            my $ob = __PACKAGE__->new();
                                # $self is text, $text is options
            return $ob->markdown($self, $text);
        }
        else {
            croak('Calling ' . $self . '->markdown (as a class method) is not supported.');
        }
    }
    my @slides = $self->_sections($text);
    join "\n", @slides;
}

sub template {
    my $self = shift;

    $self->{template} ||= qq[<div class="slide">\n%s</div>\n];
}

sub md {
    my $self = shift;

    $self->{md} ||= do {
        require Text::Markdown;
        Text::Markdown->new;
    };
}

sub _process {
    my ($self, $slide_text) = @_;

    my $html  = $self->md->markdown($slide_text);
    sprintf $self->template, $html;
}

sub _sections {
    my ($self, $text) = @_;

    map {$self->_process($_)} separate_markdown($text);
}

sub separate_markdown {
    my $text = shift;
    $text =~ s/^\A\s+//ms;
    $text =~ s/\s+\z//ms;

    my @slides;
    my @slide_lines;
    my $prev;
    for my $line (split /\r?\n/, $text) {
        if ( $line =~ /^(?:(?:-+)|(?:=+))$/ && $prev) {
            pop @slide_lines;
            push @slides, join("\n", @slide_lines) if @slide_lines;
            @slide_lines = ($prev); # $prev is title;
        }
        push @slide_lines, $line;
        $prev = $line;
    }
    push @slides, join("\n", @slide_lines) if @slide_lines;

    @slides;
}

1;
__END__

=encoding utf-8

=head1 NAME

Text::Markdown::Slidy - It's new $module

=head1 SYNOPSIS

    use Text::Markdown::Slidy;

=head1 DESCRIPTION

Text::Markdown::Slidy is ...

=head1 LICENSE

Copyright (C) Masayuki Matsuki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=cut

