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
