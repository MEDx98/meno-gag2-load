-- MENO locked: gag2-anti-afk.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-anti-afk.lua", true))("YOUR_KEY")
local KEY = ...
if type(KEY) ~= "string" or KEY == "" then
	KEY = ((getgenv and getgenv()) or _G).MENO_GAG2_KEY
end
assert(type(KEY) == "string" and #KEY > 0, '[MENO] provide key: loadstring(game:HttpGet(...))("YOUR_KEY")')

local env = (getgenv and getgenv()) or _G
env.MENO_GAG2_KEY = KEY
env.MENO_GAG2_LOCKED_BASE = "https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/"

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
