-- MENO locked: gag2-dump-mail.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-dump-mail.lua", true))("YOUR_KEY")
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
