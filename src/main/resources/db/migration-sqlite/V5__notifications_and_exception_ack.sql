-- SQLite 异常确认与通知表
CREATE TABLE xianyu_exception_acknowledgement (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    exception_type VARCHAR(32) NOT NULL,
    source_id INTEGER NOT NULL,
    source_version INTEGER NOT NULL,
    handled_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id, exception_type, source_id, source_version)
);

CREATE TABLE xianyu_notification_channel (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    channel_name VARCHAR(100) NOT NULL,
    webhook_url VARCHAR(1000) NOT NULL,
    signing_secret VARCHAR(200),
    event_types VARCHAR(500) NOT NULL,
    enabled INTEGER NOT NULL DEFAULT 1,
    last_success_time DATETIME,
    last_error_message VARCHAR(500),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xianyu_notification_log (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    channel_id INTEGER,
    event_type VARCHAR(50) NOT NULL,
    xianyu_account_id INTEGER,
    title VARCHAR(200) NOT NULL,
    send_status INTEGER NOT NULL,
    http_status INTEGER,
    error_message VARCHAR(500),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (channel_id) REFERENCES xianyu_notification_channel (id) ON DELETE SET NULL
);
