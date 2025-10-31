# meta cpan пример с сайта

            
              
package MyApp::Coolbot;
use Mojo::Base 'Telegram::Bot::Brain';

has token => '7875983729:AAH7Cs7B304_-6K8CrADjOI-pfxlP3O8nXw';

sub init {
    my $self = shift;
    $self->add_repeating_task(600, sub { $self->timed_task });
    $self->add_listener(\&respond_to_messages);
}

sub timed_task {
    my $self = shift;
    
    # Просто логируем выполнение задачи
    warn "🕒 Timed task executed at: " . localtime() . "\n";
    
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
        warn "Получен chat_id: $chat_id\n";
        # Можно сохранить куда-то для дальнейшего использования
    }
}

my $bot = MyApp::Coolbot->new();
$bot->think;