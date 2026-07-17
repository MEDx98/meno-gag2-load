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
