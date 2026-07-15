-- MENO locked: gag2-agent.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/master/gag2-agent.lua", true))("YOUR_KEY")
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
