CREATE TABLE sys_user_permission (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    permission_code VARCHAR(80) NOT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, permission_code),
    FOREIGN KEY (user_id) REFERENCES sys_user (id) ON DELETE CASCADE
);

-- 统一使用 InnoDB、utf8mb4 和毫秒级业务时间

CREATE TABLE sys_user (
    id INTEGER,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(200) NOT NULL,
    status TEXT NOT NULL DEFAULT 1,
    role VARCHAR(32) NOT NULL DEFAULT 'USER',
    last_login_time DATETIME NULL,
    last_login_ip VARCHAR(50) NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE sys_login_token (
    id INTEGER,
    user_id TEXT NOT NULL,
    token VARCHAR(500) NOT NULL,
    device_id VARCHAR(100) NULL,
    login_ip VARCHAR(50) NULL,
    expire_time DATETIME NOT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_account (
    id INTEGER,
    account_note VARCHAR(100) NULL,
    unb VARCHAR(100) NULL,
    device_id VARCHAR(100) NULL,
    status TEXT NOT NULL DEFAULT 1,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_cookie (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    cookie_text TEXT NULL,
    m_h5_tk VARCHAR(500) NULL,
    cookie_status TEXT NOT NULL DEFAULT 1,
    expire_time DATETIME NULL,
    websocket_token TEXT NULL,
    token_expire_time TEXT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods (
    id TEXT NOT NULL,
    xy_good_id VARCHAR(100) NOT NULL,
    xianyu_account_id TEXT NULL,
    title VARCHAR(500) NULL,
    cover_pic TEXT NULL,
    info_pic TEXT NULL,
    detail_info TEXT NULL,
    detail_url TEXT NULL,
    sold_price VARCHAR(50) NULL,
    sku_count INT NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 0,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_chat_message (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    lwp VARCHAR(50) NULL,
    pnm_id VARCHAR(100) NOT NULL,
    s_id VARCHAR(100) NULL,
    content_type INT NULL,
    msg_content TEXT NULL,
    sender_user_name VARCHAR(200) NULL,
    sender_user_id VARCHAR(100) NULL,
    sender_app_v VARCHAR(50) NULL,
    sender_os_type VARCHAR(20) NULL,
    reminder_url TEXT NULL,
    xy_goods_id VARCHAR(100) NULL,
    complete_msg TEXT NOT NULL,
    message_time TEXT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_config (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xianyu_goods_id TEXT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    xianyu_auto_delivery_on TEXT NOT NULL DEFAULT 0,
    xianyu_auto_reply_on TEXT NOT NULL DEFAULT 0,
    xianyu_auto_reply_context_on TEXT NOT NULL DEFAULT 1,
    xianyu_keyword_reply_on TEXT NOT NULL DEFAULT 0,
    human_intervention_on TEXT NOT NULL DEFAULT 0,
    human_intervention_minutes INT NOT NULL DEFAULT 10,
    fixed_material TEXT NULL,
    delivery_message_template VARCHAR(1000) NULL,
    receipt_follow_up_messages TEXT NULL,
    receipt_follow_up_interval_seconds INTEGER NOT NULL DEFAULT 5,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_auto_delivery_config (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xianyu_goods_id TEXT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    delivery_mode TEXT NOT NULL DEFAULT 1,
    sku_id VARCHAR(32) NULL,
    sku_key VARCHAR(32) GENERATED ALWAYS AS (COALESCE(sku_id, '')) STORED,
    sku_name VARCHAR(200) NULL,
    auto_delivery_content TEXT NULL,
    kami_config_ids TEXT NULL,
    kami_delivery_template TEXT NULL,
    auto_delivery_image_url TEXT NULL,
    auto_confirm_shipment TEXT NOT NULL DEFAULT 0,
    rag_delay_seconds INT NOT NULL DEFAULT 15,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_order (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xianyu_goods_id TEXT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    pnm_id VARCHAR(100) NOT NULL,
    order_id VARCHAR(100) NULL,
    buyer_user_id VARCHAR(100) NULL,
    buyer_user_name VARCHAR(256) NULL,
    sid VARCHAR(200) NULL,
    content TEXT NULL,
    state TEXT NOT NULL DEFAULT 0,
    fail_reason VARCHAR(500) NULL,
    confirm_state TEXT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    goods_title VARCHAR(256) NULL,
    sku_name VARCHAR(200) NULL,
    order_create_time VARCHAR(50) NULL,
    pay_success_time VARCHAR(50) NULL,
    consign_time VARCHAR(50) NULL,
    total_price VARCHAR(20) NULL,
    buy_num INT NOT NULL DEFAULT 1,
    delivery_status VARCHAR(24) NOT NULL DEFAULT 'PENDING',
    expected_quantity INT NOT NULL DEFAULT 1,
    delivered_quantity INT NOT NULL DEFAULT 0,
    attempt_count INT NOT NULL DEFAULT 0,
    next_retry_time DATETIME NULL,
    lease_owner VARCHAR(100) NULL,
    lease_expire_time DATETIME NULL,
    delivery_channel VARCHAR(24) NULL,
    last_error_code VARCHAR(64) NULL,
    last_error_message VARCHAR(500) NULL,
    delivery_message_content TEXT NULL,
    delivery_message_state INTEGER NOT NULL DEFAULT 0,
    delivery_message_attempt_count INTEGER NOT NULL DEFAULT 0,
    delivery_message_next_retry_time DATETIME NULL,
    receipt_follow_up_sent_count INTEGER NOT NULL DEFAULT 0,
    receipt_follow_up_next_time DATETIME NULL,
    receipt_follow_up_completed INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_auto_reply_record (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xianyu_goods_id TEXT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    s_id VARCHAR(100) NULL,
    pnm_id VARCHAR(100) NULL,
    buyer_user_id VARCHAR(100) NULL,
    buyer_user_name VARCHAR(200) NULL,
    buyer_message TEXT NULL,
    reply_content TEXT NULL,
    reply_type TEXT NOT NULL DEFAULT 1,
    matched_keyword VARCHAR(200) NULL,
    trigger_context TEXT NULL,
    state TEXT NOT NULL DEFAULT 0,
    scheduled_time DATETIME NULL,
    attempt_count INT NOT NULL DEFAULT 0,
    next_retry_time DATETIME NULL,
    lease_owner VARCHAR(100) NULL,
    lease_expire_time DATETIME NULL,
    last_error_code VARCHAR(64) NULL,
    last_error_message VARCHAR(500) NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_operation_log (
    id INTEGER,
    xianyu_account_id TEXT NULL,
    operation_type VARCHAR(50) NULL,
    operation_module VARCHAR(100) NULL,
    operation_desc VARCHAR(500) NULL,
    operation_status TEXT NULL,
    target_type VARCHAR(50) NULL,
    target_id VARCHAR(100) NULL,
    request_params TEXT NULL,
    response_result TEXT NULL,
    error_message TEXT NULL,
    ip_address VARCHAR(50) NULL,
    user_agent VARCHAR(500) NULL,
    duration_ms INT NULL,
    create_time TEXT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_sys_setting (
    id INTEGER,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT NULL,
    setting_desc VARCHAR(500) NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

INSERT INTO xianyu_sys_setting (setting_key, setting_value, setting_desc) VALUES
('sys_prompt', '作为虚拟商品商家客服，使用简短、自然、准确的中文回答。资料不足时请求补充，不编造商品或订单信息。', 'AI智能回复的系统提示词'),
('ai_api_key', '', 'AI服务的API Key'),
('ai_base_url', 'https://dashscope.aliyuncs.com/compatible-mode', 'AI服务的API Base URL'),
('ai_model', 'deepseek-v3', 'AI对话模型名称'),
('email_notify_ws_disconnect_enabled', '0', 'WebSocket断连邮件通知开关'),
('email_notify_cookie_expire_enabled', '0', 'Cookie过期邮件通知开关');

CREATE TABLE xianyu_kami_config (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    alias_name VARCHAR(200) NULL,
    alert_enabled TEXT NOT NULL DEFAULT 0,
    alert_threshold_type TEXT NOT NULL DEFAULT 1,
    alert_threshold_value INT NOT NULL DEFAULT 10,
    alert_email VARCHAR(200) NULL,
    total_count INT NOT NULL DEFAULT 0,
    used_count INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_kami_item (
    id INTEGER,
    kami_config_id TEXT NOT NULL,
    kami_content TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 0,
    order_id VARCHAR(100) NULL,
    reserved_time DATETIME NULL,
    used_time DATETIME NULL,
    sort_order INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_kami_usage_record (
    id INTEGER,
    kami_config_id TEXT NOT NULL,
    kami_item_id TEXT NOT NULL,
    xianyu_account_id TEXT NOT NULL,
    xy_goods_id VARCHAR(100) NULL,
    order_id VARCHAR(100) NOT NULL,
    delivery_index INT NOT NULL DEFAULT 1,
    delivery_status VARCHAR(24) NOT NULL DEFAULT 'RESERVED',
    buyer_user_id VARCHAR(100) NULL,
    buyer_user_name VARCHAR(256) NULL,
    kami_content TEXT NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_keyword_reply_rule (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    keyword VARCHAR(200) NOT NULL,
    match_mode INT NOT NULL DEFAULT 1,
    is_fallback INT NOT NULL DEFAULT 0,
    unique_keyword VARCHAR(200) GENERATED ALWAYS AS (IF(is_fallback = 1, '__FALLBACK__', keyword)) STORED,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_keyword_reply_content (
    id INTEGER,
    rule_id TEXT NOT NULL,
    reply_text TEXT NULL,
    reply_image_url TEXT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_sku (
    id VARCHAR(32) NOT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    sku_id VARCHAR(32) NULL,
    sku_key VARCHAR(32) GENERATED ALWAYS AS (COALESCE(sku_id, '')) STORED,
    price INT NULL,
    quantity INT NOT NULL DEFAULT 0,
    property_text VARCHAR(500) NULL,
    property_id INT NULL,
    value_id INT NULL,
    value_text VARCHAR(200) NULL,
    property_sort_order INT NOT NULL DEFAULT 0,
    value_sort_order INT NOT NULL DEFAULT 0,
    features TEXT NULL,
    xianyu_account_id TEXT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_goods_sku_property (
    id VARCHAR(32) NOT NULL,
    xy_goods_id VARCHAR(100) NOT NULL,
    property_id INT NOT NULL,
    property_text VARCHAR(200) NOT NULL,
    property_sort_order INT NOT NULL DEFAULT 0,
    value_id INT NOT NULL,
    value_text VARCHAR(200) NOT NULL,
    value_sort_order INT NOT NULL DEFAULT 0,
    xianyu_account_id TEXT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE xianyu_human_intervention_record (
    id INTEGER,
    xianyu_account_id TEXT NOT NULL,
    xy_goods_id VARCHAR(100) NULL,
    s_id VARCHAR(200) NOT NULL,
    end_time DATETIME NOT NULL,
    created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
