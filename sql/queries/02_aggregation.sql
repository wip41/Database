-- ============================================================
-- 集計処理
--
-- 2025年の生産量について、果物単位およびカテゴリー単位で
-- 合計生産量を集計する。
--
-- GROUP BY を使用してデータをグループ化し、
-- SUM() で各グループの総生産量を求める。
--
-- 主な使用内容：
-- ・JOIN
-- ・GROUP BY
-- ・SUM()
-- ・ORDER BY
-- ============================================================

USE fruits_database;


-- 果物ごとの2025年総生産量
-- 2025年の生産データを果物ごとにグループ化し、
-- SUM() を使用して果物ごとの総生産量を求める。
-- 総生産量の多い順に並べて表示する。

SELECT
    f.name AS fruit,
    SUM(p.production_volume) AS total_production_volume
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
WHERE p.production_year = 2025
GROUP BY f.id
ORDER BY total_production_volume DESC;


-- カテゴリーごとの2025年総生産量
-- fruits テーブルを経由して categories テーブルを結合し、
-- 2025年の生産量をカテゴリーごとに集計する。
-- SUM() と GROUP BY を使用してカテゴリー別の総生産量を求める。

SELECT
    c.name,
    SUM(p.production_volume) AS total_production_volume
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
JOIN categories AS c
ON c.id = f.category_id
WHERE p.production_year = 2025
GROUP BY c.id
ORDER BY total_production_volume DESC;