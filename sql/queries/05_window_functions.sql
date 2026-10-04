-- ============================================================
-- ウィンドウ関数
--
-- ウィンドウ関数を使用して、果物ごとの生産量ランキングや
-- 前年の生産量との比較を行う。
--
-- ROW_NUMBER() では果物ごとに生産量の順位を付け、
-- LAG() では同じ果物・都道府県の前年生産量を取得する。
--
-- CTEと組み合わせることで、前年差の計算や
-- 2025年に最も生産量が増加したデータの抽出も行う。
--
-- 主な使用内容：
-- ・ROW_NUMBER()
-- ・LAG()
-- ・PARTITION BY
-- ・CTE
-- ・ORDER BY
-- ・LIMIT
-- ============================================================

USE fruits_database;


-- 果物ごとの生産量1位
-- ROW_NUMBER() を使用して、2025年の生産量に
-- 果物ごとの順位を付ける。
-- サブクエリで順位を計算した後、1位のデータだけを取得する。

SELECT
    t.name AS fruit,
    t.prefecture,
    t.production_volume
FROM (
    SELECT
        f.name,
        pre.name AS prefecture,
        p.production_volume,
        ROW_NUMBER() OVER (
            PARTITION BY p.fruit_id
            ORDER BY p.production_volume DESC
        ) AS production_rank
    FROM production AS p
    JOIN fruits AS f
    ON f.id = p.fruit_id
    JOIN prefectures AS pre
    ON pre.id = p.prefecture_id
    WHERE p.production_year = 2025
) AS t
WHERE production_rank = 1
ORDER BY t.production_volume DESC;


-- 果物ごとの都道府県別生産量ランキング
-- ROW_NUMBER() と PARTITION BY を使用し、
-- 2025年の都道府県別生産量に果物ごとの順位を付ける。
-- 果物が変わるごとに順位を1から振り直す。

SELECT
    f.name AS fruit,
    pre.name AS prefecture,
    p.production_volume,
    ROW_NUMBER() OVER (
        PARTITION BY p.fruit_id
        ORDER BY p.production_volume DESC
    ) AS production_rank
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
JOIN prefectures AS pre
ON pre.id = p.prefecture_id
WHERE p.production_year = 2025
ORDER BY 
    p.fruit_id,
    p.production_volume DESC;


-- 前年との生産量差
-- LAG() を使用して、同じ果物・都道府県における
-- 前年の生産量を取得する。
-- CTEで前年値を保持し、現在年の生産量との差から前年差を求める。

WITH year_comparison AS (
    SELECT
        f.name AS fruit,
        pre.name AS prefecture,
        p.production_year,
        p.production_volume,
        LAG(p.production_volume) OVER (
            PARTITION BY
                p.fruit_id,
                p.prefecture_id
           ORDER BY p.production_year
        ) AS previous_year_volume
    FROM production AS p
    JOIN fruits AS f
    ON f.id = p.fruit_id
    JOIN prefectures AS pre
    ON pre.id = p.prefecture_id
)
SELECT
    fruit,
    prefecture,
    production_year,
    production_volume,
    previous_year_volume,
    production_volume - previous_year_volume AS diff
FROM year_comparison
ORDER BY
    fruit,
    prefecture,
    production_year;


-- 2025年に最も生産量が増加したデータ
-- LAG() を使用して同じ果物・都道府県の前年生産量を取得し、
-- 2025年と2024年の生産量の差を計算する。
-- 前年差の大きい順に並べ、LIMITを使用して最も増加した1件を取得する。

WITH year_comparison AS (
    SELECT
        f.name AS fruit,
        pre.name AS prefecture,
        p.production_year,
        p.production_volume,
        LAG(p.production_volume) OVER (
            PARTITION BY
                p.fruit_id,
                p.prefecture_id
            ORDER BY p.production_year
        ) AS previous_year_volume
    FROM production AS p
    JOIN fruits AS f
    ON f.id = p.fruit_id
    JOIN prefectures AS pre
    ON pre.id = p.prefecture_id
)
SELECT
    fruit,
    prefecture,
    production_volume,
    previous_year_volume,
    production_volume - previous_year_volume AS diff
FROM year_comparison
WHERE production_year = 2025
ORDER BY diff DESC
LIMIT 1;