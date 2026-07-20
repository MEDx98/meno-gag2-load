-- MENO locked: gag2-pet-name-map.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-pet-name-map.lua", true))("YOUR_KEY")
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
