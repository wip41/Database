USE fruits_database;

-- ------------------------------------------------------------
-- カテゴリー
-- ※カテゴリー分類は本データベース用に設定
-- ------------------------------------------------------------

CREATE TABLE categories (
    id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);


-- ------------------------------------------------------------
-- 都道府県
-- ------------------------------------------------------------

CREATE TABLE prefectures (
    id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);


-- ------------------------------------------------------------
-- 果物
-- ------------------------------------------------------------

CREATE TABLE fruits (
    id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name),
    FOREIGN KEY (category_id)
        REFERENCES categories(id)
);


-- ------------------------------------------------------------
-- 生産データ
-- ------------------------------------------------------------

CREATE TABLE production (
    id INT AUTO_INCREMENT,
    fruit_id INT NOT NULL,
    prefecture_id INT NOT NULL,
    production_year INT NOT NULL,
    production_volume INT NOT NULL CHECK (production_volume >= 0),
    PRIMARY KEY (id),
    UNIQUE (fruit_id, prefecture_id, production_year),
    FOREIGN KEY (fruit_id)
        REFERENCES fruits(id),
    FOREIGN KEY (prefecture_id)
        REFERENCES prefectures(id)
);

