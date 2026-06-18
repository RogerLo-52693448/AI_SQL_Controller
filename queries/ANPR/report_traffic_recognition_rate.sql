-- ============================================
-- 檔案名稱：report_traffic_recognition_rate.sql
-- 功能描述：統計車輛通行量與車牌辨識率
--          計算每日通行車輛數，並分析具備辨識結果的比例
--          依 violation 狀態過濾有效計算母體，產生 ROLLUP 總計列
-- 分類：ANPR
-- 作者：RogerLo
-- 建立日期：2026-06-18
-- 最後修改：2026-06-18
-- 風險等級：LOW
-- 目標資料表：public.mlff_traffic_event
-- 參數說明：
--   :start_time - 查詢起始時間 (含)，格式 'YYYY-MM-DD HH24:MI:SS'
--   :end_time   - 查詢結束時間 (不含)，格式 'YYYY-MM-DD HH24:MI:SS'
-- 欄位邏輯：
--   violation = '3'        → 違規事件（排除於辨識率計算）
--   violation = '2' & detection_time_end IS NULL → 未完成偵測（排除）
--   violation IN ('0','1') OR (violation='2' & 有 end_time) → 有效計算母體
--   plate = '000000'      → 無辨識結果
--   plate <> '000000'     → 有辨識結果
-- ============================================

SELECT 
    -- 當 DATE(detection_time) 為 NULL 時，代表 ROLLUP 產生的總計列
    COALESCE(TO_CHAR(DATE(detection_time), 'YYYY-MM-DD'), '總計') AS event_date,
    
    -- 基礎分類加總
    COUNT(*) FILTER (WHERE violation = '3') AS violation_3_count,
    COUNT(*) FILTER (WHERE violation = '2' AND detection_time_end IS NULL) AS violation_2_null_count,
    COUNT(*) FILTER (WHERE violation NOT IN ('0', '1', '2', '3') OR violation IS NULL) AS others_count,
    COUNT(*) AS total_count,

    -- 分子與分母加總
    COUNT(*) FILTER (WHERE violation IN ('0', '1') OR (violation = '2' AND detection_time_end IS NOT NULL)) AS base_denominator_count,
    COUNT(*) FILTER (WHERE (violation IN ('0', '1') OR (violation = '2' AND detection_time_end IS NOT NULL)) AND plate <> '000000') AS plate_recognized_count,
    COUNT(*) FILTER (WHERE (violation IN ('0', '1') OR (violation = '2' AND detection_time_end IS NOT NULL)) AND plate = '000000') AS plate_not_recognized_count,

    -- 計算整體辨識率 (總分子 * 100 / 總分母)
    ROUND(
        COUNT(*) FILTER (WHERE (violation IN ('0', '1') OR (violation = '2' AND detection_time_end IS NOT NULL)) AND plate <> '000000') * 100.0 / 
        NULLIF(COUNT(*) FILTER (WHERE violation IN ('0', '1') OR (violation = '2' AND detection_time_end IS NOT NULL)), 0), 
        2
    ) AS recognition_rate_percentage

FROM public.mlff_traffic_event
WHERE 
    detection_time >= :start_time
    AND detection_time < :end_time
-- 使用 ROLLUP 讓 Postgres 自動計算加總列
GROUP BY ROLLUP(DATE(detection_time))
-- 確保『總計』排在最後一行，其餘依日期由舊到新排序
ORDER BY (DATE(detection_time) IS NULL) ASC, DATE(detection_time) ASC;
