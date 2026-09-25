(async function autoRedeemDeltaForceV44() {
    const rawCodes = [
        "PWC260419S65", "DFELEVATE16", "DFAWAKEN56", "PWC260418S84", "PWC260418S11",
        "PWC260418S72", "PWC260419S67", "PWC260419S84", "DFCC0PNOW111", "DFCC0PGIST88",
        "DFCC0PWOR1D", "DFCC0PTOBE03", "DFCC0PPL4Y3R5", "DFOS5260405869", "DFOS5260405B58",
        "DFOS5260405B36", "DFDRAGONBOAT", "DFBrilliant165", "DF1314754", "JGHMCmxYa6PLcFgvD9mg",
        "DFOS22K8VA", "DFOSL5Q7MN", "DFOSB4N9RD", "PWC260418S79", "DFbeacon030",
        "DFCL503", "DFanchor945", "DFDragon504", "DFCONCORD82", "daichienboba6228",
        "daichienboba2719", "daichienboba6167", "daichienmobile7095", "daichienmobile3325",
        "daichienmobile7362", "DFOutstanding056", "DFReliable732", "DFForever395",
        "DFExcellent659", "DFRemarkable103", "DFessence982", "DFSerene218", "DFSpark119",
        "DFUltra220", "DFMagic057", "DFGalaxy250", "DFHorizon503", "TrickOrTreat",
        "DFNinja874", "DFRainbow356", "DFFlash260", "DFEnergy428", "DFoasis407",
        "DFEternity717", "DFFantasy742", "DFRocket825", "DFClover812", "DFHeroic668",
        "DFWizard309", "DFHarbor738", "DFPromise643", "DFCeleste516", "DFVivid061",
        "DFRL1017", "DFSH428", "DFVoyage901", "DFJubilee594", "DFmomentum423",
        "DFSymphony104", "DFHORIZON91", "DFINSIGHT48", "DFRESOLVE19", "DFEMBARK63",
        "DFMoment479", "DFASCEND72", "DFPARAGON41", "DFGENESIS05", "DFCatalyst87",
        "DFAXIOM33", "DFClarity152", "DFUT2025FINALS1549", "DFUT2025PLAYOFF5910",
        "DFUT2025PLAYOFF9163", "DFUT2025PLAYOFF2509", "DFUT2025PLAYOFF4827", "DFUT2025PLAYOFF8051",
        "DFUT2025PLAYOFF5732", "DFUT2025PLAYOFF1276", "GADFZebra", "DFOS5260404857",
        "DFOS5260404863", "DFOS5260404847", "DFOS5260403821", "DFOS5260403833",
        "DFOS5260403881", "DFOS7K2M9Q", "DFOS4XJ8PL", "DFOSW4D1YP", "DFsolace241",
        "DFUTW260412595", "DFUTW260412536", "DFUTW260412599", "PWC260419S21",
        "HEDELTAFORCE3630", "HEDELTAFORCE4583", "HEDELTAFORCE7563", "HEDELTAFORCE8781",
        "DFSIXMAJOR6", "VIP666SOLDF", "SOLPROMAJOR", "DFFILE274", "DFTRNG469",
        "MOILOOT92", "DFSIXVIP888", "ACESIXMAJOR", "DFWEEK237", "SOLDFWIN360",
        "MOILOOT55", "MOILOOT68", "MOILOOT48", "MOILOOT02", "MOILOOT04",
        "MOILOOT60", "MOILOOT45", "DFCRAFT427", "DFPACK293", "SIXMAJORMVP",
        "VIP777SIXDF", "DFARMX46", "DFAMM008", "DFTURING09", "HEDELTAFORCE8032",
        "HEDELTAFORCE9026", "MOILOOT65", "MOILOOT79", "TRILLIONRAID1000", "TRILLIONRAID600",
        "TRILLIONRAID300", "POC3105595", "POC3105596", "POC3105573", "POC3105564",
        "POC3105531", "POC3105590", "POC3005519", "POC3005552", "POC3005599",
        "POC3005559", "POC3005553", "POC3005551", "DFWITNESS77", "DFOS3FZ9LK",
        "DFOS7Q2VXA", "ReturningWarrior1", "ReturningWarrior3", "IvzeLrxYqjWvfiFSTS2",
        "ReturningWarrior2", "N4SQWgxYcHw7gUci3bJy", "Top1BXHVN", "aCuQjtXy7VGXjxCTBnQU",
        "A5Z1NDW8K3PJLU", "10KSUBSYOUTUBEDFRTNK", "DFExceptional305", "DFVANGUARD76",
        "GARENADFNY2501E034", "GARENADFNY2501H258", "C7S2X9J5D4B1V3Q", "GARENADFCBT2503Z6T9",
        "GARENADFCBT2503X9D1", "GARENADFCBT2503C3F4", "GARENADFID2501V621", "GARENADFID2501L983",
        "GARENADFID2501R572", "DELTAFORCEVN_8MD718JT4GR", "DELTAFORCEVN_95S092Y9T9D",
        "DELTAFORCEVN_6AVHJ6MYX6Y", "DELTAFORCEVN_540VN2S5S0U", "DFUTSCARH", "DFUTWEAPON",
        "DFUTGEARTICKET", "DFUTINTERMEDIATE", "DFUTSUPPYPACK", "DFUTARMAMENT",
        "SsCkDFxY5AkdZqjJLkXq", "yWHtfsxYGRPaZvAfLN82", "DFakaonikou", "85ewN4xYBjFncPkBADR",
        "hjRtrKxYLmcTyYcEy64H", "f2X6e3xY3PJDCE5rT7P", "Bd52XmxYJ2DFGcqnq4",
        "msz7HMxxYyGhipBay7HpK", "MOBILE0123", "DFUTS26QL3101C64", "DFUTS26QL3101C38",
        "DFUTS26QL3001C47", "DFUTS26QL1", "DFUTS26QL6", "DFUTS26QL5", "DFUTS26GR2702C44",
        "DFUTS26GR2702C57", "DFUTS26GR2702C92", "DFUTS26GR2802C23", "DFUTS26GR2802C66",
        "DFUTS26GR2802C78", "DFUTS26GR0103C35", "DFUTS26GR0103C81", "DFUTS26GR0103C49",
        "DFUTS26GR0703C34", "DFUTS26GR0703C96", "DFUTS26GR1203C72", "DFUTS26GR1203C83",
        "DFUTS26GR1203C46", "DFUTS26GR1303C65", "DFUTS26GR1303C39", "DFUTS26GR1303C98",
        "DFUTS26GR1403C24", "DFUTS26GR1403C87", "DFUTS26GR1403C52", "DFCC0001",
        "DFCCEIELI01", "DFCCHAHAS", "DFUTS26GR1503C33", "DFUTS26GR1503C91",
        "DFUTS26GR1503C74", "LAISEGAME", "DFUTS26PL2103C32", "DFUTS26PL2103C41",
        "DFUTS26PL2103C68", "DFUTS26PL2103C54", "DFUTS26PL2103C85", "DFUTS26PL2103C90",
        "DFUTS26PL2203C28", "DFUTS26PL2203C43", "DFUTS26PL2203C61", "DFUTS26PL2203C77",
        "DFUTS26PL2203C86", "DFUTS26PL2203C95", "DFVS357FR4", "DFVS8T95Z4",
        "DFVSH5N4C7", "DFVSU2X6M8", "DFVSW1C5D9", "DFVSE4K7G1", "DFCCOPWINEIEI",
        "DF425SOL", "DFWIN777", "DFHUNTER666", "DFAIM666", "DFGOGOGO425",
        "DfGiveMeBrick425", "DFLuckyLucky425", "DF425Bounty52", "DF51login51login",
        "DFVICTORY11", "DFWEAPON91", "SVBesCxYcsAN6LCD47P", "L34m5GxYjnPKXzckgdEB",
        "XufJgVxYrFctM5heBT3B", "DFOSB6T3WZ", "DFOS9R2HXC", "DFOS3Y8KLM"
    ];

    const allCodes = Array.from(new Set(rawCodes));
    const sleep = ms => new Promise(res => setTimeout(res, ms));

    function isVisible(el) {
        if (!el) return false;
        const style = window.getComputedStyle(el);
        if (style.display === 'none' || style.visibility === 'hidden' || style.opacity === '0') return false;
        const rect = el.getBoundingClientRect();
        return rect.width > 0 && rect.height > 0;
    }

    
    let currentProcessingCode = '';
    let matchedApiData = null;

    if (!window._dfHookedV44) {
        window._dfHookedV44 = true;
        const origFetch = window.fetch;
        window.fetch = async function(resource, init) {
            const res = await origFetch.apply(this, arguments);
            try {
                const url = typeof resource === 'string' ? resource : resource?.url || '';
                const body = init?.body ? String(init.body) : '';
                
                if (currentProcessingCode && (url.includes(currentProcessingCode) || body.includes(currentProcessingCode))) {
                    const clone = res.clone();
                    matchedApiData = await clone.json();
                }
            } catch (e) {}
            return res;
        };

        const origOpen = XMLHttpRequest.prototype.open;
        const origSend = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.open = function(method, url) {
            this._reqUrl = url;
            return origOpen.apply(this, arguments);
        };
        XMLHttpRequest.prototype.send = function(body) {
            const bodyStr = body ? String(body) : '';
            this.addEventListener('load', function() {
                try {
                    if (currentProcessingCode && (String(this._reqUrl).includes(currentProcessingCode) || bodyStr.includes(currentProcessingCode))) {
                        matchedApiData = JSON.parse(this.responseText);
                    }
                } catch (e) {}
            });
            return origSend.apply(this, arguments);
        };
    }

    console.clear();
    console.log(
        `Auto redeem by x2hieutrung...`,
        'color: #00ff9d; font-weight: bold; font-size: 14px'
    );

    function findInput() {
        return Array.from(document.querySelectorAll('input')).find(el => {
            if (!isVisible(el)) return false;
            const type = (el.getAttribute('type') || 'text').toLowerCase();
            return ['text', 'search', ''].includes(type);
        });
    }

    function findExactDoiBtn(input) {
        if (!input) return null;
        const inputRect = input.getBoundingClientRect();

        const all = Array.from(document.querySelectorAll('button, [role="button"], div, a, span')).filter(el => {
            if (!isVisible(el)) return false;
            const txt = (el.innerText || el.textContent || '').trim();
            return (txt === 'Đổi' || txt === 'ĐỔI' || txt === 'Redeem') && el.children.length <= 2;
        });

        const rightSide = all.find(el => {
            const r = el.getBoundingClientRect();
            return r.left >= inputRect.right - 15 && Math.abs(r.top - inputRect.top) < 70;
        });
        if (rightSide) return rightSide;

        const parent = input.closest('form') || input.parentElement?.parentElement || input.parentElement;
        if (parent) {
            const inside = Array.from(parent.querySelectorAll('*')).find(el => {
                const txt = (el.innerText || el.textContent || '').trim();
                return (txt === 'Đổi' || txt === 'ĐỔI' || txt === 'Redeem') && el !== input;
            });
            if (inside) return inside;
        }

        return all[0] || null;
    }

    const nativeSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value')?.set;
    function setInputValue(input, val) {
        input.focus();
        if (nativeSetter) {
            nativeSetter.call(input, val);
        } else {
            input.value = val;
        }
        input.dispatchEvent(new Event('input', { bubbles: true }));
        input.dispatchEvent(new Event('change', { bubbles: true }));
    }

    function simulateRealClick(element) {
        if (!element) return;
        const rect = element.getBoundingClientRect();
        const eventParams = {
            bubbles: true,
            cancelable: true,
            view: window,
            clientX: rect.left + rect.width / 2,
            clientY: rect.top + rect.height / 2,
            button: 0,
            buttons: 1
        };

        const targets = [element, element.firstElementChild, element.parentElement].filter(Boolean);
        for (const target of targets) {
            target.dispatchEvent(new PointerEvent('pointerdown', eventParams));
            target.dispatchEvent(new MouseEvent('mousedown', eventParams));
            target.dispatchEvent(new PointerEvent('pointerup', { ...eventParams, buttons: 0 }));
            target.dispatchEvent(new MouseEvent('mouseup', { ...eventParams, buttons: 0 }));
            target.dispatchEvent(new MouseEvent('click', { ...eventParams, buttons: 0 }));
            if (typeof target.click === 'function') target.click();
        }
    }

    
    async function closeAllModalsAndWait() {
        const buttons = Array.from(document.querySelectorAll('button, [role="button"], div, a, span')).filter(el => {
            if (!isVisible(el)) return false;
            const txt = (el.innerText || el.textContent || '').trim();
            return ['OK', 'Xác nhận', 'Đóng', 'x', 'X', 'Close', 'Confirm', 'Nhận', 'Đồng ý'].includes(txt);
        });
        for (const b of buttons) {
            try { b.click(); } catch (e) {}
        }
        // Đợi CSS transition mờ hẳn
        await sleep(350);
    }

    const noticeSelectors = [
        '.modal', '.dialog', '.toast', '.popup', '.tip', '.tips', '.notice', '.alert',
        '[role="dialog"]', '[class*="modal"]', '[class*="dialog"]', '[class*="pop"]',
        '[class*="toast"]', '[class*="tip"]', '[class*="award"]', '[class*="reward"]',
        '[class*="result"]', '[class*="gift"]', '.sweet-alert', '.swal2-container', '.swal2-popup'
    ];

    function getDomNoticeMessage() {
        for (const sel of noticeSelectors) {
            const elements = document.querySelectorAll(sel);
            for (const el of elements) {
                if (isVisible(el)) {
                    const txt = (el.innerText || el.textContent || '').replace(/\s+/g, ' ').trim();
                    if (txt && txt.length > 2 && txt.length < 350 && !txt.includes('DELTA FORCE ĐỔI GIFTCODE')) {
                        return txt;
                    }
                }
            }
        }
        return '';
    }

    function checkStatus(msg, apiData) {
        // Kiểm tra API đích danh của code này
        if (apiData) {
            const code = apiData.code ?? apiData.ret ?? apiData.errcode;
            if (code === 0 || apiData.status === 'success' || apiData.success === true) {
                return { status: 'SUCCESS', reason: apiData.msg || apiData.message || 'Thành công (API Verified)' };
            }
            if (code !== undefined && code !== 0) {
                return { status: 'FAIL', reason: apiData.msg || apiData.message || `Lỗi API (Code: ${code})` };
            }
        }

        if (!msg) return { status: 'TIMEOUT', reason: 'Không nhận được thông báo phản hồi' };
        const lower = msg.toLowerCase();
        
        if (lower.includes('thao tác quá nhanh') || lower.includes('thử lại sau') || lower.includes('frequent')) {
            return { status: 'RATE_LIMIT', reason: msg };
        }

        
        const successKeywords = ['thành công', 'chúc mừng', 'phần thưởng đã', 'gửi vào hòm thư', 'gửi vào hộp thư', 'success', 'nhận quà thành công'];
        const failKeywords = ['không hợp lệ', 'hết hạn', 'đã sử dụng', 'đã dùng', 'thất bại', 'không tồn tại', 'fail', 'invalid', 'expired', 'lỗi', 'error', 'quá số lần', 'chưa mở', 'đã nhận rồi', 'đã tham gia', 'không chính xác', 'sai', 'tài khoản đã nhận'];

        for (const kw of successKeywords) {
            if (lower.includes(kw)) return { status: 'SUCCESS', reason: msg };
        }
        for (const kw of failKeywords) {
            if (lower.includes(kw)) return { status: 'FAIL', reason: msg };
        }
        
        return { status: 'NOTICE', reason: msg };
    }

    const inputEl = findInput();
    const btnEl = findExactDoiBtn(inputEl);
    if (!inputEl || !btnEl) {
        console.error('❌ Không tìm thấy ô nhập hoặc nút Đổi!');
        return;
    }

    let successCount = 0;
    const startTime = Date.now();

    for (let i = 0; i < allCodes.length; i++) {
        const code = allCodes[i];
        
        
        await closeAllModalsAndWait();

        
        currentProcessingCode = code;
        matchedApiData = null;

        const currentInput = findInput() || inputEl;
        const currentBtn = findExactDoiBtn(currentInput) || btnEl;

        
        setInputValue(currentInput, code);
        await sleep(120);

        
        simulateRealClick(currentBtn);
        currentInput.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true }));

        
        let rawMessage = '';
        for (let wait = 0; wait < 45; wait++) { // Tối đa 3.6s
            await sleep(80);
            
            if (matchedApiData) {
                rawMessage = matchedApiData.msg || matchedApiData.message || '';
                break;
            }

            rawMessage = getDomNoticeMessage();
            if (rawMessage) break;
        }

        const result = checkStatus(rawMessage, matchedApiData);

        if (result.status === 'RATE_LIMIT') {
            console.warn(`⏳ [${code}] Web bắt chờ, tạm nghỉ 2.5s rồi thử lại mã này...`);
            await closeAllModalsAndWait();
            await sleep(2500);
            i--;
            continue;
        }

        if (result.status === 'SUCCESS') {
            successCount++;
            console.log(
                `%c[${i + 1}/${allCodes.length}] THÀNH CÔNG ✅ : ${code} -> ${result.reason}`,
                'background: #003311; color: #00ff66; font-size: 13px; font-weight: bold; padding: 2px 6px; border-radius: 3px;'
            );
        } else if (result.status === 'TIMEOUT') {
            console.log(
                `%c[${i + 1}/${allCodes.length}] TIMEOUT  ⚠️ : ${code} -> Không có thông báo sau 3.6s`,
                'color: #ffaa00; font-size: 12px;'
            );
        } else if (result.status === 'NOTICE') {
            console.log(
                `%c[${i + 1}/${allCodes.length}] THÔNG BÁO ℹ️ : ${code} -> "${result.reason}"`,
                'color: #00ddff; font-size: 12px;'
            );
        } else {
            console.log(
                `%c[${i + 1}/${allCodes.length}] THẤT BẠI   ❌ : ${code} -> ${result.reason}`,
                'color: #ff5555; font-size: 12px;'
            );
        }

        
        await sleep(600);
    }

    const duration = ((Date.now() - startTime) / 1000).toFixed(1);
    console.log(
        `%c🎉 Hoàn tất! Nhận thành công thực tế: ${successCount} mã trong ${duration}s.`,
        'color: #00ff9d; font-size: 15px; font-weight: bold; margin-top: 10px;'
    );
})();
