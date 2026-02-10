package Coolbot2026;
use Mojo::Base 'Telegram::Bot::Brain';

has 'token';

sub init {
    my $self = shift;
    $self->add_repeating_task(600, sub { $self->timed_task });
    $self->add_listener(\&respond_to_messages);
}

sub timed_task {
    my $self = shift;
    warn "Timed task executed at: " . localtime() . "\n";
}

sub respond_to_messages {
    my ($self, $message) = @_;

    if ($message) {
        my $chat_id = $message->chat->id;
        my $text = $message->text || '';
        my $from = $message->from;
        my $username = $from ? $from->username : 'unknown';

        warn "Сообщение от пользователя $username: $text\n";
        warn "Chat ID: $chat_id\n";

        if ($text =~ /^\/start/) {
            # Создаем клавиатуру с 4 кнопками
            my $keyboard = {
                keyboard => [
                    [
                        { text => '📊 Статус' },
                        { text => '🆘 Помощь' }
                    ],
                    [
                        { text => '⚙️ Настройки' },
                        { text => '📞 Контакты' }
                    ]
                ],
                resize_keyboard => 1,
                one_time_keyboard => 0
            };

            $self->bot->sendMessage({
                chat_id => $chat_id,
                text => "Привет! Я бот. Выберите действие:",
                reply_markup => $keyboard,
                parse_mode => 'HTML'
            });

        } elsif ($text =~ /^\/status|^📊 Статус/) {
            $self->bot->sendMessage({
                chat_id => $chat_id,
                text => "Бот работает нормально. Время: " . localtime(),
                parse_mode => 'HTML'
            });

        } elsif ($text =~ /^\/help|^🆘 Помощь/) {
            my $help_text = "<b>📚 Доступные команды и кнопки:</b>\n\n" .
                           "• <b>📊 Статус</b> - проверка работы бота\n" .
                           "• <b>🆘 Помощь</b> - это сообщение\n" .
                           "• <b>⚙️ Настройки</b> - настройки бота\n" .
                           "• <b>📞 Контакты</b> - контактная информация\n\n" .
                           "<i>Также можно использовать команды:</i>\n" .
                           "/start - Главное меню\n" .
                           "/status - Статус бота\n" .
                           "/help - Справка";

            $self->bot->sendMessage({
                chat_id => $chat_id,
                text => $help_text,
                parse_mode => 'HTML'
            });

        } elsif ($text =~ /^⚙️ Настройки/) {
            $self->bot->sendMessage({
                chat_id => $chat_id,
                text => "<b>⚙️ Настройки бота:</b>\n\n" .
                       "• Интервал уведомлений: 10 минут\n" .
                       "• Язык: Русский\n" .
                       "• Уведомления: Включены\n\n" .
                       "<i>Настройки можно изменить в конфигурации</i>",
                parse_mode => 'HTML'
            });

        } elsif ($text =~ /^📞 Контакты/) {
            # ИСПРАВЛЕНО: Разделил строку чтобы избежать интерполяции
            $self->bot->sendMessage({
                chat_id => $chat_id,
                text => "<b>📞 Контактная информация:</b>\n\n" .
                       "• Поддержка: support_username\n" .        # Без @
                       "• Сайт: example.com\n" .
                       "• Email: bot" . "@" . "example.com\n\n" . # Разделил строку
                       "<i>Пишите по любым вопросам!</i>",
                parse_mode => 'HTML'
            });
        }
    }
}

1;