-- MENO locked: gag2-inventory.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-inventory.lua", true))("YOUR_KEY")
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
