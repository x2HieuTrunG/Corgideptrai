const sqlite3 = require('sqlite3');
const { open } = require('sqlite');

async function initDB() {
    const db = await open({
        filename: './database.db',
        driver: sqlite3.Database
    });

    // Tạo bảng lưu file
    await db.exec(`
        CREATE TABLE IF NOT EXISTS files (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT,
            filepath TEXT,
            size INTEGER,
            upload_time TEXT
        )
    `);

    // Tạo bảng lưu tài khoản admin
    await db.exec(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
        )
    `);

    return db;
}

module.exports = { initDB };
