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
