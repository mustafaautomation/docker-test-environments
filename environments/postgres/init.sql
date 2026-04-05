-- Test database seed data
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(100),
    in_stock BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed data
INSERT INTO users (email, name, role) VALUES
    ('alice@example.com', 'Alice Johnson', 'admin'),
    ('bob@example.com', 'Bob Smith', 'user'),
    ('carol@example.com', 'Carol Davis', 'user');

INSERT INTO products (name, price, category) VALUES
    ('Widget A', 29.99, 'Widgets'),
    ('Widget B', 49.99, 'Widgets'),
    ('Gadget X', 99.99, 'Gadgets');
