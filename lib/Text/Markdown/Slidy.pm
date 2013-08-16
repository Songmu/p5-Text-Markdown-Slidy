package Text::Markdown::Slidy;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";
use parent 'Exporter';
use Text::Markdown::Discount ();

our @EXPORT = qw/markdown/;

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
    $self->{md} ||= do {
        Text::Markdown::Discount::with_html5_tags;
        Text::Markdown::Discount->new;
    };

    my @slides;
    for my $slide (_split_slides($text)) {
        my $html  = $self->{md}->markdown($slide);
        my $open  = sprintf qq{<%s class="%s">\n}, $self->slide_element, $self->slide_class;
        my $close = sprintf "</%s>\n", $self->slide_element;
        push @slides, "$open$html$close";
    }
    join "\n", @slides;
}

sub slide_element {
    shift->{slide_element} ||= 'div';
}

sub slide_class {
    shift->{slide_class} ||= 'slide';
}

sub _split_slides {
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

