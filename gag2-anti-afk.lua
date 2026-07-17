-- MENO locked: gag2-anti-afk.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-anti-afk.lua", true))("YOUR_KEY")
-- Preview/custom CDN: pass its base URL as the second argument.
local KEY, BASE_OVERRIDE = ...
if type(KEY) ~= "string" or KEY == "" then
	KEY = ((getgenv and getgenv()) or _G).MENO_GAG2_KEY
end
assert(type(KEY) == "string" and #KEY > 0, '[MENO] provide key: loadstring(game:HttpGet(...))("YOUR_KEY")')

local env = (getgenv and getgenv()) or _G
local LOCKED_BASE = type(BASE_OVERRIDE) == "string" and BASE_OVERRIDE or "https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/"
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
