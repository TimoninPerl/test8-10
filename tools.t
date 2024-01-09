use strict;
use warnings;
use Test::More tests => 9; # Общее количество тестов
use lib 'D:\Perl';
use tools;

# Переменные для тестов
my $test_config_path = "D:\\Perl\\test_conf.ini";
my $test_user = "testuser";
my $test_pass = "TestPass123!";
my $new_pass = "NewPass123!";
my $wrong_user = "wronguser";
my $wrong_pass = "wrongpass";

# Тесты для _read_config
sub test_read_config {
    my %config = tools::_read_config( $test_config_path );
    ok(%config, '_read_config should return a non-empty hash');
}
test_read_config();

# Тесты для reg_user - Регистрация нового пользователя
sub test_reg_user {
    my ( $status, $message ) = tools::reg_user( $test_user, $test_pass );
    ok( $status == 1, 'reg_user should succeed for new user: ' . $message );
    
    ( $status, $message ) = tools::reg_user( $test_user, $test_pass );
    ok( $status == 0, 'reg_user should fail for existing user: ' . $message );
}
test_reg_user();

# Тесты для login - Вход в систему
sub test_login {
    my ( $status, $message ) = tools::login( $test_user, $test_pass );
    ok( $status == 1, 'login with correct credentials should succeed: ' . $message );
    
    ( $status, $message ) = tools::login( $wrong_user, $wrong_pass );
    ok( $status == 0, 'login with wrong credentials should fail: ' . $message );
}
test_login();

# Тесты для change_passwd - Изменение пароля
sub test_change_passwd {
    my ( $status, $message ) = tools::change_passwd( $test_user, $new_pass );
    ok( $status == 1, 'change_passwd should succeed for existing user: ' . $message );
    
    ( $status, $message ) = tools::change_passwd( $wrong_user, $new_pass );
    ok( $status == 0, 'change_passwd should fail for non-existing user: ' . $message );
}
test_change_passwd();

# Тесты для del_user - Удаление пользователя
sub test_del_user {
    my ( $status, $message ) = tools::del_user( $test_user );
    ok( $status == 1, 'del_user should succeed for existing user: ' . $message );
    
    ( $status, $message ) = tools::del_user( $wrong_user );
    ok( $status == 0, 'del_user should fail for non-existing user: ' . $message );
}
test_del_user();
