-- MENO locked: gag2-anti-afk.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-anti-afk.lua", true))("YOUR_KEY")
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

local B64 = [=[nkK/4I/py5fgGqJRcRSrGHUvOCvLroZQBrvK9+nanmKq64zukq//OKwsUAY4A/wy0zxIFlm14WQ9rEnL2B2MTXSBLB2ryZm3GSSPgeuO/c9Zd5gLCt9K7y7T+C9QSAkH24HB3UOPYE1lywcPm/U8nSbM63A8sl7t2vzXvb/1u0rcB9KCVr3A1lZjikws3sjF69VgH5iCQVCiH2cKsKTy3j5v0Vmc5xPs5mZuCBFziRCGgpohFNfimq44GERpAvCCgc+u80rJL9yA0akkFW/DNSDjAK1fiUWSCvXJAvv8ec5TlH/ifqGlNFocbmDtHmqdyRH4ZFaWokF68kudgQg6SwB+yM6nF3zCGMhb+tWS4tScNcnn6RQbGwqTJaiBnGHPGgaOsMVGb95Ew4a9/vbp7OQNij5oQasSaRq6yc3mBSUip31Gq1W7CpF8TTa8PnYNkkV4sY3fdjzDqnuMLEVYT0VW1gc9TbOY1KCcXi8jn6XEowszc7MT9psA+w5lo9N5jnfI62WGKkuL7gnp1Fgvlronr9gQQrwPvaIAX8Be4ptuB1p3u/yZ3B4a/GkHcEETEZOEFo+r25mSpaqO79mo4euly2/5PsfvkrsMV8N1VA9SHImgGz1m7fgVjFyOLSyJgkEfFeP8b9zVMoHOCbXNt/iyEaMZWppJFGAnxyYedZ1z3p9dDTQGi6+JlL6RX4/7qd8geF9+I3HneHLycTaj2TiNFVwO+Zupt4MdHYTXuL7SdEzzEkZsFStUfHVshcBEsCNzJGXajETYxOrHwsUrNWZZQUQENSf7/1vRWi/jCfdu3ZCYprSGvIhO8WU9nMYY4al0mKh8XkuR2IaNJMkTjG9cZU8I1pBxoA5zVPKLHauY576q+GubMoRSJKKHxWlVzoh8qSx0NWPi0hVaXIo+iiCY+WL0EaCUBxp016lR5jCdbosJjXlG7OQ1jbTmmTx9imxdik5szIBm8bndYhfPXE3JpPTcr9ZUyTMfzwC//ZbsBf50dJ8V1YcWONcsHplm/IgReuz+jK5k95C51d5iew0x3stK6FHfrcKZuXMshBk+8KJa2/V42DqrHbmtL+g3+VyUq/VqvdwsCs3IZNXRcJ7WqMKsX0myRSvbTXvjr7BC+CdeV5SSeTdHgiQ+mYDTedUYSGPeWFUScjp9gywf4uSYJ9+cuSAzVqmfaTEgGCATeSH3LpZlCJQQBFNAW8yBz29WlJ5ZhORkIVJjWve4QV7JskWEc7YUELaQLh8gKrbw8JL1n2zdjgK6HMaK+1b/PcB7bpw4fLwbXZw95ZliHW5TAFvVfapLte+0snbA2jyHcS8e+HK7sKK/OcUGUWUUf1Mil83Ftl3otAy67WV4yn8hnoj4jPIOq9Z1bh+StVz8esr1qhdu70GCv9chcXsRKVlpYQhhybHMXDyRmbEAMpIyzgLsdE42fxOU6WQ7aYJWXVydgZ8MkqpIbrfzOKISrW0ensdXRsiJmXP2ELtI9JpIw9Csb8KVoRY/gzuaA0kF/mYeUapVqhRBwBjG2Wx/a7hzi1UarSbwHEmfphzt+gLol+Tbef/xBKOCoGyWWjtiOkWiW50WsdB0dxXoaKjUxTRKlZFQQBgHYlEQDtK2Gl6mHoiU7A1AK6u1CQReZ778G2lmwLfYK4dyMtEpDrlB7AScX4ApDwhATWKA8pwJZWmYXIJCx+T/Ka1crd+5eGF8Cbjzch9hftpXjfA3Fr+BBEKw0zjF6MzX25A8vetluyoxsB3qQceXWY7tnCMNibXhqeyJmu8t0GIjLcXZyKD2Uwy1QLgDNCwachPrxO4gjp16lP3qUdWrKqXW7WLw2UI6UmYmqD70J+y1IpG+9Eumy/ojRdBaPLS+IbdQ3XVfhcZpAeapvih1T4TMdXaoKdqtikTrOEZWCKepNraRU67jc7kJ2mnFsOvdo4DqFHGMnXKX6AT1QFhHZa9vBa3aYfojd4iPTIr0AQVoNwxu9V1rEHFWCD876SSjQRq3yiPFXLLUAjH4JmayfKKfp3aEy4tHRsokENrjr0viQUiXj2OWrI9LvVtTKvPFcePG5d6EaYoMWNJrgAMAdAcLqfVjTPqEFF733kOiMfpVsF6pPsIvf5jN32qJ4S8dYdNQRLDxUB0mJknXVSQuUDoVBkeUeZGEVZOoZqPUpH5oPxqgOqjQp2v00uJGgyYHc3u62XPSkwZksXWa4mVWdjY8OMUunSXxg7TwrtuCvUAH8ARkEgckeJhXk0qsSQoXJOINyjlnTKso5ckWAVYFXjRoKu6ZuAZCvXJe5f4TBjWaFDa4pqAawdlWryQcR3npteBRA7Rxp88RPQep07kiR8V5BJEXyOa4J5kNphsTAfwWlWiJMlMqkQ7YasDvkBnHIANUh6NUSKYs5e/J2Ypa0rOsv7N47HSLOvRE8LyXvdI7rEUphLGMwOZZCK46SvcNrOrQRFyUd/Scxcbfi8dEqNWYONtxLkK+rShAhLKPCD0eYFxAVBQbY+OvufgqGHRJZYmNpeec5roCy7TJm4KCCJ0n6OpwaCBEEWMz1tXLM59m9OcBeeqYZkLf25P+UrYH0gPBnqLAVnbowAsv4/Vm6kgmX65EgkLaY5sY245zsfkud6XO+enP7Z9G1ix5MwyNOzICuc3PvclBv4zPdpC4gs6DmmQpTXnHyGtt2bsmx8P3yb6vLs5YyAJ688O5OYujhlx0gRpLPNiTDsxUAyrLttwzocU7ppMXt2og40+ZsjNgcab6llyOIh3E8C19BYdY1FPIYMl5URCQaDaZVjUI3vnBkzAmDig0XWfARMffxzze7hN/cAK2UO6QuyRoiF1PdQhv0eXZJ5U/rSceQ+qG6rQULjZF1QMgc0zSQ7a2VEW4DRCAZp+8c3RluEqAZOfbGWJeGCLRYI8m13iK0nwMFVnb2a/M0F4euXkVUBlxhQN7gTi3Pp6BQt1/tOLw9YD9fjJxHnI3c4PWKeBWvFQj7+jCfW/Ous+Lfb5BimTEWH3AgOKqYQdoGSrX4zL24ezpy12Bf23yvmBrRLdy8AXhFAOyd0zKLNOplYotXIdu4Qep33tpcry2Ul7OEmPKQtYk3CpABoH6pezUEOUTLabQcthzQOs5GhETeyw1YiL7SDb293BNQZprX7Vu0B27CUjMMdecREl51/ZXz4T6eX3833wGTyGMR/rdYHkFWVO4cGjdaGFvW+fiYOIQ+HB6ulSMj3zmCalbsSTCQ4gMd5In/EBDL8WykF+6k0mjN7hcfu6bQKcMT8ezukwo1cTrXXLiyd3f++lMo7o3R33wTGiBBc8ffxGkgxGjMMwQjtL2VRSfkcvX5gmK7cUVntCsKqdc6piNEb9HWUbWG58xm/PbNlHkVL3GaNl+NSKp7hShhYt2YxV0Pq9Zo7u24lgyJv/cYHi6F5LnYJYTP7QKimW66uzFvQVr+J21eYsYzj0Imz7x2ObPnjc4pqcASRAm4WBxE5mkpyPjt67OWeomssazoVOQoXU53AObLsMbLu/zd0wduDSeeVrUMz4P/Skc7SsAZhKXgRZnRyBOHM2t3MnO8MJDDHHhyKXb2KKLCkMB9BonC7mG5BdLgmzUrJNR7dP1EcKQTFguAZCWQJ+MnwwBOdmAjFRRYCXr0qWdcBj10M3QePW0jHzWZL51X5Gwc6Qug2fZeOXG2OVKlZkpvGI8M4iPkl6p5CFotkCOmj/FwjtL98jv3JuMEL7Xh2y8pXDY7aZcrG8rpQwMMKKL+ygBEB+vpSPDPtPK4i82SbZg4isB3oszZy9+jWvr3YXX7sptGoe37JyIW4+fpLckNVle4zit6CZRkIuN0l8cfQzX7L76mKKKqw5C2M3R1IiIutIsfI4Ifp0WiGe+p5AIaDruLshaiKzqsQcZK0r/+1dwol+dRSyDzIzXecBMHDNoQJkjz/YKdBuH4gLRXzne++8IAvyRQwHAceqVRMHtwt3kv8+KHAL6rrxw56TnXuemS5fIfKEWgNO9HBEOaCgoQ8p7vsWvMJ3Y80HtPE3LnXv+ZEQp+L+66lgVLeXoBwUap1jovwErKYClMW6azMTxp7vNlcj0JnldOBSNPzlJYTlIJBdeybZwRBcC5UzP75UPVlnMI3jZfiTlHdxSrODCZbj0uviUVouAPOjjSCvYL0r5xO8iR3A++zYZC/KpnRF7b0WNDgue3xT7sc1cuWV/77pdI9ZPlPOXrrzDSReT+JK3uuTueeFNPD7qmMACw6CQfwvaIst5DLaRRyd6fWgbQvXuBt8hTxDwPuKqQ8I7kQrsypeaGAcw05Z5/Er2Wdj33Kbk8FAYmsyyiz3lUZRNDyiu+ms9ZYFQyUbfD0zqIeEAYMLNoUfvbl348F0W/EIRbNiYiu2R/UpSlUrpd5a3tD1nQDnHMXpeH9CZqeDVNVsxkIODmrVe3e9GrBKTNMoxmd16JPH3EXNNWvVLm4DOqHBytXRAZdyiJUq4sowoHvnx6K6osH6kWYRm+hQgKTYeAPUj27ocTXZgCrRNhB0/CAYjmNxaXbkrUr12etNN0xpiADnjoNr4cq4UAS4maTL8bM/qRHbbc9LFJRYs/nl3eUsC+qp2rkOauiOloX6oMTsrA2SSrqb5/V9ajk6lzqv6HtzHWsMZgMnq3ex6IEaJ53pI6BV+6hct9a6scaevXYyKkUS1lfYJ/EBGLE42T/xwTcv8oHYbpjA0dHMT6IAeX35wgDQgKzkW2qimVFhZ3i/JtXkjLVtJzZYS7kqhU/U7xXsNFYUnXanqgmn//R5GzmdcVZsRWFL3+nt6YmRl//FeIGJ/R+8KUNY9hBN6mDJZriXLTTHMAJyT+KzQwFrBwzrRm5Rlo9kIS4b+7JeXyMUpQbBTrmSS95LxkWUaAYVR2qxhNu3ijA+o4O+4b/0FoxUnPhA9Kg6OjVBLA7rmi7NeZxhvDdSdAkp5UnuJrktoLPJUf/DtxzYSgk1Pm/97NZ+plEnrjE0i1yS6VF+4cwiZDymtW6AYSPCpjYA3ML3LaaoAIyKwMB080fSQfT+0RBVbknKa3ySTM6nGDbmm+66FuY6KsJYVdHmQ7kAwV3O28J/Ynu9iZUH3XJuwHHg/dQcpdMlWENnIVidSzmFUoXFdXVlRQmVlcIY6ORXPXu2r10EnkqTWf3bZXY0oBjIa0IpAl0klzRhb2YdbDGYRqOzNemreS4WqGtRddSzG8/Jl81ujF9ZVNKU0WiaXhRv5hD+j7tdgfXz+yfwCTWgSmHSripHV80w1yTLvEqPnoBIt1Y8GTFOW19ATY6AxddYg8zzrut2aRiD9h3N9X5ONky2arD/KnH9GybbTy5+1eGizX3xrEd9xQpAeQFcd6jhuAitvEEilaTiHj9d/oRrNW9QDl/8B68IbNbMKu3monONVkNfqTTbBP7IzxT6HddyMfkFf22lUWDu/cpByjY3XuGnOrDhkDV5sx4ds3OXOSRb4m8bskawzOlJMwX/G4Picx4ic2Nx98Dh3IC7pT1lnE4eOydQI01XVk7jTRsfHhT7ZETBkn2jaVOMM6FXPYp5rULlEWrRHNRX+d6HbH0fOTdWQILgn7ngqFLTtqkoUCVK4zA+r7NzuHtEpa7F+gVajqguskIU5x+Hnh97uBRtm1c7oBfz8hCtn6PDgTPK416dUdpvt62P8Bp5MxdmB5i0nBqutFuqZFHz8vZ4h6DK+xhDrDPwjSwxYvnrgDMXHIxK78fLY7BbZQMAGGz+L+cdJAIE3BLCHHhxTqq91SJSLDMNCiEJWzis8LTedGRxf01E1tQCyiGsBog+TKOlcio3UYrNHWC1CPzfIYpDIYoRT6kRm6IczIuWSOiHb2t6vhB+jMR82X3fyBxfuqho4XMvDi3y4Xp9mTOdCd0/brI+LTHV1WKUzrshT+iXjcBDYqoFC/a/GfieMTBiDkuf7KioLgKOKlM8e5TsjGYHjUg/7eY4AtgvGjZxIrkHrZdffPqfnkh/AVRboDY9ymLG1Rp/a38bUzenRzFmoQrrItn7IoCDxmnvBHw9T6NPFurrM1VhSl6U5sNJqCrsoLvmNpmO6XVoQBYC7wnwGOSaE/WgFIlqLrTOdbTJj/FqT8O2uHJtEHqjM2O26Hi4eAlviCJvzHrnqKCfkYMXItZUclxhLVg1LxDEmZGRieOZSwjU+l5S/0f7SVx/hpJS5mi4yEfcBI2kJwC8/CHk2JfxW52lY3DDluwslk8+I0wuPDSVzmD7DBeg4D545PlzEWimnPOrIcf642zJLRgkgacrlx5Mok7qVq7PrxC29kJEEyme1MYgjhF8UB6QzhJm+BgsWoCCSA1ALuq1Pre2ej9q0LqXxJ00+4e3VD0ilKiecdnrI/wwiT+kMlblDoy6bFj1comMw7pNs4bcEFIu0LtqEEtt03j/hzKL8cps5Yebip+XEcNXu3wGWNhoLw1DiB/fwY7brj9yGl746R2Nge+mB32S6jOM+6pmIVQ2SjpqOnb4wVWNStfXyyrOeW04JB9pvjxDb3Y2sYkhhhcjKhfahIKqkbSgUQCccI57nSgztqgHF8H+4v6MFMFpUq69/EB3Xjk0P6E1qxQtJIMt3Bikh4neqOtc3+9e7jVJaxqtMNSWAzvSZysH8fK1vLh9B2ykUayAy23DWE+HQmF+7LTjv6rUdV4uRF1xtBqVYlTuTQ5dbq2YTIdJDpdoZuNo08N9D16VWBMRV9TGnAKJheLqXSDTzmKx11c93s5WbJKMizPDW5nl1i2xQPLw++5ZgK2482+OW0ZG5cgpZ87mrGT+nH1/RAo4FqJUMsRbxTOoQQdAsuZTOPUdcQOrnpwIqkRU10/ISvxuoSBpufMzcmI60txAbGbS02Xfc47/VHR40hlYWHMRiE9xEJ/9/81wuRizLdJEZ3Kk46pUnr8e5E1IxWvvBRmlSTjbX8aun1P8C8SnQTmRnILGhyA+JUZ7vTbKzn6LHxI7N88QB+qsxtMrjmhAt8Yr3nLcGI+M59vPLfO0rnlMxw2TTAyxfxr1lv4q5PQiSRDeSy1rGSK0UXBUGK4lHWJ7buIxHLF0uIUH6qW0hnpO9aXlDn/SR9k0Doe6kwmhKI7CBBzBsK075BrxSlimUBF4ezFOE9dId59Bjtv0l1tw9ld6OVpFhoCkRB6NxBFya+q81OED7PEONOpx9eY8wBVBOqwh9615akOdbahyjQMYXjtUPA/JSmgg1GGjqmIFi+P7pctQlafrUt41YwROQV9xMOv7URTabw+2sACPf03K6NjMFdQYSqpAMseIEAqN0uhyorhvNBiQWHPpczvy/siard/cybTiddsjrQB80SWbA1QIJosWSecviEVT/G85cvkpGTJvZ7JfoCPV7+q0XOvOx4mOfpJUFZnxCxwZGMBT1ICIx52kRHbhN1+MZd4R6aXiTSU3YXVfnUMhG4lx9VnCJiN1uVOcSkCKGYwlyOi26guS2ynM4e/d9xRVx/n/XF+M0FTasXt2/PrbHK1KR1N9cqebnKHB4YdxAzwEshwY1LxNw+/3HhIpluPCjsWIP0osnos0uCuo41ZpC2N6QBZvF/kqnKeUSJf+InMCSGvU/Ln+StlCXcgTLBJJTKUcIt9bE2XoN/c2NSnDiTYgNgsnp0Mfac582GfJkLXJtdW5HQApj4JRnzc2lq4DcpT7ewRk/eWQBS1pN0+hsoX5vxjs+XWJXze4naDi+dsH0YvDJjwwv81jQaKPEaInBWwfkuUy2K7qt6DZdbKHJJnmZfUNy+67F2SlHaVe50L/EGwqCCV3RxDFH5D2h4rWtuwEsxTroCWHoWnjp7xKpYsOInc9crFtDmati9wphoe+J76VoLomCBB8j3aNHZN5GhlCss7kn5Xhb7ggp0Mg+T0Qn8b1kWCETZXdQSt39XHapEu+fFKPV67ANLmX6jQHlAA/AMt+fy6x0Ycd4pktp8OQR33CSdAMe9V019PL43hET9fmOl3xd20wF+zCcHnvc0RHufx4GhmhCDM0SuWJ42YadshWS36Rl3UokM4aK59X3xImHTzVLMSqM8QD9hJMwMlA5VohkZL7nCqYM+wMzw2S8HaaA3NSeYvc54MwIn9I1iBTmjYNuh6oG9h6GosZ+fsOagBygDRhAAB6kcrjA8NWiuk3aJhh4lvjjV8THK3azK1Daej5/igKOymm8CJfFkCEy7QBNWkgHp7Bdsrt0wdj7PGDJfcO1rodnzHlOSLvZVtQ9y4DcWgD4K1CHgrp+ZS8OdNXOOMmXRjO1aQjul+Z+ZHBJC4JcOrfGAmTGKE+vAab5U8aDI0uFetjKbpbwf94HWBI691wtfnTiTQ0xn23FiEjdr55H0rqCxFPMQ1QF/38m+ZVZ0sCbCWJCCce0lbV4arPkERhDE6OmEVk0QaD4Ma8SCOPevTGwArCcj4qbRNPn2A1DdJWpBvaTc8OmQytghqGWM3WaRCJDcJU8poOHZ8jStRDYqbwr/pIRbVulm9iYpekttcT0uAPz2Wb7Mun00QRbKN8iV7X3vEsOja2OKH/NkSqt3GbDovkroH4pdgtcPhVGc1lITIABGeTItaF1NOegckSuZBgN+8GkoabuYldoIcfftNSEDnjk6BwTn4lfYefLIcwAcuCBiU9BkkM8DdFMJKkjT1BmSlPx9jgqlb7PStgymmfo5dgKM/PxjtMUvyCtuB/byg/7y1H9CjOChy890j0owPHOH22lcWLrO454X9moy2jZCmfvJNxAAxjqDdhUkkez7UU3XHS2es4+1mwfxJXBQXavO3Rl7M7IflM60muWfsfSsTaZZ8iR6ttv8oGe/K+m3Y/fk/kH2WZJtFxBXuF5STTzvYwH1DwDJgM4LB6LGFno2Q1dEsqrbHgAJ4h4eG/Xw5bwUdGOAxGGdXzhcNOoYlBKAV7YCD+tb+CHVz8uo67OHK10sngFoZ/mqTfSvgRTMNMUCgF91vjDowsoS2ldfa1t4elSe2UrZK0DDYG32fa8v4caOZnpKxxy5jSHm0wpo5lD40oOvRFQCwrfiPrRT80ArMaMSkns8PmG1Mwru05ofLswYhUfIM7TsYxfudGg4XbfG9YTp1E58kDsvCOlflOS2Ep/3EeZOwnqKYtx6A8z2ndUHL8nmQIqyt4EbrA8awKfr5jxQfg5YVAGYmD+YDKtMucadcGBhxKzgUTllPj2n1rFdWkeZ/3I86kOIFZWseLEJJ7iI84+aqYWNDF9U/O8wSMxJwVqtQgiZXrSMWXA8dR1aDTpVrys9NNkBCyCGZNS2UIRDCWcfgPCHSXNBNZ/xeMI8p6Hn8ZUIpYdfI4l/jvujxYbfDLf4RuYCc1VwxMWGdp9EeXm2MmYzx3Bt/0FVIG0Os+RwZs2/vtuImq+5bh29QFAio6gjyFJv4khLf2p422KxFZ5b4rC8Rqf7ICUO48MHezUO5B3RnbiNUl1z34+wGAZDmnQUTMVybJamG9+xN9dldJZt2RjAFrKUpnkcaoTiXTesbI0+gy/xqaZG83+NW5h3lttAzjUbjwnx4db0OocH4acXnyfjBx4BRvsSjHBa+6FdbPpEHFnRoIwvniR+JBtbngc5Ue1M7Wg7WWjyXjCSokXdYYtacqRJabBz0lSol7eCOuprM0ifxypOdOKIP7xx+EX/CVKXJIZaKtnVEN7hQ0FPJwvIUCRvdH3AQa4nz1roHZ6YOtDmjAJxaeKDd/VHBV8wKe+nZmvb82d9Z4xcF/Z8x6UTqJ5JjnOypFTJIaFC0rx+zHGBX7FVFYavMvJqrWHIRlAA4B56pytIqoedQPxxiuwdUSnI7OPh76w2D/+UE6i59JNlZptQjwVce9gNdeM8fqDLWQPkbN/G7tvZvf5UO5zdjs32sgFLGdWUQMTwgkCnrCETNzfR4+W4eoyf8z9jB0oIkaCGkBHKzp6p7l+QbVt6wc4PE2b40r8N0fRxnLnkAmZTpIofW9/kPfQ3ba3euC2ld6O9sjwuE2cRqg8MG6mkEgBbwjv+0SJ2oZOgCTDY8ya9fSPntR+os1fl7sHYwel+5kZdhSBajVaPKranikB5jyrejtvsKC9CgvDDgeIWvjG4oFGwNodoBeJXzXrUrt/Nsa3jEyHJFNoCvwg//bcpg/xtBvi7STL2zHh8rW+1GrWBPkW+I2L9i8c9uudKMEIwYL9RcN0+eyEuTuEfEoRleaem2jTdTYnXiSfCuP5kO6nN7LNBDKoEo3K27rmkEWD9srgaGGUxN0XPTF+bKUelUcC5hk2jOi8bmbINOZNh20e5yFuTjzal3HLq2ZCwAg4TN07t3G7KwxZstu/bdgXKG2pOu3HBrU5b1dhdYfkcUCp1Md4NR2fiIf6QgRryJBFtk44Z85lNApX2eFX8JCEg0+kmrPMDFDWBAfaeOlbIIRuFXfBZcBwH9gMklzeJnkoXmQtRK6tMF+FhP5OLz2kEYIEcb5jhjA7nMyVh8HEZAADaV5eSiGdjQQdbkMA4xISkC/Y9t7kAl+xOzJ1/l6vrZJrE8XMz4kKuRaOz3gIyDSQjTCzc4dwfi1oML9K4UylmYixwwIqJfcBaK3bvTUkLsgpm0+xQUUgt6mw6ZhZPyxNCr/9+JNejy1j3WlfKdfXn4n6C0saKKQuiavcvU7x+UoUbWrTtR8xTHPfRjOCrQG5QcIF+wQ6JOladyoe9MHMaYLh95JBgM9Q6U6+OtK10XzBM37OAOS/d3gis6ak+gdUzxR+aRhn68L8k0XB8gY9tMN6Q+rwaWpBevQfCf4/g6W/jexMOd4v2R0a1frTGKT2n2ePGenVbiWn28IQJ9W4LgWPNRdpRKuHMF0udR+HXckQd9YI4ocA5Rsq5oTAZQdyxoo+aKvM1XdicGzhJABTBGyi+Ib47BCqTxVJV7hKWMuZfdXRP9+1sBOLJHimhrvqYKMfJLMuQWbDfGXGqjlEeaSCOrPEZdstD/jfkkSgwSFWSIAZndqc/i2XIy6/TmdHT4G4+fiHB9P9aSWLum4m9T9DZU38EqP4jmV4F7cDhVJEAqJDvK1oUxE/GOoKMsDoYocdfXLATsCJ5F3CW7rFfngoDPuuRB46B/R6MimRcZJjye8vzc0E24jrctTrUq0chFGat1lU91zI9nG6XUICgT++XSGOFednDucyg79LA9+l8wtlPRJsv5jfJjHM0+vjBVeCHKyNlIofN3JuQff7xeUxDN/Ozl0hKzYGeswGItWgAw60KHV5cEsVylR9TVdyOtezwp5HsKmT8xaoFYY8L7pdTV3q+Le3Yer1zQgdUmlhb8yjj2AcCJMqgBN0SWT0OaD/n4t3XW4PgsYxUIYKuqtzzL/bh9ASFFqBJVYxyC0IWnHXtDbYwRehFrGDEOxD0RbAf10gS9Y+wtb9xHSi3CFY3fRo7PUV6g7tcpr8rQNT7k34R92qnMUZrDliouBBXlb10+O0jsIHCfmYBjM2tbtP0U/iJsucBWrIfR0qHbZYsMmEKYuV3tu4+ns/71GUPt0GDZLJfUtNNJaUrGRCUCtgdoeWRD536sVOwROMIBAeGi8XLCG78izSf/nbcvFzrWtTR1Wo/5GnxyHPiNqA3ccLEeCwl1D4kpQVUxK51YdIG8fWSGucCvrGuB0l9yoYujvyoDDD+P/CO71XU5wsZ1/yku73NUILHsXMRRCJMakUntJYs3AnnPBuAwkT43pi1Hqgfezuz3sNOEmleEUWiQSSn9Pp2MKGtU486Gm/BxCHbt9M3PlplX60zcAV3qlc30Iv+gbXTbWUHM+pd2bE6wyZVqYbGmt6IRFYH1/wAH7vLbqw7+73Gumzw2IE1jheDEmj86wMnszP4w8cf7+Ezxqws+JMxsZiv2pg+MCv0pYHn6dzCSIC4VeMJ078bTqjcVdhCc2z2ktkAIrsHXJYVzflzGuowDTfgk6O5lU1+vnZNZiqKgOLVWEYR6gf/eHvOauWOkM8KzJ9tv2dXWxPCV861TwEyzzJBSIASjqDW7BrEOejC4xcWTGvVnoloPER3/+e2VQvizc5KYi0RV9ZvPql1FtHF7/eM6HZSbEWryWn3tV+GQh5VUD/OpI2osi+24Go0oTU60AB2bfeQ0acwyhCOfNHLLIHEU0MoEnWGpBXRc68COjmh+ucjF44btC6nTsFJOz4fFQfWOzIzPpoYIhHdeL3HGXDUnuD9oGsxAPLa9yMs2w5mgjs1UGHr4TKJBOgOj3VLC3jLA9qpng9GnOuaTOmPOm3G36maO0CIJmSNCYz09v8gA13ToS0gu2pj4HemcBN0IyzODgF+Sb/UFFWMjUA5yunZzwVSwnSDmewXg1kXWDwOPh47tmApjDOBdLab/sLA/5GVM25Wtagnc121fSqJxcmFgqs06KHHpdJgHmPMP/Hyc09Li/uKw/41pDdeC30Oxf5rFtmEAlynnY3qXmafCmKpl5LSCx7EC1KgHxXGRKhwkr/iHqlAzoYxUaEWaVdXjKLup/a1/gDi5GXGwnWRqN7jTWDkouPkhIA1YbVj71PG2GOLWKcH+26O5ocZ6YN8Wk3viBG44rpMxwS+pwGu10B7SsIDIsh2UvHJX6zl9dIZYBdd7e618RGsfqssn9T5aLtDRg2HbRudQQesclc2tojvdDFeiALu2a5GkVgLl2rlMVbJFwxfm0MUOQNuE31cYtVAhz4A73YUCM91I1syRSoBI2+mLxAHMWL9c+6qCC39l4+8SWutpNXXOe9mTp5Ewb/UEFJW2wy/ml2+O3u5kmG7vuRZN7GAetwSn29SwsxoSK4batyq0hEJytN92cp9oxw1Uj+zE3ddPwL0Da+5EUIGR9SDUanweIy71LpPoMm0nOZsTlZfP0a6xeYmMNGOWtjj+fF93Nufi5Sv4YzLvmXjGidK4UmbcwUfgDs48Incf44cpypR1S8WkmLKD3WcorAUYA2gTt3vPSk2lnheqojOI39yWt4LYeuUJnb1n1nlz5VR2cE+M0tnwV3v/qBP0aNtD5+37QJsyeoY0I5j59miXyS4A5ZKBJQqbhvuBl6W5lLsSQWDSKK5EUEswd3BZehQ2LavnLwQvJhsGTxAmwKdR3OCQU5JPo4CBnxNju/xAbtW+MsMe6ioc5Vre+PJhzQ6l0/zyH6OwLbmoTcs9nRz40yWO1Lf+ZDeIJyDvQyWQUhd7u9DbUSc8CbwbDIYkyzvscI7rpzB0m0KM7eTRuPxua+kP7DV/JqpmvAVXnmnXRBOLcR50TLBg7ESqijF+6RnpPgCQd2oA==]=]
local src = __meno_decrypt(B64, KEY)
local fn, err = loadstring(src)
assert(fn, "[MENO] compile failed (wrong key?): " .. tostring(err))
return fn()
