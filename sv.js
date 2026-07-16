const express = require('express');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { initDB } = require('./database');

const app = express();
const PORT = 3000;
let db;

// Cấu hình Session (Ghi nhớ trạng thái đăng nhập)
app.use(session({
    secret: 'chuoi-bao-mat-xau-xa-hieutrung',
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 24 * 60 * 60 * 1000 } // Đăng nhập có hiệu lực trong 1 ngày
}));

// Cấu hình lưu trữ file vật lý
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const dir = './uploads';
        if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
const upload = multer({ storage });

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public'));

// --- MIDDLEWARE KIỂM TRA QUYỀN ADMIN ---
function isAdmin(req, res, next) {
    if (req.session && req.session.isAdmin) {
        next();
    } else {
        res.status(403).json({ success: false, message: 'Từ chối! Bạn không phải Admin.' });
    }
}

// --- API ROUTES ---

app.get('/', (req, res) => {
    res.redirect('/index.html');
});

// 1. API Đăng nhập Admin
app.post('/api/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const user = await db.get('SELECT * FROM users WHERE username = ?', [username]);
        if (user && await bcrypt.compare(password, user.password)) {
            req.session.isAdmin = true;
            res.json({ success: true, message: 'Đăng nhập thành công!' });
        } else {
            res.status(401).json({ success: false, message: 'Sai tài khoản hoặc mật khẩu!' });
        }
    } catch (err) {
        res.status(500).json({ success: false, message: 'Lỗi hệ thống.' });
    }
});

// 2. API Đăng xuất
app.post('/api/logout', (req, res) => {
    req.session.destroy();
    res.json({ success: true });
});

// 3. API Kiểm tra trạng thái Đăng nhập hiện tại
app.get('/api/auth-status', (req, res) => {
    res.json({ isAdmin: !!(req.session && req.session.isAdmin) });
});

// 4. API Upload File (CHỈ ADMIN)
app.post('/upload', isAdmin, upload.single('myFile'), async (req, res) => {
    try {
        if (!req.file) return res.status(400).send('Không có file.');
        const now = new Date().toLocaleString('vi-VN');
        
        await db.run(
            'INSERT INTO files (filename, filepath, size, upload_time) VALUES (?, ?, ?, ?)',
            [req.file.originalname, req.file.path, req.file.size, now]
        );
        res.redirect('/index.html');
    } catch (err) {
        res.status(500).send('Lỗi upload.');
    }
});

// 5. API Lấy danh sách Files (CÔNG KHAI)
app.get('/api/files', async (req, res) => {
    const files = await db.all('SELECT * FROM files ORDER BY id DESC');
    res.json(files);
});

// 6. API Tải File (CÔNG KHAI)
app.get('/download/:id', async (req, res) => {
    const file = await db.get('SELECT * FROM files WHERE id = ?', [req.params.id]);
    if (file && fs.existsSync(file.filepath)) {
        res.download(file.filepath, file.filename);
    } else {
        res.status(404).send('File không tồn tại.');
    }
});

// 7. API Xóa File (CHỈ ADMIN)
app.post('/delete/:id', isAdmin, async (req, res) => {
    try {
        const fileId = req.params.id;
        const file = await db.get('SELECT * FROM files WHERE id = ?', [fileId]);
        if (file) {
            if (fs.existsSync(file.filepath)) fs.unlinkSync(file.filepath);
            await db.run('DELETE FROM files WHERE id = ?', [fileId]);
            res.json({ success: true, message: 'Xóa thành công!' });
        } else {
            res.status(404).json({ success: false, message: 'Không tìm thấy file.' });
        }
    } catch (err) {
        res.status(500).json({ success: false });
    }
});

// Khởi động hệ thống & Tạo tài khoản admin mặc định nếu chưa có
initDB().then(async database => {
    db = database;
    
    // Tạo sẵn tài khoản admin/admin123 nếu bảng đang trống
    const adminCheck = await db.get('SELECT * FROM users WHERE username = ?', ['admin']);
    if (!adminCheck) {
        const hashedPassword = await bcrypt.hash('admin123', 10);
        await db.run('INSERT INTO users (username, password) VALUES (?, ?)', ['admin', hashedPassword]);
        console.log('👉 [Hệ thống] Đã tạo tài khoản admin mặc định: admin / mật khẩu: admin123');
    }

    app.listen(PORT, () => {
        console.log(`🚀 Server running at: http://localhost:${PORT}`);
    });
});
