-- ============================================================
-- 基本検索
--
-- production テーブルを基準に fruits、prefectures を結合し、
-- 2025年の果物名、都道府県名、生産量を取得する。
--
-- 主な使用内容：
-- ・JOIN
-- ・WHERE
-- ・ORDER BY
-- ============================================================

USE fruits_database;


-- 2025年の生産データ一覧
-- production、fruits、prefectures テーブルを結合し、
-- 2025年の果物名、都道府県名、生産量を取得する。
-- 生産量の多い順に並べて表示する。

SELECT
    f.name AS fruit,
    pre.name AS prefecture,
    p.production_volume
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
JOIN prefectures AS pre
ON pre.id = p.prefecture_id
WHERE p.production_year = 2025
ORDER BY p.production_volume DESC;