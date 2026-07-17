-- MENO locked: gag2-pet-send.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-pet-send.lua", true))("YOUR_KEY")
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
