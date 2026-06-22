-- ============================================
-- 檔案名稱：report_etag_detection_rate.sql
-- 功能描述：計算 eTag 偵測率
--          將 Tag 事件的不重複 tag_id 數量與有效通行車輛數比對，
--          算出各 Gantry 每日的偵測率
-- 運算邏輯：
--   分子：當日不重複 tag_id 數量
--   分母：有效通行車輛 = (VT0+VT1) - Tutu(VC=8) + VT2_carlog
--   過濾條件：
--     - 排除 violation IN ('2','3')
--     - 排除 match_type = '13'
--     - Tutu 定義為 final_car_type = '8'
--     - VT2_carlog 定義為 violation='2' 且 detection_time_end IS NOT NULL
-- 分類：Detection_RFID
-- 作者：RogerLo
-- 建立日期：2026-06-18
-- 最後修改：2026-06-18
-- 風險等級：LOW
-- 目標資料表：public.mlff_tag_event_merged, public.mlff_traffic_event
-- 參數說明：
--   :start_date - 查詢起始日期 (含)，格式 'YYYY-MM-DD'
--   :end_date   - 查詢結束日期 (不含)，格式 'YYYY-MM-DD'
-- ============================================

WITH sql1_metrics AS (
    -- 處理 Tag 資料：計算指定日期不重複的 Tag 數量
    SELECT 
        raw_arrive_time::date AS report_date,
        COUNT(DISTINCT tag_id) AS unique_tag_count
    FROM public.mlff_tag_event_merged
    WHERE raw_arrive_time >= :start_date AND raw_arrive_time < :end_date
    GROUP BY 1
),
sql2_metrics AS (
    -- 處理 Traffic 資料：過濾 Tutu、violation 2/3、match_type 13
    SELECT 
        detection_time::date AS report_date,
        lane_system_id,
        COUNT(CASE WHEN violation NOT IN ('2', '3') AND match_type <> '13' THEN 1 END) AS cond_1,
        COUNT(CASE WHEN final_car_type = '8' THEN 1 END) AS cond_2, 
        COUNT(CASE WHEN violation = '2' AND detection_time_end IS NOT NULL THEN 1 END) AS cond_3
    FROM public.mlff_traffic_event
    WHERE detection_time >= :start_date AND detection_time < :end_date
    GROUP BY 1, 2
)

SELECT 
    s2.report_date AS "Date",
    s2.lane_system_id AS "Gantry",
    s1.unique_tag_count AS "Tag_id <=1", 
    s2.cond_1 AS "VT0+VT1",
    s2.cond_2 AS "Tutu (VC = 8)",
    s2.cond_3 AS "VT2_carlog",
    -- 有效通行車輛 (分母)
    (s2.cond_1 - s2.cond_2 + s2.cond_3) AS "Valid traffic event",
    -- 計算偵測率
    CASE 
        WHEN (s2.cond_1 - s2.cond_2 + s2.cond_3) = 0 THEN 0 
        ELSE ROUND(s1.unique_tag_count::numeric / (s2.cond_1 - s2.cond_2 + s2.cond_3), 4) 
    END AS "Detection Rate"
FROM sql2_metrics s2
JOIN sql1_metrics s1 ON s1.report_date = s2.report_date
ORDER BY s2.report_date, s2.lane_system_id;
