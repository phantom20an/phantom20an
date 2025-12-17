# разделение файла на части, 1ч. Библиотека

package Coolbot;
use Mojo::Base 'Telegram::Bot::Brain';

# Токен теперь будет передаваться при создании объекта
has 'token';

sub init {
    my $self = shift;
    $self->add_repeating_task(600, sub { $self->timed_task });
    $self->add_listener(\&respond_to_messages);
}

sub timed_task {
    my $self = shift;
    
    # Просто логируем выполнение задачи
    warn "Timed task executed at: " . localtime() . "\n";
    
    # Можно делать другие действия без chat_id:
    # - Проверять API других сервисов
    # - Обновлять внутренние данные
    # - Делать логирование
    # - Очищать временные файлы
}

sub respond_to_messages {
    my ($self, $update) = @_;
    # Здесь можно получать chat_id из входящих сообщений
    my $message = $update->message;
    if ($message) {
        my $chat_id = $message->chat->id;
        my $text = $message->text || '';
        my $from = $message->from;
        my $username = $from ? $from->username : 'unknown';
        
        warn "Получено сообщение от @$username: $text\n";
        warn "Chat ID: $chat_id\n";
        
        # Автоответ на сообщения
        if ($text =~ /^start/) {
            $self->bot->sendMessage(
                chat_id => $chat_id,
                text    => "Привет! Я бот. Буду отправлять уведомления каждые 10 минут."
            );
        } elsif ($text =~ /^status/) {
            $self->bot->sendMessage(
                chat_id => $chat_id,
                text    => "Бот работает нормально. Время: " . localtime()
            );
        }
        
        
    }
}

1;  