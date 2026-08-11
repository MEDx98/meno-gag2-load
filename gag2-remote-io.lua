-- MENO locked: gag2-remote-io.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-remote-io.lua", true))("YOUR_KEY")
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
