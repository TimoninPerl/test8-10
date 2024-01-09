use strict;
use warnings;
use lib 'D:\Perl';
use tools; # пакет с функциями

# Получение параметров командной строки
my ( $action, $user_name, $user_password ) = @ARGV;

# Вывод справки по использованию скрипта
sub _print_help {
    print "######################################################
    Usage:
    action=reg user_name=NAME user_passwd=PASSWD ./back_end.pl           - Registration new user in system;
    action=log user_name=NAME user_passwd=PASSWD ./back_end.pl           - Login in system;
    action=del user_name=NAME ./back_end.pl                              - Remove user from system;
    action=change_passwd user_name=NAME user_passwd=PASSWD ./back_end.pl - Change user password;
######################################################\n"
}

# Проверка введенного действия и соответствующих параметров
if ( !defined $action || ( $action ne 'log' && $action ne 'reg' && $action ne 'del' && $action ne 'change_passwd' )) {
    _print_help();
    exit;
}

if (( $action eq 'log' || $action eq 'reg' || $action eq 'change_passwd' ) && ( !defined $user_name || !defined $user_password )) {
    print "Для действия '$action' требуется имя пользователя и пароль.\n";
    _print_help();
    exit;
}

if ( $action eq 'del' && !defined $user_name ) {
    print "Для удаления пользователя требуется указать имя пользователя.\n";
    _print_help();
    exit;
}

# Проверка имени пользователя
sub _check_user_name {
    my $username = shift;
    if ( $username =~ /^[a-zA-Z][a-zA-Z0-9_-]*[a-zA-Z0-9]$/ ) {
        return "ok";
    } else {
        return "Имя пользователя не соответствует требованиям.";
    }
}

# Проверка пароля пользователя
sub _check_user_password {
    my $password = shift;
    if ( length( $password ) < 8 ) { return "Пароль должен быть не менее 8 символов."; }
    if ($password !~ /[!@#$%^&*()]/) { return "Пароль должен содержать хотя бы один спецсимвол (!@#$%^&*())."; }
    if ($password !~ /[A-Z]/) { return "Пароль должен содержать хотя бы одну заглавную латинскую букву."; }
    if ($password !~ /\d/) { return "Пароль должен содержать хотя бы одну цифру."; }
    if ($password !~ /^[A-Za-z]/) { return "Пароль должен начинаться с латинской буквы."; }
    return "ok";
}

# Выбор и выполнение действия на основе параметров командной строки
if ( $action eq 'log' ) {
    # Вызов функции логина
    my ( $status, $log_message ) = tools::login( $user_name, $user_password );
    print $log_message;
} elsif ($action eq 'reg') {
    # Проверка валидности введенных данных и регистрация
    my $username_valid = _check_user_name( $user_name );
    my $password_valid = _check_user_password( $user_password );
    if ( $username_valid eq "ok" && $password_valid eq "ok" ) {
        my ( $status, $reg_message ) = tools::reg_user( $user_name, $user_password );
        print $reg_message;
    } else {
        print "Ошибка логина: $username_valid\n" if $username_valid ne "ok";
        print "Ошибка пароля: $password_valid\n" if $password_valid ne "ok";
    }
} elsif ( $action eq 'del' ) {
    # Вызов функции удаления пользователя
    my ( $status, $del_message ) = tools::del_user( $user_name );
    print $del_message;
} elsif ( $action eq 'change_passwd' ) {
    # Проверка валидности пароля и смена пароля
    my $password_valid = _check_user_password( $user_password );
    if ( $password_valid eq "ok" ) {
        my ( $status, $chng_message ) = tools::change_passwd( $user_name, $user_password );
        print $chng_message;
    } else {
        print "Ошибка пароля: $password_valid\n";
    }
} else {
    # Вывод справки, если действие не поддерживается
    _print_help();
}
