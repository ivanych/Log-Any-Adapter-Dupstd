package Log::Any::Adapter::Duperr;

#
# Cunning adapter for logging to a duplicate of STDERR
#

use 5.008001;
use strict;
use warnings;
use utf8::all;

use Log::Any::Adapter::Util ();

use base qw/Log::Any::Adapter::Base/;

our $VERSION = '0.01';

#---

# Duplicate STDERR
open( my $duperr, '>&', STDERR ) or die "Can't dup STDERR: $!";

sub init {
    my ($self) = @_;

    if ( exists $self->{log_level} ) {
        $self->{log_level} = Log::Any::Adapter::Util::numeric_level( $self->{log_level} )
            unless $self->{log_level} =~ /^\d+$/;
    }
    else {
        $self->{log_level} = Log::Any::Adapter::Util::numeric_level('trace');
    }
}

foreach my $method ( Log::Any::Adapter::Util::logging_methods() ) {
    no strict 'refs';    ## no critic (ProhibitNoStrict)

    my $method_level = Log::Any::Adapter::Util::numeric_level($method);

    *{$method} = sub {
        my ( $self, $text ) = @_;

        return if $method_level > $self->{log_level};

        # Message output on $duperr instead of STDERR
        print $duperr "$text\n";
    };
}

foreach my $method ( Log::Any::Adapter::Util::detection_methods() ) {
    no strict 'refs';    ## no critic (ProhibitNoStrict)

    my $base = substr( $method, 3 );

    my $method_level = Log::Any::Adapter::Util::numeric_level($base);

    *{$method} = sub {
        return !!( $method_level <= $_[0]->{log_level} );
    };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Duperr - Cunning adapter for logging to a duplicate of STDERR


=head1 SYNOPSIS

    use Log::Any::Adapter ('Duperr');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('Duperr');
     
    # with minimum level 'warn'
     
    use Log::Any::Adapter ('Duperr', log_level => 'warn' );


=head1 DESCRIPTION

Адаптер Duperr предназначен для логирования сообщений в дубликат стандартного дескриптора STDERR.

Логирование в дубликат стандартного дескриптора может понадобиться в особых случях,
когда вам требуется переопределить или даже закрыть стандартный дескриптор,
но при этом вы хотите продолжать выводить сообщения туда, куда они выводились бы стандартным дескриптором. Подробнее см. Dupstd.

Этот адаптер работает аналогично простому адаптеру из дистрибутива Log::Any - 
Stderr (за исключением того, что внутри используется дубль дескриптора).


=head1 SEE ALSO

L<Log::Any|Log::Any>, L<Log::Any::Adapter|Log::Any::Adapter>, L<Log::Any::For::Std|Log::Any::For::Std>

=head1 AUTHORS

=over 4

=item *

Mikhail Ivanov <m.ivanych@gmail.com>

=item *

Anastasia Zherebtsova <zherebtsova@gmail.com> - translation of documentation
into English

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Mikhail Ivanov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
