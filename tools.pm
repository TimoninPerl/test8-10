package tools;
use strict;
use warnings;

# Путь к файлу конфигурации с логинами и паролями
my $config_path = "D:\\Perl\\conf.ini";

# функция для чтения конфигурационного файла
sub _read_config {
    my %config;
    if ( open my $fh, '<', $config_path ) {
        while ( my $line = <$fh> ) {
            chomp $line;
            my ( $user, $pass ) = split ( /:/, $line );
            $config{$user} = $pass if $user && $pass; # Заполняем хеш, только если есть и ключ и значение
        }
        close $fh;
    } else {
        warn "Не удалось открыть файл '$config_path'\n";
    }
    return %config;
}
# функция для проверки логина и пароля
sub login {
    my ( $user_name, $user_password ) = @_;
    my %users = _read_config();

    if ( $users{$user_name} && $users{$user_name} eq $user_password ) {
        print "Добро пожаловать, $user_name!\n";
    } else {
        print "Неверный логин или пароль.\n";
    }
}
# функция для регистрации нового пользователя
sub reg_user {
    my ( $username, $password ) = @_;
    my %users = _read_config( $config_path );

    if ( exists $users{$username} ) {
        print "Пользователь с таким логином уже зарегистрирован.\n";
        return;
    }
	
    $users{$username} = $password;  # Добавляем пользователя
    _rewrite_config( %users );
    print "Пользователь $username успешно зарегистрирован.\n";
}
# функция для перезаписи файла с данными пользователей
sub _rewrite_config {
    my ( %users ) = @_;
    open my $fh, '>', $config_path or die "Не удалось открыть файл '$config_path': $!";
    foreach my $user ( keys %users ) {
        print $fh "$user:$users{$user}\n";
    }
    close $fh;
}
#функция для удаления пользователя
sub del_user {
    my $username = shift; 
    my %users = _read_config($config_path); 

    if (exists $users{$username}) {
        delete $users{$username}; 
        _rewrite_config(%users); 
        print "Пользователь $username успешно удален.\n";
    } else {
        print "Пользователь с именем $username не найден.\n";
    }
}
1;
