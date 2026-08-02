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
