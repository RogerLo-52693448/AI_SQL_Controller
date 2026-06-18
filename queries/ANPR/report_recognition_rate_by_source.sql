-- ============================================
-- 檔案名稱：report_recognition_rate_by_source.sql
-- 功能描述：依影像來源（Motion / NVR）分別統計車牌辨識率
--          按日期彙總，並產生總計列
-- 分類：ANPR
-- 作者：RogerLo
-- 建立日期：2026-06-18
-- 最後修改：2026-06-18
-- 風險等級：LOW
-- 目標資料表：public.mlff_enforcement_event
-- 參數說明：
--   :start_time - 查詢起始時間 (含)，格式 'YYYY-MM-DD HH24:MI:SS.MS'
--   :end_time   - 查詢結束時間 (不含)，格式 'YYYY-MM-DD HH24:MI:SS.MS'
-- 欄位說明：
--   image_source = 'M' → Motion 抽取照片
--   image_source = 'N' → NVR 抽取照片
--   plate = '000000'   → 無辨識結果
-- ============================================

SELECT 
    -- 如果是 ROLLUP 產生的統計列，會將日期顯示為 '總計'
    COALESCE(picture_time::date::text, '總計') AS event_date,
    
    -- 1. 數量統計
    COUNT(CASE WHEN image_source = 'M' THEN 1 END) AS total_m,
    COUNT(CASE WHEN image_source = 'N' THEN 1 END) AS total_n,
    COUNT(CASE WHEN image_source = 'M' AND plate <> '000000' THEN 1 END) AS valid_plate_m,
    COUNT(CASE WHEN image_source = 'N' AND plate <> '000000' THEN 1 END) AS valid_plate_n,
    
    -- 2. 辨識率（ROLLUP 會自動在總計行用「總有效數」除以「總數」）
    ROUND(
        COUNT(CASE WHEN image_source = 'M' AND plate <> '000000' THEN 1 END)::numeric 
        / NULLIF(COUNT(CASE WHEN image_source = 'M' THEN 1 END), 0), 
        4
    ) AS recognition_rate_m,

    ROUND(
        COUNT(CASE WHEN image_source = 'N' AND plate <> '000000' THEN 1 END)::numeric 
        / NULLIF(COUNT(CASE WHEN image_source = 'N' THEN 1 END), 0), 
        4
    ) AS recognition_rate_n,
    
    -- 總資料量
    COUNT(*) AS total_count 
FROM 
    public.mlff_enforcement_event
WHERE 
    image_source IN ('M', 'N')
    AND picture_time >= :start_time
    AND picture_time <  :end_time
GROUP BY 
    ROLLUP(picture_time::date)
ORDER BY 
    -- 讓 '總計' 欄位固定留在最後一行，其餘依日期由新到舊排序
    (CASE WHEN picture_time::date IS NULL THEN 1 ELSE 0 END) ASC,
    event_date;
