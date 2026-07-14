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
