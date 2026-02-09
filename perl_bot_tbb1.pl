#!/usr/bin/env perl

use strict;
use warnings;
use Telegram::Bot::Brain;
use Mojo::Base 'Telegram::Bot::Brain';
use JSON;

# Отключаем предупреждение о init
local $SIG{__WARN__} = sub {
    warn @_ unless $_[0] =~ /init was not overridden/;
};

# Создаем бота
my $bot = Telegram::Bot::Brain->new(
    token => '7875983729:AAH7Cs7B304_-6K8CrADjOI-pfxlP3O8nXw',
);

# Вместо использования встроенных обработчиков, реализуем свою логику
my $offset = 0;

while (1) {
    # Получаем обновления вручную
    my $updates = eval {
        $bot->ua->post(
            "https://api.telegram.org/bot" . $bot->token . "/getUpdates",
            Content => {
                offset  => $offset,
                timeout => 30,
            }
        );
    };

    unless ($updates && $updates->is_success) {
        warn "Ошибка получения updates: " . ($updates ? $updates->status_line : $@);
        sleep 5;
        next;
    }

    my $data = eval { decode_json($updates->decoded_content) };
    unless ($data && $data->{ok}) {
        warn "Ошибка API: " . ($data->{description} || 'Unknown error');
        next;
    }

    # Обрабатываем каждое обновление
    for my $update (@{$data->{result}}) {
        $offset = $update->{update_id} + 1;

        if (my $msg = $update->{message}) {
            my $chat_id = $msg->{chat}{id};
            my $text    = $msg->{text} || '';

            print "Получено: $text\n";

            # Обработка команд
            if ($text =~ m{^/start}i) {
                $bot->sendMessage({
                    chat_id => $chat_id,
                    text    => "🚀 Бот запущен! Используйте /help"
                });
            }
            elsif ($text =~ m{^/help}i) {
                $bot->sendMessage({
                    chat_id => $chat_id,
                    text    => "📋 Команды:\n/start\n/help\n/info\n/time"
                });
            }
            elsif ($text =~ m{^/info}i) {
                $bot->sendMessage({
                    chat_id => $chat_id,
                    text    => "🤖 Бот на Perl с Telegram::Bot::Brain"
                });
            }
            elsif ($text =~ m{^/time}i) {
                my $time = scalar localtime;
                $bot->sendMessage({
                    chat_id => $chat_id,
                    text    => "🕒 Время: $time"
                });
            }
            # Ответ на обычные сообщения
            elsif ($text ne '') {
                $bot->sendMessage({
                    chat_id => $chat_id,
                    text    => "Вы сказали: $text"
                });
            }
        }

        # Обработка callback_query
        if (my $callback = $update->{callback_query}) {
            my $data = $callback->{data};
            my $chat_id = $callback->{message}{chat}{id};

            print "Callback: $data\n";

            $bot->answerCallbackQuery({
                callback_query_id => $callback->{id},
                text              => "Обработано: $data"
            });
        }
    }

    # Небольшая пауза между запросами
    sleep 1;
}