-- SQLite 商家运营表与 WebSocket 同步字段
ALTER TABLE xianyu_account ADD COLUMN websocket_sync_pts INTEGER;
ALTER TABLE xianyu_account ADD COLUMN websocket_sync_seq INTEGER;
ALTER TABLE xianyu_account ADD COLUMN websocket_sync_timestamp INTEGER;

CREATE TABLE merchant_resource (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    resource_type VARCHAR(32) NOT NULL,
    name VARCHAR(200) NOT NULL,
    status INTEGER NOT NULL DEFAULT 1,
    xianyu_account_id INTEGER,
    xy_goods_id VARCHAR(100),
    stock INTEGER NOT NULL DEFAULT 0,
    amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    scheduled_time DATETIME,
    last_run_time DATETIME,
    data_json TEXT,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE merchant_task (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    task_type VARCHAR(32) NOT NULL,
    resource_id INTEGER,
    xianyu_account_id INTEGER,
    xy_goods_id VARCHAR(100),
    status INTEGER NOT NULL DEFAULT 0,
    scheduled_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    attempt_count INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 3,
    next_retry_time DATETIME,
    request_json TEXT,
    result_json TEXT,
    error_message VARCHAR(1000),
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE merchant_distribution (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    supply_resource_id INTEGER NOT NULL,
    material_resource_id INTEGER,
    xianyu_account_id INTEGER,
    xy_goods_id VARCHAR(100),
    status INTEGER NOT NULL DEFAULT 0,
    commission_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    settlement_status INTEGER NOT NULL DEFAULT 0,
    settlement_time DATETIME,
    data_json TEXT,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id, supply_resource_id, material_resource_id)
);

CREATE TABLE merchant_short_link (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    token VARCHAR(32) NOT NULL UNIQUE,
    target_url VARCHAR(2000) NOT NULL,
    click_count INTEGER NOT NULL DEFAULT 0,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
