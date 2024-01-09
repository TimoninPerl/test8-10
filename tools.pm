package tools;
use strict;
use warnings;

# Путь к файлу конфигурации с логинами и паролями
my $config_path = "D:\\Perl\\conf.ini";

# функция для чтения конфигурационного файла
sub _read_config {
    my %config;
    if ( open my $fh, '<', $config_path ) {
        while (my $line = <$fh>) {
            chomp $line;
            my ( $user, $pass ) = split( /:/, $line );
            $config{$user} = $pass if $user && $pass;
        }
        close $fh;
        return %config;
    } else {
        warn "Не удалось открыть файл '$config_path'\n";
        return ();  # Явно возвращаем пустой хеш
    }
}

# функция для проверки логина и пароля
sub login {
    my ( $user_name, $user_password ) = @_;
    my %users = _read_config();

    if ( $users{$user_name} && $users{$user_name} eq $user_password ) {
		return ( 1, "Добро пожаловать, $user_name!\n" );  # Успех
    } else {
		return ( 0, "Неверный логин или пароль.\n" );  # Неудача
    }
}

# функция для регистрации нового пользователя
sub reg_user {
    my ( $username, $password ) = @_;
    my %users = _read_config( $config_path );

    if ( exists $users{$username} ) {
        return ( 0, "Пользователь с таким логином уже зарегистрирован.\n" );
    }
	
    $users{$username} = $password;
    _rewrite_config( %users );
    return ( 1, "Пользователь $username успешно зарегистрирован.\n" );
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
    my %users = _read_config( $config_path ); 

    if (exists $users{$username}) {
        delete $users{$username}; 
        _rewrite_config(%users); 
        return ( 1, "Пользователь $username успешно удален.\n");
    } else {
        return ( 0, "Пользователь с именем $username не найден.\n");
    }
}
#функция для смены пароля
sub change_passwd {
    my ( $username, $new_password ) = @_;
    my %users = _read_config();

    if ( exists $users{$username} ) {
            $users{$username} = $new_password; 
            _rewrite_config( %users );  
            return ( 1, "Пароль успешно изменен для пользователя $username.\n");
    } else {
        return ( 0, "Пользователь $username не найден.\n");
    }
}
1;
