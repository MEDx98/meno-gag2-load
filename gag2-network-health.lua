-- MENO locked: gag2-network-health.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-network-health.lua", true))("YOUR_KEY")
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
