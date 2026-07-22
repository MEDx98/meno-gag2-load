-- MENO locked: gag2-fleet.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-fleet.lua", true))("YOUR_KEY")
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
