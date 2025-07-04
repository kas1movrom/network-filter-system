# Требования к системе фильтрации трафика

## Функциональные требования

### Управление правилами фильтрации
- [ ] Пользователь должен иметь возможность:
  - Создавать, просматривать, изменять и удалять правила фильтрации трафика через веб-интерфейс
  - Задавать временные интервалы для созданных правил
  - Использовать:
    - Белые списки (запрещено всё, что явно не разрешено)
    - Черные списки (разрешено всё, что явно не запрещено)

### Критерии создания правил
- [ ] Поддержка создания правил на основе:
  - IP-адреса источника/назначения
  - Протокола
  - Порта источника/назначения
  - DNS-имени
  - URL ресурса
  - Типа контента
  - Страны источника/назначения (GeoIP)

### Работа с HTTP-прокси
- [ ] Возможность включения/выключения режима HTTP-прокси системы

### Поиск и просмотр
- [ ] Система должна предоставлять:
  - Поиск существующих правил
  - Просмотр текущих настроек системы (для администратора)

### Структура хранения данных
- [ ] Система должна хранить правила в отдельных таблицах БД:
  - Правила на основе GeoIP-фильтрации
  - Правила на основе HTTP-запросов
  - Правила на основе метаданных пакетов

### Взаимодействие с агентом
- [ ] Агент должен:
  - Получать актуальный список правил + глобальную конфигурацию через API
  - Интерпретировать правила с учетом текущей конфигурации и актуальной GeoIP базы
  - Включать модули:
    - Пакетной фильтрации трафика
    - Работы в прокси-режиме
    - Формирования/отправки API-запросов
    - Обработки ответов
    - Интерпретации правил
    - Логирования

### Обновления
- [ ] Система должна поддерживать:
  - Регулярное автоматическое обновление GeoIP базы
  - Автоматическое обновление правил у агента

### Логирование
- [ ] Система должна логировать:
  - Все действия администратора (время, пользователь, действие, результат)
  - Все обращения агента к API и применение правил

## Нефункциональные требования

### Производительность и масштабируемость
- [ ] Поддержка ≥100 активных правил фильтрации
- [ ] Работа без простоев при горизонтальном масштабировании
- [ ] Сохранение работоспособности при ошибках в фоновых задачах (использование последней валидной конфигурации)

### Развертывание
- [ ] Поддержка запуска:
  - Внутри контейнеров
  - На bare-metal серверах
- [ ] Поддержка ОС:
  - Ubuntu LTS 22.04+
  - CentOS Stream 7+

### Безопасность
- [ ] Обязательная аутентификация в веб-интерфейсе и API (JWT-токен)
- [ ] Шифрование учетных данных в Ansible-плейбуках (Ansible Vault)
- [ ] Валидация всех действий пользователя

### Отказоустойчивость
- [ ] Поддержка репликации БД правил
- [ ] Возможность отката к предыдущей рабочей конфигурации

### Интерфейсы
- [ ] Веб-интерфейс управления
- [ ] REST API для взаимодействия с агентом