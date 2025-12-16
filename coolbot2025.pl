#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";  # Добавляем путь к библиотекам

use Coolbot;

# Конфигурация
my $token = '8474961966:AAHuWDs8BCJXyve2YwAbg-M4PztGg_7SeFk';

# Создаем и запускаем бота
my $bot = Coolbot->new(
    token => $token
);

warn "🚀 Запускаем бота...\n";
warn "Токен: " . substr($token, 0, 10) . "...\n";
warn "Бот запущен в " . localtime() . "\n";

$bot->think;  # Запускаем главный цикл