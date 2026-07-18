-- MENO locked: gag2-pet-send.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-pet-send.lua", true))("YOUR_KEY")
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
