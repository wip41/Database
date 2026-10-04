-- ============================================================
-- CTE（共通テーブル式）
--
-- WITH句を使用して、2023年から2025年までの
-- 果物ごとの総生産量を一時的な結果セットとして作成する。
--
-- 作成したCTEを fruits テーブルと結合し、
-- 果物名と3年間の総生産量を取得する。
--
-- 主な使用内容：
-- ・WITH
-- ・CTE
-- ・GROUP BY
-- ・SUM()
-- ・JOIN
-- ============================================================

USE fruits_database;


-- 2023年から2025年までの果物別総生産量
-- CTEを使用して、2023年から2025年までの生産量を
-- fruit_id ごとに集計する。
-- CTEの結果を fruits テーブルと結合し、果物名と総生産量を取得する。

WITH fruits_production AS (
    SELECT
        p.fruit_id,
        SUM(p.production_volume) AS total_volume
    FROM production AS p
    WHERE p.production_year BETWEEN 2023 AND 2025
    GROUP BY p.fruit_id
)
SELECT
    f.name AS fruit,
    fp.total_volume
FROM fruits_production AS fp
JOIN fruits AS f
ON fp.fruit_id = f.id
ORDER BY fp.total_volume DESC;
