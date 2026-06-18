# AI_SQL_Controller

## 專案描述
AI SQL 查詢控管 - 以 AI 驅動的 SQL 分類管理與安全審核系統（PostgreSQL）

## 快速開始 (Quick Start)

1. **首先閱讀 AIAgent_init.md** - 包含 AI Agent 的基本規則
2. 在 `queries/` 下對應分類資料夾新增 SQL 檔案
3. 遵循 `templates/query_template.sql` 格式撰寫
4. 在每個已完成的功能之後提交

## 專案結構

```
AI_SQL_Controller/
├── AIAgent_init.md                    # AI Agent 規則
├── README.md                          # 專案文件
├── .gitignore                         # Git 忽略模式
├── policies/
│   └── sql_governance.yaml            # SQL 控管政策
├── queries/
│   ├── ANPR/                          # 🚗 車牌辨識 (ANPR)
│   │   ├── README.md
│   │   └── *.sql
│   ├── Detection_LiDAR/               # 📡 LiDAR 偵測
│   │   ├── README.md
│   │   └── *.sql
│   └── Detection_RFID/                # 🏷️ RFID 偵測
│       ├── README.md
│       └── *.sql
├── templates/
│   └── query_template.sql             # SQL 撰寫範本
└── docs/
    └── naming_convention.md           # 命名規範
```

## SQL 分類說明

| 分類 | 資料夾 | 說明 |
|------|--------|------|
| 🚗 ANPR | `queries/ANPR/` | 車牌辨識系統相關查詢 |
| 📡 LiDAR | `queries/Detection_LiDAR/` | LiDAR 偵測系統相關查詢 |
| 🏷️ RFID | `queries/Detection_RFID/` | RFID 偵測系統相關查詢 |

## 新增 SQL 查詢

1. 確認查詢所屬分類
2. 複製 `templates/query_template.sql` 作為基礎
3. 依照命名規範命名檔案
4. 填寫標頭資訊與 SQL 內容
5. 提交並推送

## 控管政策

- **LOW 風險**：SELECT 查詢 → 直接允許
- **MEDIUM 風險**：INSERT / UPDATE → 需確認
- **HIGH 風險**：DELETE / DROP / TRUNCATE → 需人工審核

## License

MIT
