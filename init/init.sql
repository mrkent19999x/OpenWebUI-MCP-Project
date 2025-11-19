-- Database initialization for OpenWebUI-MCP-Project
-- This script sets up the database for Manus AI equivalent environment

-- Create tables for user management
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    full_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create tables for projects
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    user_id INTEGER REFERENCES users(id),
    github_repo_url VARCHAR(255),
    public_url VARCHAR(255),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create tables for code executions
CREATE TABLE IF NOT EXISTS code_executions (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    language VARCHAR(20) NOT NULL,
    code TEXT NOT NULL,
    output TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    execution_time DECIMAL(10,3),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create tables for web automation
CREATE TABLE IF NOT EXISTS web_automations (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    url VARCHAR(500) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    screenshot_path VARCHAR(255),
    data_extracted JSONB,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user
INSERT INTO users (username, email, full_name, role) 
VALUES ('admin', 'admin@manus-ai.local', 'Admin User', 'admin')
ON CONFLICT (username) DO NOTHING;

-- Insert sample project
INSERT INTO projects (name, description, status) 
VALUES ('Sample Project', 'Default project for testing Manus AI equivalent', 'active')
ON CONFLICT DO NOTHING;