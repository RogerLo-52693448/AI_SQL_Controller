# SQL 檔案命名規範

## 命名格式

```
{動作}_{對象}[_{條件}].sql
```

## 動作前綴

| 前綴 | 說明 | 風險等級 | 範例 |
|------|------|----------|------|
| `get_` | 查詢單筆/多筆資料 | LOW | `get_plate_record.sql` |
| `list_` | 列表查詢 | LOW | `list_daily_scans.sql` |
| `count_` | 統計數量 | LOW | `count_detections.sql` |
| `search_` | 搜尋（含條件） | LOW | `search_vehicle_by_plate.sql` |
| `report_` | 報表查詢 | LOW | `report_monthly_summary.sql` |
| `insert_` | 新增資料 | MEDIUM | `insert_scan_log.sql` |
| `update_` | 更新資料 | MEDIUM | `update_tag_status.sql` |
| `delete_` | 刪除資料 | HIGH | `delete_expired_records.sql` |

## 命名範例

### ANPR
```
queries/ANPR/
├── get_plate_record.sql            # 查詢車牌紀錄
├── list_vehicles_by_date.sql       # 依日期列出車輛
├── count_daily_passages.sql        # 統計每日通行數
└── search_vehicle_by_plate.sql     # 依車牌搜尋車輛
```

### Detection_LiDAR
```
queries/Detection_LiDAR/
├── get_scan_result.sql             # 查詢掃描結果
├── list_detection_events.sql       # 列出偵測事件
├── count_objects_detected.sql      # 統計偵測物件數
└── report_hourly_activity.sql      # 每小時活動報表
```

### Detection_RFID
```
queries/Detection_RFID/
├── get_tag_info.sql                # 查詢標籤資訊
├── list_scan_logs.sql              # 列出掃描紀錄
├── count_active_tags.sql           # 統計活躍標籤數
└── search_tag_by_id.sql            # 依 ID 搜尋標籤
```

## 規則

1. **全部小寫**，單詞間用底線 `_` 分隔
2. **動作前綴必須存在**
3. **檔名需能自解釋功能**
4. **禁止使用** enhanced_, improved_, new_, v2_ 等前綴
5. **一個檔案只做一件事**
