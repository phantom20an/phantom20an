#!/usr/bin/env perl, исполняемый файл, это переименованный perl_bot_tbb2_ex.pl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";  # Добавляем путь к библиотекам

use MyApp::Coolbot;

# Конфигурация
my $token = '7875983729:AAH7Cs7B304_-6K8CrADjOI-pfxlP3O8nXw';

# Создаем и запускаем бота
my $bot = MyApp::Coolbot->new(
    token => $token
);

warn "🚀 Запускаем бота...\n";
warn "Токен: " . substr($token, 0, 10) . "...\n";
warn "Бот запущен в " . localtime() . "\n";

$bot->think;  # Запускаем главный цикл