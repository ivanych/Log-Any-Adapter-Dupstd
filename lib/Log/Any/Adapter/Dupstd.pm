package Log::Any::Adapter::Dupstd;

#
# Cunning adapter for logging to a duplicate of STDERR or STDOUT
#

use 5.008001;
use strict;
use warnings;
use utf8::all;

our $VERSION = '0.01';

#---

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Dupstd - Cunning adapter for logging to a duplicate of STDERR or STDOUT


=head1 SYNOPSIS

    # Log to a duplicate of stderr or stdout

    use Log::Any::Adapter ('Duperr');
    use Log::Any::Adapter ('Dupout');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('Duperr');
    Log::Any::Adapter->set('Dupout');
     
    # with minimum level 'warn'
     
    use Log::Any::Adapter ('Duperr', log_level => 'warn' );
    use Log::Any::Adapter ('Dupout', log_level => 'warn' );


=head1 DESCRIPTION

Адаптеры Dupstd предназначены для логирования сообщений в дубликаты стандартных дескрипторов STDERR и STDOUT.

Логирование в дубликат стандартного дескриптора может понадобиться в особых случях,
когда вам требуется переопределить или даже закрыть стандартный дескриптор,
но при этом вы хотите продолжать выводить сообщения туда, куда они выводились бы стандартным дескриптором.

Например, ваш скрипт печатает что-то в STDERR, а вы хотите перенаправить это сообщение в файл.
Если вы перенаправите STDERR в файл, то вы заодно перенаправите туда же предупреждения warn и даже исключения die.
Но это не всегда удобно. Во многих случаях удобнее, когда предупреждения и исключения выводятся на экран.

    # Перенаправить STDERR в файл
    open(STDERR, '>', 'stderr.txt');

    # Это сообщение уйдет в файл, а не на экран (вы этого хотите)
    print STDERR 'Some message';
    
    # Это предупреждение тоже уйдет в файл (а вот этого вы не хотите)
    warn('Warning!');

Вы можете попробовать вывести предупреждение или исключение на экран самостоятельно, с помощью адаптера Stderr из дистрибутива Log::Any.
Но адаптер Stderr печатает сообщение на STDERR, поэтому сообщение все-равно окажется в файле, а не на экране.

    # Перенаправить STDERR в файл
    open(STDERR, '>', 'stderr.txt')

    # Это сообщение уйдет в файл, а не на экран (вы этого хотите)
    print STDERR 'Some message';

    # Адаптер Stderr
    Log::Any::Adapter->set('Stderr');

    # Упс, предупреждение уйдет в файл (опять не то, чего ожидали)
    $log->warning('Warning!')

Вы можете вывести предупреждение на экран с помощью адаптера Stdout, который также входит в дистрибутив Log::Any.
Предупреждение будет выведено на экран, как и ожидалось, но это будет "не настоящее" предупреждение, потому что оно будет выведено через STDOUT.
Такое "предупреждение" нельзя будет отфильтровать в шелле.

    # Это не будет работать!
    $ script.pl 2> error.log

Вот в такой ситуации и нужны адаптеры Dupstd. Предупреждения и исключения, отправленные с помощью этих адаптеров, будут "настоящими".
Их можно будет отфильтровать в шелле, точно также, как если бы они были отправлены на обычный STDERR.

    # Перенаправить STDERR в файл
    open(STDERR, '>', 'stderr.txt')

    # Это сообщение уйдет в файл, а не на экран (вы этого хотите)
    print STDERR 'Some message';

    # Адаптер Duperr
    Log::Any::Adapter->set('Duperr');

    # Предупреждение будут выведено на экран (то, что нужно)
    $log->warning('Warning!')


=head1 ADAPTERS

В этом дистрибутиве находятся два хитрых адаптера - Duperr and Dupout.

Эти адаптеры работают аналогично простым адаптерам из дистрибутива Log::Any - 
Stderr and Stdout (за исключением того, что внутри используются дубли дескрипторов).


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
