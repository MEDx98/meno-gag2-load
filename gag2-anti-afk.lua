-- MENO locked: gag2-anti-afk.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-anti-afk.lua", true))("YOUR_KEY")
-- Preview/custom CDN: pass its base URL as the second argument.
local KEY, BASE_OVERRIDE = ...
if type(KEY) ~= "string" or KEY == "" then
	KEY = ((getgenv and getgenv()) or _G).MENO_GAG2_KEY
end
assert(type(KEY) == "string" and #KEY > 0, '[MENO] provide key: loadstring(game:HttpGet(...))("YOUR_KEY")')

local env = (getgenv and getgenv()) or _G
local LOCKED_BASE = type(BASE_OVERRIDE) == "string" and BASE_OVERRIDE or "https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/"
LOCKED_BASE = tostring(LOCKED_BASE):gsub("^%s+", ""):gsub("%s+$", "")
assert(LOCKED_BASE:match("^https?://"), "[MENO] invalid locked base")
if LOCKED_BASE:sub(-1) ~= "/" then LOCKED_BASE = LOCKED_BASE .. "/" end
env.MENO_GAG2_KEY = KEY
env.MENO_GAG2_LOCKED_BASE = LOCKED_BASE

local function __meno_b64decode(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = tostring(data):gsub('[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if x == '=' then return '' end
		local r, f = '', (b:find(x) - 1)
		for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if #x ~= 8 then return '' end
		local c = 0
		for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2^(8 - i) or 0) end
		return string.char(c)
	end))
end

local MOD = 2^32
local function __meno_rrotate(n, b) return bit32.bor(bit32.rshift(n, b), bit32.lshift(n, 32 - b)) % MOD end
local function __meno_sha256(msg)
	local k = {
		0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
		0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
		0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
		0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
		0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
		0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
		0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
		0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
	}
	local h = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local bytes = {string.byte(msg, 1, #msg)}
	local bitLen = #msg * 8
	bytes[#bytes + 1] = 0x80
	while (#bytes % 64) ~= 56 do bytes[#bytes + 1] = 0 end
	for i = 7, 0, -1 do bytes[#bytes + 1] = bit32.band(bit32.rshift(bitLen, i * 8), 0xff) end
	for i = 1, #bytes, 64 do
		local w = {}
		for j = 0, 15 do
			local b = i + j * 4
			w[j] = ((bytes[b] or 0) * 0x1000000 + (bytes[b + 1] or 0) * 0x10000 + (bytes[b + 2] or 0) * 0x100 + (bytes[b + 3] or 0)) % MOD
		end
		for j = 16, 63 do
			local v = w[j - 15]
			local s0 = bit32.bxor(__meno_rrotate(v, 7), __meno_rrotate(v, 18), bit32.rshift(v, 3))
			v = w[j - 2]
			local s1 = bit32.bxor(__meno_rrotate(v, 17), __meno_rrotate(v, 19), bit32.rshift(v, 10))
			w[j] = (w[j - 16] + s0 + w[j - 7] + s1) % MOD
		end
		local a,b,c,d,e,f,g,hh = h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
		for j = 0, 63 do
			local S1 = bit32.bxor(__meno_rrotate(e, 6), __meno_rrotate(e, 11), __meno_rrotate(e, 25))
			local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
			local t1 = (hh + S1 + ch + k[j + 1] + w[j]) % MOD
			local S0 = bit32.bxor(__meno_rrotate(a, 2), __meno_rrotate(a, 13), __meno_rrotate(a, 22))
			local maj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
			local t2 = (S0 + maj) % MOD
			hh, g, f, e, d, c, b, a = g, f, e, (d + t1) % MOD, c, b, a, (t1 + t2) % MOD
		end
		h[1]=(h[1]+a)%MOD; h[2]=(h[2]+b)%MOD; h[3]=(h[3]+c)%MOD; h[4]=(h[4]+d)%MOD
		h[5]=(h[5]+e)%MOD; h[6]=(h[6]+f)%MOD; h[7]=(h[7]+g)%MOD; h[8]=(h[8]+hh)%MOD
	end
	local out = {}
	for i = 1, 8 do
		local v = h[i]
		out[#out+1] = string.char(bit32.band(bit32.rshift(v,24),255), bit32.band(bit32.rshift(v,16),255), bit32.band(bit32.rshift(v,8),255), bit32.band(v,255))
	end
	return table.concat(out)
end

local function __meno_derivePad(key, len)
	local out, block, offset = {}, __meno_sha256(key), 0
	while offset < len do
		for i = 1, #block do
			if offset >= len then break end
			offset = offset + 1
			out[offset] = block:byte(i)
		end
		block = __meno_sha256(block .. key)
	end
	local s = {}
	for i = 1, len do s[i] = string.char(out[i]) end
	return table.concat(s)
end

local function __meno_decrypt(b64, key)
	local raw = __meno_b64decode(b64)
	local pad = __meno_derivePad(key, #raw)
	local t = {}
	for i = 1, #raw do
		t[i] = string.char(bit32.bxor(raw:byte(i), pad:byte(i)))
	end
	local plain = table.concat(t)
	if plain:sub(1, 6) ~= "MENOOK" then
		error("[MENO] wrong key")
	end
	return (plain:gsub("^MENOOK\r?\n", ""))
end

env.MENO_GAG2_DECRYPT = __meno_decrypt

local B64 = [=[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]=]
local src = __meno_decrypt(B64, KEY)
local fn, err = loadstring(src)
assert(fn, "[MENO] compile failed (wrong key?): " .. tostring(err))
return fn()
