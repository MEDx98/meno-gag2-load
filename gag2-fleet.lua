-- MENO locked: gag2-fleet.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-fleet.lua", true))("YOUR_KEY")
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
