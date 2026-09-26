-- ============================================
-- CafeSense Database Schema
-- ============================================

CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cafes (
    cafe_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id BIGSERIAL PRIMARY KEY,
    cafe_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT fk_category_cafe
        FOREIGN KEY (cafe_id)
        REFERENCES cafes(cafe_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_category_name_per_cafe
        UNIQUE (cafe_id, name)
);

CREATE TABLE menu_items (
    menu_item_id BIGSERIAL PRIMARY KEY,
    cafe_id BIGINT NOT NULL,
    category_id BIGINT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_menu_item_cafe
        FOREIGN KEY (cafe_id)
        REFERENCES cafes(cafe_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_menu_item_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_menu_item_price
        CHECK (price >= 0)
);

CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    cafe_id BIGINT NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_cafe
        FOREIGN KEY (cafe_id)
        REFERENCES cafes(cafe_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_total
        CHECK (total_amount >= 0)
);

CREATE TABLE order_items (
    order_item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    menu_item_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_item_menu
        FOREIGN KEY (menu_item_id)
        REFERENCES menu_items(menu_item_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_item_price
        CHECK (unit_price >= 0)
);

CREATE TABLE customer_preferences (
    preference_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    dietary_preference VARCHAR(100),
    favorite_category VARCHAR(100),
    preferred_price_limit NUMERIC(10, 2),
    spice_preference VARCHAR(50),

    CONSTRAINT fk_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_preferred_price_limit
        CHECK (
            preferred_price_limit IS NULL
            OR preferred_price_limit >= 0
        )
);