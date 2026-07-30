-- SQLite 买家资料
CREATE TABLE xianyu_buyer_profile (
    id INTEGER PRIMARY KEY,
    tenant_id INTEGER NOT NULL DEFAULT 1,
    xianyu_account_id INTEGER NOT NULL,
    buyer_user_id VARCHAR(100) NOT NULL,
    buyer_user_name VARCHAR(200),
    tags_json TEXT,
    note VARCHAR(500),
    automation_blocked INTEGER NOT NULL DEFAULT 0,
    blocked_reason VARCHAR(200),
    last_interaction_time DATETIME,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id, xianyu_account_id, buyer_user_id),
    FOREIGN KEY (xianyu_account_id) REFERENCES xianyu_account (id) ON DELETE CASCADE
);
