# AIAgent_init.md - AI_SQL_Controller

> **Documentation Version**: 1.0
> **Last Updated**: 2026-06-18
> **Project**: AI_SQL_Controller
> **Description**: AI SQL 查詢控管
> **Database**: PostgreSQL
> **Features**: SQL 分類管理, AI 審核, 安全控管

## CRITICAL RULES

### RULE ACKNOWLEDGMENT REQUIRED
> Before starting ANY task, AIAgent must respond with:
> "✅ 已確認關鍵規則 - 我將遵守 AIAgent_init.md 中列出的所有禁令和要求"

### ABSOLUTE PROHIBITIONS
- **NEVER** create new files in root directory → use proper module structure
- **NEVER** write SQL without header comments → use templates/query_template.sql
- **NEVER** create duplicate SQL files → ALWAYS check existing queries first
- **NEVER** use SELECT * → must specify column names explicitly
- **NEVER** use DROP/TRUNCATE without HIGH risk label
- **NEVER** hardcode connection strings → use config files
- **NEVER** use naming like enhanced_, improved_, new_, v2_ → extend original files

### MANDATORY REQUIREMENTS
- **COMMIT**: 在每個已完成的任務/階段後進行提交
- **GITHUB BACKUP**: 在每次提交後推送: `git push origin main`
- **READ FILES FIRST**: 在編輯文件之前，必須先閱讀該文件
- **DEBT PREVENTION**: 在創建新 SQL 檔案之前，檢查是否存在現有相似查詢
- **SINGLE SOURCE OF TRUTH**: 每個查詢功能只有一個權威的 SQL 檔案
- **HEADER REQUIRED**: 每個 .sql 檔案必須包含標準標頭（參考 templates/）
- **NAMING CONVENTION**: 遵循 docs/naming_convention.md 命名規範

## PROJECT STRUCTURE
```
queries/
├── ANPR/                  # 車牌辨識相關查詢
├── Detection_LiDAR/       # LiDAR 偵測相關查詢
└── Detection_RFID/        # RFID 偵測相關查詢
```

## SQL FILE STANDARD HEADER
```sql
-- ============================================
-- 檔案名稱：{filename}.sql
-- 功能描述：{description}
-- 分類：{ANPR | Detection_LiDAR | Detection_RFID}
-- 作者：{author}
-- 建立日期：{date}
-- 最後修改：{date}
-- 風險等級：{LOW | MEDIUM | HIGH}
-- 目標資料表：{table_names}
-- ============================================
```

## COMMON COMMANDS
```bash
# Git 備份
git add . && git commit -m "描述" && git push origin main
```
