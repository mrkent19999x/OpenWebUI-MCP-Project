<<<<<<< HEAD
-- PostgreSQL init script
CREATE DATABASE IF NOT EXISTS litellm;
=======
-- LiteLLM PostgreSQL Database Initialization
-- Database: litellm
-- Purpose: Store LiteLLM metadata, request logs, and user configurations

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Request Logs Table
CREATE TABLE IF NOT EXISTS request_logs (
    id SERIAL PRIMARY KEY,
    request_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255),
    api_key VARCHAR(255),
    model VARCHAR(255) NOT NULL,
    request_type VARCHAR(50) NOT NULL,
    request_content TEXT,
    response TEXT,
    tokens_used INTEGER,
    cost DECIMAL(10,6),
    response_time_ms INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completion_time TIMESTAMP WITH TIME ZONE
);

-- API Keys Table
CREATE TABLE IF NOT EXISTS api_keys (
    id SERIAL PRIMARY KEY,
    user_api_key VARCHAR(255) UNIQUE NOT NULL,
    user_id VARCHAR(255),
    team_id VARCHAR(255),
    alias VARCHAR(255),
    key_name VARCHAR(255),
    expires_at TIMESTAMP WITH TIME ZONE,
    budget_id VARCHAR(255),
    allowed_region VARCHAR(255),
    permissions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Models Table
CREATE TABLE IF NOT EXISTS llm_model_group (
    model_group VARCHAR(255) PRIMARY KEY,
    models TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Budget Table (for usage tracking)
CREATE TABLE IF NOT EXISTS budget (
    budget_id VARCHAR(255) PRIMARY KEY,
    max_budget DECIMAL(10,2) DEFAULT 0,
    current_spend DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reset_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 days')
);

-- Team Table
CREATE TABLE IF NOT EXISTS team (
    team_id VARCHAR(255) PRIMARY KEY,
    max_budget DECIMAL(10,2) DEFAULT 0,
    spend DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- User Table
CREATE TABLE IF NOT EXISTS user (
    user_id VARCHAR(255) PRIMARY KEY,
    max_budget DECIMAL(10,2) DEFAULT 0,
    spend DECIMAL(10,2) DEFAULT 0,
    team_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES team(team_id)
);

-- Model Aliases Table
CREATE TABLE IF NOT EXISTS model_aliases (
    model_name VARCHAR(255) NOT NULL,
    model_group VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (model_name, model_group)
);

-- Customer Table (for enterprise features)
CREATE TABLE IF NOT EXISTS customer (
    customer_id VARCHAR(255) PRIMARY KEY,
    max_budget DECIMAL(10,2) DEFAULT 0,
    spend DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- End Users Table
CREATE TABLE IF NOT EXISTS end_user (
    end_user_id VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Verification Tokens Table (for email verification)
CREATE TABLE IF NOT EXISTS verification_tokens (
    id SERIAL PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Audit Logging Table
CREATE TABLE IF NOT EXISTS audit_logging (
    id SERIAL PRIMARY KEY,
    audit_log_type VARCHAR(255) NOT NULL,
    audit_log_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_request_logs_user_id ON request_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_request_logs_model ON request_logs(model);
CREATE INDEX IF NOT EXISTS idx_request_logs_created_at ON request_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_api_keys_key ON api_keys(user_api_key);
CREATE INDEX IF NOT EXISTS idx_budget_id ON budget(budget_id);

-- Insert default model groups
INSERT INTO llm_model_group (model_group, models) VALUES 
('gpt-4-models', '["gpt-4", "gpt-4-turbo", "gpt-4o"]'),
('claude-models', '["claude-3-opus", "claude-3-sonnet", "claude-3-haiku"]'),
('local-models', '["llama3", "mistral", "phi3", "qwen", "dolphin"]'),
('fast-models', '["gpt-3.5-turbo", "claude-3-haiku", "mistral-tiny"]'),
('vietnamese-models', '["minimax-abab6.5-chat", "viet-llm-7b", "viet-business-llm"]')
ON CONFLICT (model_group) DO NOTHING;

-- Insert model aliases
INSERT INTO model_aliases (model_name, model_group) VALUES
('gpt-4-turbo', 'gpt-4-models'),
('gpt-4o', 'gpt-4-models'),
('claude-3-sonnet', 'claude-models'),
('claude-3-haiku', 'claude-models'),
('llama3', 'local-models'),
('mistral', 'local-models'),
('gpt-3.5-turbo', 'fast-models'),
('mistral-tiny', 'fast-models'),
('minimax-abab6.5-chat', 'vietnamese-models'),
('viet-llm-7b', 'vietnamese-models')
ON CONFLICT (model_name, model_group) DO NOTHING;
>>>>>>> 94195001179a5fbe644cd74609eb37acfd8482fe
