-- ============================================================
-- 副問い合わせ・CASE式
--
-- 副問い合わせを使用して全生産データの平均生産量を求め、
-- 平均を上回るデータを取得する。
--
-- また、CASE式を使用して2025年の生産量を
-- 「大・中・小」の3段階に分類する。
--
-- 主な使用内容：
-- ・副問い合わせ
-- ・AVG()
-- ・CASE
-- ・WHERE
-- ・ORDER BY
-- ============================================================

USE fruits_database;


-- 平均生産量を上回るデータ
-- 副問い合わせで2023年から2025年までの全生産データの
-- 平均生産量を求め、その平均値を上回るデータを取得する。
-- 副問い合わせの結果を WHERE 句の条件として利用する。

SELECT
    f.name AS fruit,
    pre.name AS prefecture,
    p.production_year,
    p.production_volume
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
JOIN prefectures AS pre
ON pre.id = p.prefecture_id
WHERE p.production_volume > (
    SELECT AVG(production_volume)
    FROM production
    WHERE production_year BETWEEN 2023 AND 2025
)
ORDER BY p.production_volume DESC;


-- 2025年の生産量を3段階に分類
-- CASE式を使用して2025年の各生産データを
-- 生産量に応じて「大・中・小」の3段階に分類する。
-- CASE式は上から順番に条件を判定するため、大きい値から条件を指定する。

SELECT
    f.name AS fruit,
    pre.name AS prefecture,
    p.production_volume,
    CASE
        WHEN p.production_volume >= 100000 THEN '大'
        WHEN p.production_volume >= 30000 THEN '中'
        ELSE '小'
    END AS volume_rank
FROM production AS p
JOIN fruits AS f
ON f.id = p.fruit_id
JOIN prefectures AS pre
ON pre.id = p.prefecture_id
WHERE p.production_year = 2025
ORDER BY p.production_volume DESC;