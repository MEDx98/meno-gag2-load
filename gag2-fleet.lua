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
