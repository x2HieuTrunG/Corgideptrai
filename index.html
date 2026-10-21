const express = require('express');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const https = require('https');
const http = require('http');

const app = express();
const PORT = process.env.PORT || 3000;
const ADMIN_SECRET = process.env.ADMIN_SECRET || "mat-khau-admin-cua-ban";

app.use(express.json({ limit: '100mb' }));
app.use(express.urlencoded({ extended: true, limit: '100mb' }));

// Khởi tạo thư mục và database
const STORAGE_DIR = path.join(__dirname, 'storage');
const RAW_DIR = path.join(STORAGE_DIR, 'raw');
const OBF_DIR = path.join(STORAGE_DIR, 'obf');
const DB_SCRIPTS = path.join(__dirname, 'data_scripts.json');
const DB_KEYS = path.join(__dirname, 'data_keys.json');
const DB_CONFIG = path.join(__dirname, 'data_config.json');

[STORAGE_DIR, RAW_DIR, OBF_DIR].forEach(dir => {
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});
if (!fs.existsSync(DB_SCRIPTS)) fs.writeFileSync(DB_SCRIPTS, JSON.stringify([]));
if (!fs.existsSync(DB_KEYS)) fs.writeFileSync(DB_KEYS, JSON.stringify([]));
if (!fs.existsSync(DB_CONFIG)) fs.writeFileSync(DB_CONFIG, JSON.stringify({ webhookUrl: "" }));

// Helper I/O
const readJSON = (file, def = []) => {
    try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return def; }
};
const writeJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2), 'utf8');

// Obfuscate Lua Built-in (XOR Bytecode Generator)
function obfuscateLuaBuiltIn(rawCode, scriptId) {
    const xorKey = Math.floor(Math.random() * 200) + 20;
    const bytes = [];
    for (let i = 0; i < rawCode.length; i++) {
        bytes.push(rawCode.charCodeAt(i) ^ xorKey);
    }
    const v1 = "_" + crypto.randomBytes(4).toString('hex');
    const v2 = "_" + crypto.randomBytes(4).toString('hex');
    const v3 = "_" + crypto.randomBytes(4).toString('hex');

    return `--[[ Protected by LuaGuard Enterprise | ID: ${scriptId} ]]
local ${v1} = {${bytes.join(',')}}
local ${v2} = ${xorKey}
local function ${v3}()
    local s = {}
    for i = 1, #${v1} do
        s[i] = string.char(bit32.bxor(${v1}[i], ${v2}))
    end
    return table.concat(s)
end
local fn, err = loadstring(${v3}())
if fn then fn() else warn("LuaGuard Error: " .. tostring(err)) end`;
}

// Discord Webhook
function sendDiscordWebhook(webhookUrl, embedData) {
    if (!webhookUrl || !webhookUrl.startsWith('http')) return;
    try {
        const url = new URL(webhookUrl);
        const payload = JSON.stringify({ embeds: [embedData] });
        const isHttps = url.protocol === 'https:';
        const client = isHttps ? https : http;

        const req = client.request({
            hostname: url.hostname,
            path: url.pathname + url.search,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(payload)
            }
        });
        req.on('error', () => {});
        req.write(payload);
        req.end();
    } catch {}
}

// Middleware xác thực Admin
function requireAdmin(req, res, next) {
    const key = req.headers['x-admin-key'] || req.query.admin_key;
    if (key !== ADMIN_SECRET) {
        return res.status(401).json({ error: 'Admin Secret Key không chính xác hoặc đã hết hạn!' });
    }
    next();
}

// Định kỳ dọn dẹp các session/tab bị offline (quá 60 giây không gửi heartbeat)
setInterval(() => {
    try {
        const db = readJSON(DB_KEYS);
        let changed = false;
        const now = Date.now();
        db.forEach(k => {
            if (k.activeSessions && k.activeSessions.length > 0) {
                const before = k.activeSessions.length;
                k.activeSessions = k.activeSessions.filter(s => (now - (s.lastPing || 0)) < 60000);
                if (k.activeSessions.length !== before) changed = true;
            }
        });
        if (changed) writeJSON(DB_KEYS, db);
    } catch {}
}, 15000);

// -------------------------------------------------------------
// GIAO DIỆN WEB STUDIO DASHBOARD
// -------------------------------------------------------------
app.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LuaGuard Studio — Key & Tab Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        brand: { 500: '#6366f1', 600: '#4f46e5' }
                    },
                    fontFamily: {
                        mono: ['"Fira Code"', 'Consolas', 'monospace'],
                        sans: ['"Inter"', 'system-ui', 'sans-serif']
                    }
                }
            }
        }
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass-panel {
            background: rgba(15, 23, 42, 0.78);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .glass-input {
            background: rgba(2, 6, 23, 0.65);
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.2s ease;
        }
        .glass-input:focus {
            border-color: rgba(99, 102, 241, 0.6);
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.25);
        }
        .code-font { font-family: 'Fira Code', monospace; }
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: rgba(15, 23, 42, 0.6); }
        ::-webkit-scrollbar-thumb { background: rgba(99, 102, 241, 0.3); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(99, 102, 241, 0.6); }
        .glow-bg {
            background: radial-gradient(circle at 15% 15%, rgba(99, 102, 241, 0.12) 0%, transparent 40%),
                        radial-gradient(circle at 85% 85%, rgba(16, 185, 129, 0.08) 0%, transparent 40%);
        }
    </style>
</head>
<body class="bg-[#030712] text-slate-200 min-h-screen glow-bg antialiased selection:bg-indigo-500 selection:text-white">

    <div id="toastContainer" class="fixed top-5 right-5 z-50 flex flex-col gap-2 pointer-events-none"></div>

    <div class="max-w-7xl mx-auto px-4 py-8">
        
        <!-- Header -->
        <header class="glass-panel rounded-2xl p-4 sm:p-6 mb-8 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-indigo-500 to-transparent"></div>
            <div class="flex flex-col md:flex-row items-center justify-between gap-5">
                <div class="flex items-center gap-4">
                    <div class="h-12 w-12 rounded-xl bg-gradient-to-tr from-indigo-600 to-emerald-400 p-[1px] flex items-center justify-center shadow-lg shadow-indigo-500/20">
                        <div class="h-full w-full bg-slate-950 rounded-[11px] flex items-center justify-center">
                            <i data-lucide="shield-check" class="w-6 h-6 text-indigo-400"></i>
                        </div>
                    </div>
                    <div>
                        <div class="flex items-center gap-2">
                            <h1 class="text-2xl font-extrabold tracking-tight bg-gradient-to-r from-white via-slate-100 to-slate-400 bg-clip-text text-transparent">LuaGuard Studio</h1>
                            <span class="px-2 py-0.5 text-[10px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 rounded-full">Multi-HWID & Tab Lock</span>
                        </div>
                        <p class="text-xs text-slate-400 mt-0.5">gethwid() • getgenv().Key • UserId Tracker • Tab Limitation</p>
                    </div>
                </div>

                <!-- Admin Auth Form -->
                <div class="flex items-center gap-2 w-full md:w-auto bg-slate-950/60 p-1.5 rounded-xl border border-slate-800">
                    <div class="relative flex-1 md:w-64">
                        <i data-lucide="key" class="w-4 h-4 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2"></i>
                        <input id="adminKey" type="password" value="mat-khau-admin-cua-ban" placeholder="Admin Secret Key..." 
                            class="w-full glass-input text-xs rounded-lg pl-9 pr-8 py-2 text-slate-100 placeholder:text-slate-500 outline-none">
                        <button type="button" onclick="togglePasswordVisibility()" class="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300">
                            <i data-lucide="eye" id="pwdEyeIcon" class="w-3.5 h-3.5"></i>
                        </button>
                    </div>
                    <button id="connectBtn" onclick="refreshAll()" 
                        class="flex items-center gap-1.5 bg-gradient-to-r from-indigo-600 to-indigo-500 hover:from-indigo-500 text-white text-xs font-semibold px-4 py-2 rounded-lg transition-all shadow-md">
                        <i data-lucide="refresh-cw" id="syncIcon" class="w-3.5 h-3.5"></i>
                        <span>Đồng bộ</span>
                    </button>
                </div>
            </div>

            <!-- Tabs Navigation -->
            <div class="flex items-center gap-3 mt-6 pt-4 border-t border-slate-800/80 overflow-x-auto pb-1">
                <button onclick="switchTab('scripts')" id="tabBtnScripts" class="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-indigo-600 text-white shadow-md transition whitespace-nowrap">
                    <i data-lucide="file-code" class="w-4 h-4"></i> Script & Obfuscator
                </button>
                <button onclick="switchTab('keys')" id="tabBtnKeys" class="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-slate-900 text-slate-400 hover:text-slate-200 transition whitespace-nowrap">
                    <i data-lucide="key-round" class="w-4 h-4"></i> Quản lý Key, HWID & Tab
                </button>
                <button onclick="switchTab('analytics')" id="tabBtnAnalytics" class="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-slate-900 text-slate-400 hover:text-slate-200 transition whitespace-nowrap">
                    <i data-lucide="line-chart" class="w-4 h-4"></i> Thống kê Executions
                </button>
                <button onclick="switchTab('webhook')" id="tabBtnWebhook" class="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-slate-900 text-slate-400 hover:text-slate-200 transition whitespace-nowrap">
                    <i data-lucide="bell-ring" class="w-4 h-4"></i> Discord Webhook
                </button>
            </div>
        </header>

        <!-- ========================================== -->
        <!-- TAB 1: SCRIPTS & UPLOAD & EDITOR -->
        <!-- ========================================== -->
        <div id="tab-scripts" class="tab-content grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            
            <section class="lg:col-span-7 glass-panel rounded-2xl p-6 relative border border-slate-800 shadow-xl">
                <div class="flex items-center justify-between mb-5">
                    <div class="flex items-center gap-2.5">
                        <div class="w-2 h-2 rounded-full bg-indigo-500"></div>
                        <h2 id="editorTitle" class="text-sm font-semibold tracking-wide uppercase text-indigo-300">Tạo Script Mới</h2>
                    </div>
                    <div class="flex items-center gap-2">
                        <span id="codeLength" class="text-[11px] font-mono text-slate-500 bg-slate-950 px-2.5 py-1 rounded-md border border-slate-800">0 lines • 0 B</span>
                        <button onclick="resetEditor()" title="Làm mới" class="p-1.5 text-slate-400 hover:text-white rounded-lg hover:bg-slate-800/80 transition">
                            <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>

                <input type="hidden" id="scriptId">

                <!-- Upload Drag & Drop Zone -->
                <div id="dropZone" onclick="document.getElementById('fileUploadInput').click()" 
                    class="mb-4 border-2 border-dashed border-slate-800 hover:border-indigo-500/60 bg-slate-950/40 hover:bg-indigo-950/20 rounded-xl p-3.5 text-center cursor-pointer transition">
                    <input type="file" id="fileUploadInput" accept=".lua,.txt" class="hidden" onchange="handleFileUpload(event)">
                    <div class="flex items-center justify-center gap-2 text-slate-400 hover:text-slate-200">
                        <i data-lucide="upload-cloud" class="w-5 h-5 text-indigo-400"></i>
                        <span class="text-xs font-medium">Chọn file từ máy tính hoặc kéo thả file <b class="text-indigo-400">.lua / .txt</b> vào đây</span>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="block text-xs font-medium text-slate-300 mb-1.5">Tên Script</label>
                    <div class="relative">
                        <i data-lucide="file-code" class="w-4 h-4 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2"></i>
                        <input id="scriptName" type="text" placeholder="VD: Kaitun Hub Blox Fruits" 
                            class="w-full glass-input rounded-xl pl-9 pr-4 py-2.5 text-sm text-slate-100 placeholder:text-slate-600 outline-none">
                    </div>
                </div>

                <div class="mb-5">
                    <div class="flex justify-between items-center mb-1.5">
                        <label class="text-xs font-medium text-slate-300">Mã nguồn Lua gốc</label>
                        <span class="text-[11px] text-indigo-400 font-mono flex items-center gap-1">
                            <i data-lucide="cpu" class="w-3.5 h-3.5"></i> Tự XOR Obfuscate khi bấm Lưu
                        </span>
                    </div>
                    <div class="relative rounded-xl overflow-hidden border border-slate-800 focus-within:border-indigo-500/70 transition-all">
                        <div class="bg-slate-900/90 px-4 py-2 border-b border-slate-800 flex items-center justify-between text-xs text-slate-400">
                            <span class="code-font text-[11px] text-slate-500 flex items-center gap-1.5">
                                <span class="w-2.5 h-2.5 rounded-full bg-red-500/60 inline-block"></span>
                                <span class="w-2.5 h-2.5 rounded-full bg-yellow-500/60 inline-block"></span>
                                <span class="w-2.5 h-2.5 rounded-full bg-green-500/60 inline-block"></span>
                                main.lua
                            </span>
                            <button onclick="insertTemplate()" class="hover:text-indigo-300 text-[11px] transition">Chèn mẫu script</button>
                        </div>
                        <textarea id="scriptCode" rows="13" oninput="updateCodeMetrics()" placeholder="-- Dán code Lua gốc hoặc upload file từ máy tính..." 
                            class="w-full bg-[#030712]/90 p-4 text-xs code-font text-emerald-400 placeholder:text-slate-600 outline-none resize-y leading-relaxed"></textarea>
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4 border-t border-slate-800/80">
                    <label class="flex items-center gap-2.5 text-xs text-slate-300 cursor-pointer select-none group">
                        <input id="blockBrowser" type="checkbox" checked class="w-4 h-4 rounded border-slate-700 text-indigo-600 bg-slate-900 accent-indigo-500 cursor-pointer">
                        <span class="group-hover:text-white transition flex items-center gap-1">
                            <i data-lucide="globe-lock" class="w-3.5 h-3.5 text-indigo-400"></i>
                            Chặn trình duyệt web (Anti-Browser)
                        </span>
                    </label>

                    <div class="flex items-center gap-3 w-full sm:w-auto">
                        <button onclick="resetEditor()" class="w-full sm:w-auto px-4 py-2 text-xs font-semibold text-slate-400 hover:text-white bg-slate-900 hover:bg-slate-800 border border-slate-800 rounded-xl transition">
                            Hủy
                        </button>
                        <button id="saveBtn" onclick="saveScript()" 
                            class="w-full sm:w-auto flex items-center justify-center gap-2 px-6 py-2.5 text-xs font-semibold text-white bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 rounded-xl shadow-lg shadow-emerald-600/20 transition-all hover:scale-[1.02] active:scale-[0.98]">
                            <i data-lucide="sparkles" class="w-4 h-4"></i>
                            <span id="saveBtnText">Mã hoá & Lưu Script</span>
                        </button>
                    </div>
                </div>
            </section>

            <!-- Right: Scripts List -->
            <section class="lg:col-span-5 glass-panel rounded-2xl p-6 border border-slate-800 shadow-xl">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
                    <div class="flex items-center gap-2">
                        <i data-lucide="box" class="w-4 h-4 text-indigo-400"></i>
                        <h2 class="text-sm font-semibold tracking-wide uppercase text-indigo-300">Kho Loadstring</h2>
                    </div>
                    <span id="scriptCountBadge" class="text-[11px] font-mono text-slate-400 bg-slate-900 border border-slate-800 px-2 py-0.5 rounded-md w-fit">0 scripts</span>
                </div>

                <div class="relative mb-4">
                    <i data-lucide="search" class="w-3.5 h-3.5 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2"></i>
                    <input id="searchInput" type="text" oninput="filterScripts()" placeholder="Tìm script..." 
                        class="w-full glass-input text-xs rounded-xl pl-8 pr-3 py-2 text-slate-200 placeholder:text-slate-500 outline-none">
                </div>

                <div id="scriptList" class="space-y-3.5 max-h-[620px] overflow-y-auto pr-1">
                    <div class="p-8 text-center text-slate-500 border border-dashed border-slate-800 rounded-xl">
                        <i data-lucide="database" class="w-8 h-8 mx-auto mb-2 opacity-40"></i>
                        <p class="text-xs">Chưa có kết nối dữ liệu.</p>
                    </div>
                </div>
            </section>
        </div>

        <!-- ========================================== -->
        <!-- TAB 2: KEY SYSTEM & MULTI-HWID & TAB LOCK -->
        <!-- ========================================== -->
        <div id="tab-keys" class="tab-content hidden grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            
            <!-- Left: Create Key -->
            <section class="lg:col-span-5 glass-panel rounded-2xl p-6 border border-slate-800 shadow-xl">
                <div class="flex items-center gap-2 mb-4">
                    <i data-lucide="key" class="w-4 h-4 text-emerald-400"></i>
                    <h2 class="text-sm font-semibold tracking-wide uppercase text-emerald-300">Tạo Key & Phân Quyền</h2>
                </div>

                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-medium text-slate-300 mb-1">Mã Key (để trống sẽ tạo ngẫu nhiên)</label>
                        <input id="newKeyVal" type="text" placeholder="KAITUN-VIP-XXXXX" 
                            class="w-full glass-input rounded-xl px-3 py-2 text-xs text-slate-100 font-mono outline-none">
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-slate-300 mb-1">Ghi chú / Tên Khách</label>
                        <input id="newKeyNote" type="text" placeholder="VD: Khách hàng mua 3 tab" 
                            class="w-full glass-input rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-xs font-medium text-slate-300 mb-1">Số HWID (Máy) tối đa</label>
                            <input id="newKeyMaxHwid" type="number" value="1" min="1" 
                                class="w-full glass-input rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-slate-300 mb-1">Số Tab tối đa</label>
                            <input id="newKeyMaxTabs" type="number" value="2" min="1" 
                                class="w-full glass-input rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-slate-300 mb-1">Thời hạn (Ngày, 0 = Vĩnh viễn)</label>
                        <input id="newKeyDays" type="number" value="30" min="0" 
                            class="w-full glass-input rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    </div>

                    <div class="p-3 bg-slate-900/80 rounded-xl border border-slate-800">
                        <label class="flex items-center gap-2.5 text-xs text-slate-200 cursor-pointer">
                            <input id="newKeyFFA" type="checkbox" class="w-4 h-4 rounded text-indigo-500 accent-indigo-500">
                            <div>
                                <span class="font-semibold text-indigo-300">Chế độ Public / FFA Key</span>
                                <p class="text-[11px] text-slate-400">Bỏ qua giới hạn HWID và Tab (không giới hạn người dùng).</p>
                            </div>
                        </label>
                    </div>

                    <button onclick="createKey()" 
                        class="w-full py-2.5 bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 text-white rounded-xl text-xs font-semibold shadow-md transition">
                        ➕ Tạo Key Mới
                    </button>
                </div>

                <!-- Client Code Snippet -->
                <div class="mt-6 pt-5 border-t border-slate-800">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-xs font-semibold text-slate-300 flex items-center gap-1.5">
                            <i data-lucide="code-2" class="w-4 h-4 text-indigo-400"></i> Mã Roblox Loader (Key & Tab Check):
                        </span>
                        <button onclick="copyClientSnippet()" class="text-[10px] text-indigo-400 hover:text-indigo-300 underline">Copy mẫu</button>
                    </div>
                    <pre id="luaSnippetBox" class="bg-black/60 p-3 rounded-xl border border-slate-900 text-[11px] code-font text-indigo-300 overflow-x-auto max-h-52"></pre>
                </div>
            </section>

            <!-- Right: Keys List -->
            <section class="lg:col-span-7 glass-panel rounded-2xl p-6 border border-slate-800 shadow-xl">
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center gap-2">
                        <i data-lucide="shield" class="w-4 h-4 text-indigo-400"></i>
                        <h2 class="text-sm font-semibold tracking-wide uppercase text-indigo-300">Danh Sách Key Hoạt Động</h2>
                    </div>
                    <span id="keyCountBadge" class="text-[11px] font-mono text-slate-400 bg-slate-900 border border-slate-800 px-2 py-0.5 rounded-md">0 keys</span>
                </div>

                <div id="keyList" class="space-y-3 max-h-[600px] overflow-y-auto pr-1">
                    <!-- Dynamic Keys -->
                </div>
            </section>
        </div>

        <!-- ========================================== -->
        <!-- TAB 3: ANALYTICS -->
        <!-- ========================================== -->
        <div id="tab-analytics" class="tab-content hidden glass-panel rounded-2xl p-6 border border-slate-800 shadow-xl">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center gap-2">
                    <i data-lucide="bar-chart-3" class="w-5 h-5 text-indigo-400"></i>
                    <h2 class="text-base font-bold text-white">Biểu đồ lượt chạy Script (Executions)</h2>
                </div>
                <button onclick="renderAnalyticsChart()" class="text-xs bg-slate-900 hover:bg-slate-800 px-3 py-1.5 rounded-lg border border-slate-800 text-slate-300 transition">
                    Cập nhật lại
                </button>
            </div>
            <div class="h-96 w-full">
                <canvas id="execChart"></canvas>
            </div>
        </div>

        <!-- ========================================== -->
        <!-- TAB 4: WEBHOOK CONFIG -->
        <!-- ========================================== -->
        <div id="tab-webhook" class="tab-content hidden glass-panel rounded-2xl p-6 border border-slate-800 shadow-xl max-w-2xl mx-auto">
            <div class="flex items-center gap-3 mb-5">
                <div class="p-2.5 rounded-xl bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                    <i data-lucide="bell" class="w-5 h-5"></i>
                </div>
                <div>
                    <h2 class="text-base font-bold text-white">Discord Webhook Notification</h2>
                    <p class="text-xs text-slate-400">Thông báo realtime khi script được load và khi key được kích hoạt</p>
                </div>
            </div>

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1.5">Discord Webhook URL</label>
                    <input id="webhookInput" type="text" placeholder="https://discord.com/api/webhooks/..." 
                        class="w-full glass-input rounded-xl px-4 py-2.5 text-xs text-slate-100 outline-none">
                </div>

                <div class="flex gap-3">
                    <button onclick="saveWebhook()" class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white rounded-xl text-xs font-semibold shadow-md transition">
                        Lưu Cấu Hình
                    </button>
                    <button onclick="testWebhook()" class="px-4 py-2.5 bg-slate-900 hover:bg-slate-800 border border-slate-800 text-slate-300 rounded-xl text-xs font-semibold transition">
                        Gửi Tin Nhắn Thử
                    </button>
                </div>
            </div>
        </div>

    </div>

    <!-- Logic JS -->
    <script>
        lucide.createIcons();

        let allScripts = [];
        let allKeys = [];
        let chartInstance = null;

        // Render snippet mẫu
        function getSnippetCode() {
            return \`-- Khai báo Key ở đầu file:
getgenv().Key = "DÁN_KEY_TẠI_ĐÂY"

-- Tự động lấy HWID linh hoạt:
local function getClientHWID()
    if typeof(gethwid) == "function" then return gethwid() end
    if typeof(get_hwid) == "function" then return get_hwid() end
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local HWID = getClientHWID()
local UserId = game.Players.LocalPlayer.UserId
local Username = game.Players.LocalPlayer.Name
local ServerUrl = "\${window.location.origin}"

-- 1. Xác thực Key, HWID, UserId:
local verifyUrl = string.format("%s/api/key/verify?key=%s&hwid=%s&userid=%s&username=%s", ServerUrl, getgenv().Key, HWID, UserId, Username)
local res = game:HttpGet(verifyUrl)

if not string.find(res, "VALID") then
    game.Players.LocalPlayer:Kick("LuaGuard Check Failed: " .. tostring(res))
    return
end

-- 2. Đăng ký Tab Session & Gửi Heartbeat định kỳ:
local tabToken = tostring(math.random(100000, 999999))
task.spawn(function()
    while task.wait(25) do
        local pingUrl = string.format("%s/api/key/heartbeat?key=%s&hwid=%s&tab=%s", ServerUrl, getgenv().Key, HWID, tabToken)
        local pingRes = game:HttpGet(pingUrl)
        if pingRes == "KICK_MAX_TABS" then
            game.Players.LocalPlayer:Kick("Đã vượt quá số Tab cho phép của Key này!")
            break
        end
    end
end)
print("[LuaGuard] Xác thực thành công! HWID: " .. HWID .. " | UserId: " .. UserId)\`;
        }

        document.getElementById('luaSnippetBox').innerText = getSnippetCode();

        function copyClientSnippet() {
            copyToClipboard(getSnippetCode());
        }

        // Local Storage Key Cache
        const savedKey = localStorage.getItem('luaguard_adminkey');
        if (savedKey) document.getElementById('adminKey').value = savedKey;

        const getHeaders = () => {
            const key = document.getElementById('adminKey').value.trim();
            localStorage.setItem('luaguard_adminkey', key);
            return {
                'Content-Type': 'application/json',
                'x-admin-key': key
            };
        };

        function switchTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
            document.getElementById('tab-' + tabId).classList.remove('hidden');

            const tabBtns = ['scripts', 'keys', 'analytics', 'webhook'];
            tabBtns.forEach(t => {
                const btn = document.getElementById('tabBtn' + t.charAt(0).toUpperCase() + t.slice(1));
                if (t === tabId) {
                    btn.className = 'flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-indigo-600 text-white shadow-md transition whitespace-nowrap';
                } else {
                    btn.className = 'flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold bg-slate-900 text-slate-400 hover:text-slate-200 transition whitespace-nowrap';
                }
            });

            if (tabId === 'analytics') renderAnalyticsChart();
            if (tabId === 'keys') loadKeys();
            if (tabId === 'webhook') loadWebhookConfig();
        }

        function showToast(message, type = 'info') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'pointer-events-auto flex items-center gap-3 px-4 py-3 rounded-xl shadow-2xl border text-xs font-medium transition-all duration-300 transform translate-y-2 opacity-0 glass-panel ' + 
                (type === 'success' ? 'border-emerald-500/40 text-emerald-300 bg-emerald-950/70' :
                 type === 'error' ? 'border-red-500/40 text-red-300 bg-red-950/70' :
                 'border-indigo-500/40 text-indigo-300 bg-slate-950/90');

            const iconMap = { success: 'check-circle', error: 'alert-triangle', info: 'info' };
            toast.innerHTML = '<i data-lucide="' + (iconMap[type] || 'info') + '" class="w-4 h-4 shrink-0"></i><span class="flex-1">' + message + '</span>';

            container.appendChild(toast);
            lucide.createIcons({ root: toast });

            requestAnimationFrame(() => toast.classList.remove('translate-y-2', 'opacity-0'));
            setTimeout(() => {
                toast.classList.add('opacity-0', 'translate-x-full');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        function togglePasswordVisibility() {
            const input = document.getElementById('adminKey');
            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            document.getElementById('pwdEyeIcon').setAttribute('data-lucide', isPassword ? 'eye-off' : 'eye');
            lucide.createIcons();
        }

        // Upload File an toàn
        function handleFileUpload(e) {
            const file = e.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function(evt) {
                document.getElementById('scriptCode').value = evt.target.result;
                if (!document.getElementById('scriptName').value.trim()) {
                    document.getElementById('scriptName').value = file.name.replace(/\\.[^/.]+$/, "");
                }
                updateCodeMetrics();
                showToast('Đã nạp file: ' + file.name, 'success');
            };
            reader.readAsText(file);
        }

        const dropZone = document.getElementById('dropZone');
        dropZone.addEventListener('dragover', (e) => { e.preventDefault(); dropZone.classList.add('border-indigo-500'); });
        dropZone.addEventListener('dragleave', () => dropZone.classList.remove('border-indigo-500'));
        dropZone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropZone.classList.remove('border-indigo-500');
            if (e.dataTransfer.files.length) {
                document.getElementById('fileUploadInput').files = e.dataTransfer.files;
                handleFileUpload({ target: { files: e.dataTransfer.files } });
            }
        });

        function updateCodeMetrics() {
            const code = document.getElementById('scriptCode').value;
            const lines = code ? code.split('\\n').length : 0;
            const bytes = new Blob([code]).size;
            document.getElementById('codeLength').innerText = lines + ' lines • ' + bytes + ' B';
        }

        function insertTemplate() {
            document.getElementById('scriptCode').value = '-- Script Kaitun Blox Fruits Demo\\nprint("Loaded Kaitun Script for UserId: " .. game.Players.LocalPlayer.UserId)\\nprint("HWID: " .. (typeof(gethwid)=="function" and gethwid() or "none"))';
            updateCodeMetrics();
            showToast('Đã nạp mẫu script!', 'info');
        }

        function copyToClipboard(text) {
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(text).then(() => {
                    showToast('Đã sao chép Loadstring!', 'success');
                }).catch(() => fallbackCopy(text));
            } else {
                fallbackCopy(text);
            }
        }

        function fallbackCopy(text) {
            const textArea = document.createElement("textarea");
            textArea.value = text;
            textArea.style.position = "fixed";
            textArea.style.left = "-999999px";
            textArea.style.top = "-999999px";
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            try {
                document.execCommand('copy');
                showToast('Đã sao chép!', 'success');
            } catch (err) {
                showToast('Không thể sao chép tự động!', 'error');
            }
            textArea.remove();
        }

        // Scripts API & Render
        async function loadScripts() {
            try {
                const res = await fetch('/api/scripts', { headers: getHeaders() });
                if (!res.ok) throw new Error();
                allScripts = await res.json();
                renderScripts(allScripts);
                document.getElementById('scriptCountBadge').innerText = allScripts.length + ' scripts';
                return true;
            } catch {
                return false;
            }
        }

        function renderScripts(scripts) {
            const container = document.getElementById('scriptList');
            if (scripts.length === 0) {
                container.innerHTML = '<div class="p-8 text-center text-slate-500 border border-dashed border-slate-800 rounded-xl"><i data-lucide="inbox" class="w-8 h-8 mx-auto mb-2 opacity-40"></i><p class="text-xs">Chưa có script nào.</p></div>';
                lucide.createIcons({ root: container });
                return;
            }

            container.innerHTML = scripts.map(s => {
                const url = window.location.origin + '/files/v1/loaders/' + s.id + '.lua';
                const loadstring = 'loadstring(game:HttpGet("' + url + '"))()';
                const safeName = escapeHtml(s.name);

                return '<div class="glass-panel p-4 rounded-xl border border-slate-800 hover:border-slate-700 transition group">' +
                    '<div class="flex justify-between items-start mb-2.5">' +
                        '<div class="overflow-hidden">' +
                            '<h3 class="text-xs font-bold text-slate-100 truncate group-hover:text-indigo-300 transition">' + safeName + '</h3>' +
                            '<div class="flex items-center gap-2 mt-1">' +
                                '<span class="text-[10px] text-slate-500 font-mono">ID: ' + s.id.slice(0, 8) + '...</span>' +
                                '<span class="text-[10px] px-1.5 py-0.5 rounded bg-emerald-500/10 text-emerald-400 font-medium">⚡ ' + (s.executions || 0) + ' hits</span>' +
                                (s.blockBrowser ? '<span class="text-[10px] px-1.5 py-0.5 rounded bg-indigo-500/10 text-indigo-400">🛡️ Anti-Web</span>' : '') +
                            '</div>' +
                        '</div>' +
                        '<div class="flex items-center gap-1.5 shrink-0 ml-2">' +
                            '<button onclick="editScript(\\'' + s.id + '\\', \\'' + encodeURIComponent(s.name) + '\\', ' + s.blockBrowser + ')" title="Sửa Source" class="p-1.5 rounded-lg bg-slate-900 hover:bg-slate-800 text-slate-400 hover:text-indigo-300 border border-slate-800 transition"><i data-lucide="edit-3" class="w-3.5 h-3.5"></i></button>' +
                            '<button onclick="deleteScript(\\'' + s.id + '\\')" title="Xóa Script" class="p-1.5 rounded-lg bg-red-950/40 hover:bg-red-900/60 text-red-400 hover:text-red-200 border border-red-900/30 transition"><i data-lucide="trash-2" class="w-3.5 h-3.5"></i></button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="bg-black/50 p-2 rounded-lg border border-slate-900 font-mono text-[11px] text-amber-300/90 break-all mb-2.5 select-all">' + loadstring + '</div>' +
                    '<button onclick="copyToClipboard(\\'' + loadstring.replace(/'/g, "\\\\'") + '\\')" class="w-full flex items-center justify-center gap-2 bg-indigo-500/10 hover:bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 text-xs py-2 rounded-lg font-medium transition active:scale-[0.99]"><i data-lucide="copy" class="w-3.5 h-3.5"></i><span>Sao chép Loadstring</span></button>' +
                '</div>';
            }).join('');

            lucide.createIcons({ root: container });
        }

        // Fix triệt để lưu script & upload
        async function saveScript() {
            const id = document.getElementById('scriptId').value;
            const name = document.getElementById('scriptName').value.trim();
            const code = document.getElementById('scriptCode').value;
            const blockBrowser = document.getElementById('blockBrowser').checked;

            if (!name) return showToast('Vui lòng nhập tên script!', 'error');
            if (!code.trim()) return showToast('Vui lòng điền mã nguồn Lua!', 'error');

            const saveBtn = document.getElementById('saveBtn');
            const saveBtnText = document.getElementById('saveBtnText');
            saveBtn.disabled = true;
            saveBtnText.innerText = 'Đang xử lý...';

            try {
                const res = await fetch('/api/scripts', {
                    method: 'POST',
                    headers: getHeaders(),
                    body: JSON.stringify({ id, name, code, blockBrowser })
                });

                const data = await res.json().catch(() => ({}));
                if (res.ok) {
                    showToast(id ? 'Cập nhật thành công!' : 'Tạo và Obfuscate thành công!', 'success');
                    resetEditor();
                    loadScripts();
                } else {
                    showToast(data.error || ('Lỗi máy chủ HTTP ' + res.status), 'error');
                }
            } catch (err) {
                showToast('Lỗi đường truyền hoặc payload quá lớn: ' + err.message, 'error');
            } finally {
                saveBtn.disabled = false;
                saveBtnText.innerText = 'Mã hoá & Lưu Script';
            }
        }

        async function editScript(id, encodedName, blockBrowser) {
            const name = decodeURIComponent(encodedName);
            try {
                const res = await fetch('/api/scripts/' + id + '/raw', { headers: getHeaders() });
                if (!res.ok) return showToast('Không thể tải mã nguồn gốc!', 'error');
                const rawCode = await res.text();

                document.getElementById('editorTitle').innerText = 'Chỉnh sửa: ' + name;
                document.getElementById('scriptId').value = id;
                document.getElementById('scriptName').value = name;
                document.getElementById('scriptCode').value = rawCode;
                document.getElementById('blockBrowser').checked = blockBrowser;
                updateCodeMetrics();
                window.scrollTo({ top: 0, behavior: 'smooth' });
                showToast('Đã nạp mã nguồn: ' + name, 'info');
            } catch {
                showToast('Lỗi khi nạp script!', 'error');
            }
        }

        async function deleteScript(id) {
            if (!confirm('Bạn có chắc chắn muốn xóa vĩnh viễn script này?')) return;
            try {
                const res = await fetch('/api/scripts/' + id, { method: 'DELETE', headers: getHeaders() });
                if (res.ok) {
                    showToast('Đã xóa script!', 'success');
                    loadScripts();
                } else {
                    showToast('Không thể xóa!', 'error');
                }
            } catch {
                showToast('Lỗi đường truyền!', 'error');
            }
        }

        function filterScripts() {
            const q = document.getElementById('searchInput').value.toLowerCase();
            const filtered = allScripts.filter(s => 
                s.name.toLowerCase().includes(q) || s.id.toLowerCase().includes(q)
            );
            renderScripts(filtered);
        }

        function resetEditor() {
            document.getElementById('editorTitle').innerText = 'Tạo Script Mới';
            document.getElementById('scriptId').value = '';
            document.getElementById('scriptName').value = '';
            document.getElementById('scriptCode').value = '';
            document.getElementById('blockBrowser').checked = true;
            document.getElementById('fileUploadInput').value = '';
            updateCodeMetrics();
        }

        // ==========================================
        // KEY SYSTEM, HWID & TAB MANAGEMENT
        // ==========================================
        async function loadKeys() {
            try {
                const res = await fetch('/api/keys', { headers: getHeaders() });
                if (!res.ok) throw new Error();
                allKeys = await res.json();
                renderKeys(allKeys);
                document.getElementById('keyCountBadge').innerText = allKeys.length + ' keys';
            } catch {
                showToast('Không thể tải danh sách keys!', 'error');
            }
        }

        function renderKeys(keys) {
            const container = document.getElementById('keyList');
            if (keys.length === 0) {
                container.innerHTML = '<div class="p-8 text-center text-slate-500 border border-dashed border-slate-800 rounded-xl"><i data-lucide="key" class="w-8 h-8 mx-auto mb-2 opacity-40"></i><p class="text-xs">Chưa có key nào được tạo.</p></div>';
                lucide.createIcons({ root: container });
                return;
            }

            container.innerHTML = keys.map(k => {
                const isExpired = k.expiresAt && new Date(k.expiresAt) < new Date();
                const expDate = k.expiresAt ? new Date(k.expiresAt).toLocaleDateString('vi-VN') : 'Vĩnh viễn';
                const hwidList = Array.isArray(k.hwidList) ? k.hwidList : (k.hwid ? [k.hwid] : []);
                const activeTabsCount = (k.activeSessions || []).length;

                return '<div class="glass-panel p-3.5 rounded-xl border border-slate-800 hover:border-slate-700 transition space-y-2">' +
                    '<div class="flex justify-between items-start">' +
                        '<div>' +
                            '<div class="flex items-center gap-2">' +
                                '<span class="font-mono text-xs font-bold text-emerald-400 select-all">' + k.key + '</span>' +
                                (k.isFFA ? '<span class="text-[10px] px-1.5 py-0.5 rounded bg-indigo-500/10 text-indigo-400 font-semibold">FFA Key</span>' : '') +
                                (isExpired ? '<span class="text-[10px] px-1.5 py-0.5 rounded bg-red-500/10 text-red-400">Hết hạn</span>' : '') +
                            '</div>' +
                            '<p class="text-[11px] text-slate-400 mt-0.5">' + (k.note || 'Không có ghi chú') + ' • Hạn: <b>' + expDate + '</b></p>' +
                        '</div>' +
                        '<div class="flex items-center gap-1.5">' +
                            (!k.isFFA ? '<button onclick="resetHwid(\\'' + k.key + '\\')" title="Reset toàn bộ HWID" class="px-2 py-1 bg-slate-900 hover:bg-slate-800 text-[10px] rounded border border-slate-800 text-amber-300 transition">Reset HWID</button>' : '') +
                            '<button onclick="deleteKey(\\'' + k.key + '\\')" title="Xóa Key" class="p-1 rounded bg-red-950/40 hover:bg-red-900/60 text-red-400 border border-red-900/30 transition"><i data-lucide="trash-2" class="w-3 h-3"></i></button>' +
                        '</div>' +
                    '</div>' +

                    // HWID & Tab Status Row
                    '<div class="grid grid-cols-2 gap-2 text-[10px] font-mono">' +
                        '<div class="bg-black/40 px-2 py-1 rounded border border-slate-900 flex justify-between">' +
                            '<span class="text-slate-400">Thiết bị (HWID):</span>' +
                            '<b class="' + (hwidList.length >= (k.maxHwid || 1) ? 'text-amber-400' : 'text-emerald-400') + '">' + (k.isFFA ? 'Không giới hạn' : (hwidList.length + '/' + (k.maxHwid || 1))) + '</b>' +
                        '</div>' +
                        '<div class="bg-black/40 px-2 py-1 rounded border border-slate-900 flex justify-between">' +
                            '<span class="text-slate-400">Số Tab đang chạy:</span>' +
                            '<b class="' + (activeTabsCount >= (k.maxTabs || 1) ? 'text-rose-400' : 'text-indigo-400') + '">' + (k.isFFA ? activeTabsCount : (activeTabsCount + '/' + (k.maxTabs || 1))) + '</b>' +
                        '</div>' +
                    '</div>' +

                    // UserId and User Info
                    '<div class="text-[10px] font-mono text-slate-400 bg-black/30 px-2 py-1 rounded flex justify-between items-center">' +
                        '<span>User: <b class="text-slate-200">' + (k.lastUsername || 'Chưa có') + '</b> (ID: <span class="text-indigo-300">' + (k.lastUserId || 'N/A') + '</span>)</span>' +
                        '<span class="text-[9px] text-slate-500">' + (hwidList.length > 0 ? (hwidList[0].slice(0, 12) + '...') : 'No HWID') + '</span>' +
                    '</div>' +

                '</div>';
            }).join('');

            lucide.createIcons({ root: container });
        }

        async function createKey() {
            const key = document.getElementById('newKeyVal').value.trim();
            const note = document.getElementById('newKeyNote').value.trim();
            const days = parseInt(document.getElementById('newKeyDays').value) || 0;
            const maxHwid = parseInt(document.getElementById('newKeyMaxHwid').value) || 1;
            const maxTabs = parseInt(document.getElementById('newKeyMaxTabs').value) || 1;
            const isFFA = document.getElementById('newKeyFFA').checked;

            try {
                const res = await fetch('/api/keys', {
                    method: 'POST',
                    headers: getHeaders(),
                    body: JSON.stringify({ key, note, days, maxHwid, maxTabs, isFFA })
                });

                const data = await res.json().catch(() => ({}));
                if (res.ok) {
                    showToast('Tạo Key thành công!', 'success');
                    document.getElementById('newKeyVal').value = '';
                    document.getElementById('newKeyNote').value = '';
                    loadKeys();
                } else {
                    showToast(data.error || 'Lỗi tạo key!', 'error');
                }
            } catch {
                showToast('Lỗi kết nối máy chủ!', 'error');
            }
        }

        async function resetHwid(key) {
            if (!confirm('Đặt lại toàn bộ danh sách HWID cho key này?')) return;
            try {
                const res = await fetch('/api/keys/' + key + '/resethwid', { method: 'POST', headers: getHeaders() });
                if (res.ok) {
                    showToast('Đã Reset HWID thành công!', 'success');
                    loadKeys();
                }
            } catch {
                showToast('Lỗi thao tác!', 'error');
            }
        }

        async function deleteKey(key) {
            if (!confirm('Xóa vĩnh viễn key này?')) return;
            try {
                const res = await fetch('/api/keys/' + key, { method: 'DELETE', headers: getHeaders() });
                if (res.ok) {
                    showToast('Đã xóa key!', 'success');
                    loadKeys();
                }
            } catch {
                showToast('Lỗi đường truyền!', 'error');
            }
        }

        // ==========================================
        // ANALYTICS & CHARTS
        // ==========================================
        function renderAnalyticsChart() {
            const ctx = document.getElementById('execChart').getContext('2d');
            const labels = allScripts.map(s => s.name);
            const data = allScripts.map(s => s.executions || 0);

            if (chartInstance) chartInstance.destroy();

            chartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Lượt chạy (Executions)',
                        data: data,
                        backgroundColor: 'rgba(99, 102, 241, 0.5)',
                        borderColor: 'rgba(99, 102, 241, 1)',
                        borderWidth: 1.5,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(255, 255, 255, 0.05)' },
                            ticks: { color: '#94a3b8' }
                        },
                        x: {
                            grid: { display: false },
                            ticks: { color: '#94a3b8' }
                        }
                    },
                    plugins: {
                        legend: { labels: { color: '#e2e8f0' } }
                    }
                }
            });
        }

        // ==========================================
        // WEBHOOK CONFIG
        // ==========================================
        async function loadWebhookConfig() {
            try {
                const res = await fetch('/api/config/webhook', { headers: getHeaders() });
                if (res.ok) {
                    const data = await res.json();
                    document.getElementById('webhookInput').value = data.webhookUrl || '';
                }
            } catch {}
        }

        async function saveWebhook() {
            const webhookUrl = document.getElementById('webhookInput').value.trim();
            try {
                const res = await fetch('/api/config/webhook', {
                    method: 'POST',
                    headers: getHeaders(),
                    body: JSON.stringify({ webhookUrl })
                });
                if (res.ok) showToast('Đã lưu cấu hình Webhook!', 'success');
            } catch {
                showToast('Lỗi lưu cấu hình!', 'error');
            }
        }

        async function testWebhook() {
            try {
                const res = await fetch('/api/config/webhook/test', { method: 'POST', headers: getHeaders() });
                if (res.ok) showToast('Đã gửi tin nhắn test tới Discord!', 'success');
                else showToast('Không thể gửi, kiểm tra lại Webhook URL!', 'error');
            } catch {
                showToast('Lỗi kiểm tra Webhook!', 'error');
            }
        }

        async function refreshAll() {
            const syncIcon = document.getElementById('syncIcon');
            syncIcon.classList.add('animate-spin');
            const ok = await loadScripts();
            if (ok) {
                await loadKeys();
                showToast('Đồng bộ dữ liệu thành công!', 'success');
            } else {
                showToast('Secret Key không đúng hoặc server chưa phản hồi!', 'error');
            }
            syncIcon.classList.remove('animate-spin');
        }

        function escapeHtml(str) {
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        window.addEventListener('DOMContentLoaded', () => {
            updateCodeMetrics();
            refreshAll();
        });
    </script>
</body>
</html>`);
});

// -------------------------------------------------------------
// REST API BACKEND
// -------------------------------------------------------------

// API Scripts
app.get('/api/scripts', requireAdmin, (req, res) => res.json(readJSON(DB_SCRIPTS)));

app.get('/api/scripts/:id/raw', requireAdmin, (req, res) => {
    const rawPath = path.join(RAW_DIR, `${req.params.id}.lua`);
    if (!fs.existsSync(rawPath)) return res.status(404).json({ error: 'Không tìm thấy file nguồn gốc!' });
    res.type('text/plain').send(fs.readFileSync(rawPath, 'utf8'));
});

app.post('/api/scripts', requireAdmin, (req, res) => {
    try {
        const { id, name, code, blockBrowser } = req.body;
        if (!name || !code) return res.status(400).json({ error: 'Thiếu tên script hoặc mã nguồn!' });

        const db = readJSON(DB_SCRIPTS);
        const scriptId = id || crypto.randomBytes(16).toString('hex');
        const existingIndex = db.findIndex(s => s.id === scriptId);

        fs.writeFileSync(path.join(RAW_DIR, `${scriptId}.lua`), code, 'utf8');
        fs.writeFileSync(path.join(OBF_DIR, `${scriptId}.lua`), obfuscateLuaBuiltIn(code, scriptId), 'utf8');

        const metadata = {
            id: scriptId,
            name: String(name).trim(),
            blockBrowser: blockBrowser !== false,
            updatedAt: new Date().toISOString(),
            executions: existingIndex !== -1 ? (db[existingIndex].executions || 0) : 0
        };

        if (existingIndex !== -1) db[existingIndex] = metadata;
        else db.push(metadata);
        writeJSON(DB_SCRIPTS, db);

        res.json({ success: true, script: metadata });
    } catch (err) {
        res.status(500).json({ error: 'Lỗi server khi lưu file: ' + err.message });
    }
});

app.delete('/api/scripts/:id', requireAdmin, (req, res) => {
    const scriptId = req.params.id;
    writeJSON(DB_SCRIPTS, readJSON(DB_SCRIPTS).filter(s => s.id !== scriptId));

    const rawPath = path.join(RAW_DIR, `${scriptId}.lua`);
    const obfPath = path.join(OBF_DIR, `${scriptId}.lua`);
    if (fs.existsSync(rawPath)) fs.unlinkSync(rawPath);
    if (fs.existsSync(obfPath)) fs.unlinkSync(obfPath);

    res.json({ success: true });
});

// -------------------------------------------------------------
// KEY SYSTEM, HWID & TAB MANAGEMENT API
// -------------------------------------------------------------
app.get('/api/keys', requireAdmin, (req, res) => res.json(readJSON(DB_KEYS)));

app.post('/api/keys', requireAdmin, (req, res) => {
    let { key, note, days, maxHwid, maxTabs, isFFA } = req.body;
    const db = readJSON(DB_KEYS);

    if (!key) {
        key = "LG-" + crypto.randomBytes(4).toString('hex').toUpperCase() + "-" + crypto.randomBytes(4).toString('hex').toUpperCase();
    }
    if (db.some(k => k.key === key)) return res.status(400).json({ error: 'Mã Key này đã tồn tại!' });

    let expiresAt = null;
    if (days && days > 0) {
        const d = new Date();
        d.setDate(d.getDate() + parseInt(days));
        expiresAt = d.toISOString();
    }

    const newKey = {
        key,
        note: note || '',
        hwidList: [],
        maxHwid: Math.max(1, parseInt(maxHwid) || 1),
        maxTabs: Math.max(1, parseInt(maxTabs) || 1),
        activeSessions: [], // [{ tabToken, hwid, lastPing }]
        isFFA: !!isFFA,
        lastUserId: null,
        lastUsername: null,
        expiresAt,
        createdAt: new Date().toISOString()
    };

    db.push(newKey);
    writeJSON(DB_KEYS, db);
    res.json({ success: true, key: newKey });
});

app.post('/api/keys/:key/resethwid', requireAdmin, (req, res) => {
    const db = readJSON(DB_KEYS);
    const keyItem = db.find(k => k.key === req.params.key);
    if (!keyItem) return res.status(404).json({ error: 'Không tìm thấy key!' });

    keyItem.hwidList = [];
    keyItem.activeSessions = [];
    writeJSON(DB_KEYS, db);
    res.json({ success: true });
});

app.delete('/api/keys/:key', requireAdmin, (req, res) => {
    writeJSON(DB_KEYS, readJSON(DB_KEYS).filter(k => k.key !== req.params.key));
    res.json({ success: true });
});

// Roblox Verify Key + HWID + UserId + Tab Limit
app.get('/api/key/verify', (req, res) => {
    const { key, hwid, userid, username } = req.query;
    if (!key) return res.send("INVALID_NO_KEY");

    const db = readJSON(DB_KEYS);
    const keyItem = db.find(k => k.key === key);
    if (!keyItem) return res.send("INVALID_KEY_NOT_FOUND");

    // 1. Kiểm tra hạn sử dụng
    if (keyItem.expiresAt && new Date(keyItem.expiresAt) < new Date()) {
        return res.send("INVALID_EXPIRED");
    }

    // Cập nhật UserId và Username gần nhất
    if (userid) keyItem.lastUserId = userid;
    if (username) keyItem.lastUsername = username;

    // 2. Nếu là Key FFA -> Cho qua luôn
    if (keyItem.isFFA) {
        writeJSON(DB_KEYS, db);
        return res.send("VALID_FFA");
    }

    // 3. Kiểm tra HWID
    if (!hwid) return res.send("INVALID_NO_HWID");

    if (!Array.isArray(keyItem.hwidList)) {
        keyItem.hwidList = keyItem.hwid ? [keyItem.hwid] : [];
    }

    const maxHwid = keyItem.maxHwid || 1;
    const isBound = keyItem.hwidList.includes(hwid);

    if (!isBound) {
        if (keyItem.hwidList.length >= maxHwid) {
            return res.send("INVALID_MAX_HWID_REACHED");
        }
        // Bind thêm HWID mới nếu chưa đầy slot
        keyItem.hwidList.push(hwid);
    }

    writeJSON(DB_KEYS, db);
    res.send("VALID");
});

// Heartbeat định kỳ check số Tab song song
app.get('/api/key/heartbeat', (req, res) => {
    const { key, hwid, tab } = req.query;
    if (!key || !tab) return res.send("INVALID");

    const db = readJSON(DB_KEYS);
    const keyItem = db.find(k => k.key === key);
    if (!keyItem) return res.send("INVALID_KEY");

    if (keyItem.isFFA) return res.send("OK_FFA");

    const now = Date.now();
    if (!Array.isArray(keyItem.activeSessions)) keyItem.activeSessions = [];

    // Lọc các session quá 60s không ping
    keyItem.activeSessions = keyItem.activeSessions.filter(s => (now - (s.lastPing || 0)) < 60000);

    const maxTabs = keyItem.maxTabs || 1;
    const existingSession = keyItem.activeSessions.find(s => s.tabToken === tab);

    if (existingSession) {
        existingSession.lastPing = now;
        existingSession.hwid = hwid;
    } else {
        if (keyItem.activeSessions.length >= maxTabs) {
            return res.send("KICK_MAX_TABS");
        }
        keyItem.activeSessions.push({ tabToken: tab, hwid: hwid || '', lastPing: now });
    }

    writeJSON(DB_KEYS, db);
    res.send("OK");
});

// -------------------------------------------------------------
// WEBHOOK CONFIG API
// -------------------------------------------------------------
app.get('/api/config/webhook', requireAdmin, (req, res) => {
    res.json(readJSON(DB_CONFIG, { webhookUrl: "" }));
});

app.post('/api/config/webhook', requireAdmin, (req, res) => {
    const { webhookUrl } = req.body;
    const cfg = readJSON(DB_CONFIG, { webhookUrl: "" });
    cfg.webhookUrl = webhookUrl || "";
    writeJSON(DB_CONFIG, cfg);
    res.json({ success: true });
});

app.post('/api/config/webhook/test', requireAdmin, (req, res) => {
    const cfg = readJSON(DB_CONFIG, { webhookUrl: "" });
    if (!cfg.webhookUrl) return res.status(400).json({ error: 'Chưa cấu hình webhook url' });

    sendDiscordWebhook(cfg.webhookUrl, {
        title: "🛡️ LuaGuard Webhook Test",
        description: "Kết nối Webhook thành công! LuaGuard sẵn sàng gửi cảnh báo thực thi.",
        color: 0x6366f1,
        timestamp: new Date().toISOString()
    });
    res.json({ success: true });
});

// -------------------------------------------------------------
// ENDPOINT LOADER (GỬI DISCORD KHI EXECUTE)
// -------------------------------------------------------------
app.get('/files/v1/loaders/:id.lua', (req, res) => {
    const scriptId = req.params.id;
    const db = readJSON(DB_SCRIPTS);
    const script = db.find(s => s.id === scriptId);
    
    if (!script) {
        return res.status(404).type('text/plain').send('-- [LuaGuard]: Script not found or deleted.');
    }

    const userAgent = (req.headers['user-agent'] || '').toLowerCase();
    const isBrowser = userAgent.includes('mozilla') || userAgent.includes('chrome') || userAgent.includes('safari') || userAgent.includes('edge');
    
    if (script.blockBrowser && isBrowser) {
        return res.status(403).type('text/plain').send('-- [LuaGuard Protection]: Access Denied. Web browsers are blocked.');
    }

    const obfPath = path.join(OBF_DIR, `${scriptId}.lua`);
    if (!fs.existsSync(obfPath)) {
        return res.status(404).type('text/plain').send('-- [LuaGuard]: Obfuscated file is missing.');
    }

    // Tăng lượt chạy
    script.executions = (script.executions || 0) + 1;
    writeJSON(DB_SCRIPTS, db);

    // Gửi Webhook Discord khi có người thực thi
    const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'Unknown IP';
    const cfg = readJSON(DB_CONFIG, { webhookUrl: "" });
    if (cfg.webhookUrl) {
        sendDiscordWebhook(cfg.webhookUrl, {
            title: "⚡ Script Executed!",
            description: `Script **${script.name}** vừa được tải và thực thi trong game!`,
            color: 0x10b981,
            fields: [
                { name: "📜 Script Name", value: script.name, inline: true },
                { name: "🆔 Script ID", value: `\`${script.id}\``, inline: true },
                { name: "🌐 Client IP", value: `\`${clientIp}\``, inline: true },
                { name: "🤖 User-Agent", value: `\`${req.headers['user-agent'] || 'Roblox Client'}\``, inline: false },
                { name: "📊 Tổng lượt chạy", value: `${script.executions}`, inline: true }
            ],
            footer: { text: "LuaGuard Enterprise Security" },
            timestamp: new Date().toISOString()
        });
    }

    res.type('text/plain').send(fs.readFileSync(obfPath, 'utf8'));
});

// Khởi chạy
app.listen(PORT, () => {
    console.log(`=======================================================`);
    console.log(`🛡️  LuaGuard Studio đang chạy tại:`);
    console.log(`👉 Web Panel: http://localhost:${PORT}`);
    console.log(`🔑 Admin Secret: ${ADMIN_SECRET}`);
    console.log(`=======================================================`);
});
