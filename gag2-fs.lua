-- MENO locked: gag2-fs.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-fs.lua", true))("YOUR_KEY")
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
