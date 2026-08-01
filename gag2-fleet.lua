-- MENO locked: gag2-fleet.lua
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/MEDx98/meno-gag2-load/agent/gag2-v4-5-manual-queue/gag2-fleet.lua", true))("YOUR_KEY")
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

local B64 = [=[nkK/4I/py5fgGqJRcRSrGHUvOCvsrJdcX9ru06bY3Cb4op+i27/jPL9tUlp6GPUo0yoaFlPomTA5hiiJmTWGSDCTeR2swdivFSCPjv7XvMpFOYtKHYES6WeU+ixUBlUrxpaZj3yGNC5z0AMahq5kkWHP7TZyuxnv3e6Noua09gTZSdfMRbWKpT1OyCNDxonK/9hucNvZa0CvF1IKqKr20iEj2UOB5xjo62R5FUdz0EvJm41va/+G1pk+F0dpQb+lj8a+0AtYymidn7JrBXPQLi/nXK1D3wawOd7rONLJHp51+FTEU4WUB2x0By/gXDidywL4Tn6QskF0vkrYhwIqSAA3m4niNWWPNOFF2eusxuGAI+nOzyJiIz/3LauHj37PCwGZvYBzf8RTxYW22fTu4Kte2XtjT+wsWCf/u6eHYjdPyBJciWKJNKFBal+3ShxvuHNEscCXOjvU/zWmFkNJWlwXyCcgXKjVwZeRXi8jx/PVvgFnaLQJ9MET9BRBw7sX4Qi8gwLmEGm7wSmA7XUV9IsBhosaEPUHvrFKe+RkyKhQZmotgdD4wzRZ8nd3PgJDfo3FPIqrnpHdoKiZ7ufNqKOP22K3HsO72b0QFMlJTRgcf8noeXw1xZ06rWfpAATYtmU1A8vQS7rgUOyjfdCRre7nAPpJH5INUSN1nnaI3Clul9YREmEAnbaBlb/aMcP6v9orPR1oOHGpZTn7Zybn6gngD1YKr5uuv8ITHoK28PewNR/bd2dRah5gVTNaqetSmA9XaELqvWD+q8js5KBYVFB6d3RLKDvpsh5drJWOP9ZH9verhOy2nqM3+WQq2YBJ6MZgkqhoRgSxvbatGfQzsFVxAG8wubBfkylXcZ6ZOZGr1sXzu0i6cdgeNc2F3CoJgoBJiQlGGV/Rtit2ef4apwus2ULGZt/4dSZPuLg20XzDPuAJwmpV5bIOp5DA8FMYq11p5VdqypB48b3UBBfYV0vTsvrUxOEdniJh2h+5tIq+Ms1MTqM0ueN0SLZHJKdF16h9DsfArJI9t6+FkJUrLHIun9pe6h/khvTszQEPoSoA1OEd6Mle9xLUJJCbP84W2RnK/6412ZB+SdzWIfH9Tr7s1O6MbHy0fhr7aVXSmZJtonFhdOauXBxKzXdwzunLf9kXBDfkeGpNMmFIpBIjy5ihAfSxiRYKfdPlKndnMXJfKGj0L5thB8ArLmwvVve36F9ov69luYIbbhU+cMuFNwKFhXipNp1aSZyrcnovJLmx3fzzk2LPgh7fZbnjwW3YF+xfQLFGXIA+Op42i+sdax8eXmv3UpIiqeG/qWbJ2jz6DgMtmwrXz93eT+9eHzFcXnMJrL/wxi33hiKQzEBCpkoLp6qQpLNA/7pLWyKl0BO4Gcm7vlhQzy+z3bBCFGkvBnMdSjZT6sDgewv3+slnVcwyzkaiOh0nHXyWpmU7dscQFRKclIUG3KQBK+GPf/ABqmpxvMBQC8jO5VTXOpZmx/1m787TXeCimSsDpE70ehlboioGC7lF5ANdzBmi+DIUEN8pzHoimgafJgi0r0PP61bJl//Devn3WKSMoynMO1t3JETvceMMvchkJRroY6aYzSxLx5sVXRkAchRECcW2E16sYM2J5Gg+Ze3cYRobQ6fvDAZx3fPvAc06ZsEgHbxb5gKUPL4xB1xkeVqCtfMTb3jZRMd6x/j1K7Zd96yOb2RwHv2nJ1ombZYrnrthG7mCTRWIwnTC/cXK3aZ5u/Vp+CJy8HmMA4nWVMnep3cQyrPq/d6ZnPZp32hqa7Px1KDqHyGmePFRf2tzcgnszOxn+KZS3a6gU9OrEK/Ku2L9nB5wYS8nvSbwa8K6P4Hqyk+72fQpWdx5U7anbJt5s3ZQ4roOY9WJiRlOY+XrUE3aPPyDum/GDiZbJYiNHsbAErHnbcBmvGPIp6mwr4DxDmSbmwyX/g/3IikiTpBAM4v9UNdGXaKsLoLuHQ9mJQR7giIXfkN+Ow0YqCStIQO31jrbV9qzXxydXBf6WYHgvnmTxZxFWMs0B8rsyiiQNinislm24pIilW56C8CON9D6w/zIdMxLBpF6hwhkPRNejuhYfNqxMDrb4nOTcqFZoQD4fNMrM/zk+ku+xRFrQ/d6eZ6eUENpeguOGSQFRkI/Vwibd5zAdKKQQIT9015CCUj+f/W1wH/qw+JG32sdfCWStF71uS9O32f4ngsgWRwTHfoYoA6Z4N3d6JadpgxKhEI2GEhgaJkxm07pd29zRYthtQlNYvt9qZQWTRdaAnF4YKLekl1kn0h5wIlpSRPUTRyK6uVZloVWrD8WLmTm+tw0JZRZjdYwFynBmPs7GYw/QelGhff5SP5Mhy08PMFwqFq/FFNpjB/CaMbvhHKqACN/0IlLRLck+buo96dm4MyMmZZOpSfMf7cSq4K30+kMjiQB0Iik7dtxO886bc0ll5z5CwDNMvLMmancjs4HpdbbAftfLGSUl016rZWtR3A3MRNGWw4VXdKEm4dQeVUSVq2NkMOmnZs64YSk8+jlKrcDgokeBEciGFQH/83WJZsAuO0Me/TBeFnNn47jHaJI3AqUtb2cDzuH2ExGi5BP+100TutKkULSHfcHjs4z+LVnNfGAsu2HqpNi8WVUCCSvAh0rpPzz3rUivofEZ4Op74jVwCgeEwarsAcOn9hBncr7iuLjXPh98jlXybDBWsPM7FxomwEKN/OeHddIEiuPp9wKgfZd5dRBk1cSxHGo3msTCKe7llKZPBvovWElXOIUxkXWbMM+ThCXZz7KQHZ3penQ0jxvS25XBWffP+T1/l+Jx10+LVjUU+aInx4p2BgBNFFj+czRI4U5mDgFE82To+VRJHsb8wAgbVjPZJigUk+ySyKbM9D/JnRP11OJc8DVEG4UWkKsYcpvgjrI0nwAH1G0t+7Jy05f6HlQDn9Y3EpqgSm+e/jGFsg25aeOuOeREFJrGTAwc561OLMY+xV35+nILi2S6ZqdEd5ZmwSPA2mB2vC1P2wWVmmCoXue/OrvjkmBOymd2QEHNIpp6Fb8CVbwN2btb5z9z6khUcls/Am30xoFedPVWFnEUAPLQ5o5wToZfuS35KaRGK1BY+/CesRjAadhGhE5Q3JwfD/nQ16k+3tNQYVtG/Rt0Vi1PGOJWq3hLxUrmuYCm8jwLTPw+1tPaAKkVNr9S1IycnmWXQClF1tHcMHhG+Felj8++BvjrnziCuxc2RH4Z4Y2RP8coiZmfN61l1n2n1TlfLNYV73bROByQ4S21i1mlq33O1jh0sWSwsVtgsUcaVumX0asMOpoWD6DxmLiLt1Y8L6VbHPFpf78gSSozeZBqP2HV859lv7kV/cJSUbeAJQZ3unFfXKBaJftWupXJxuJzDON+q9eTEAvB450i5nRrQ4+cv7GcADTHt25IYpQOK0IwWO25OaDowhnoP/lXaswqWMquVDJ/q2JkG1hsKtEWD805yx4JK3t43fsuraLFKFns9CzoVOQoXU+0gWCY9FTZ+Xnd1NT7GSRYlOVZzgSs3hT7DEGbTijtUIkFmsUA8mqiJPY4dQYaFjixbrN1OTOEF57mEAlBIOduEUV2mSFpZNN7cKwXsrbAEkIBZP5YJzyjAABZNiLzwkpHCWP08GcFHaTtcLed7S+2XTAfrRuWN6yPLY6oWXFTO6AyqMF9vwllCMlL9Hgswfltxg0+Ana13iRwDZK4oWh2JucQ+rDgnrg8X/E8qhNuS4vo0RIYujOvW4WB1y6omzCcJee7zI9IMod+ThS1sQjfysn6Urh3M+8i+NwFN/i8p3JS7iYs50QcEVO5z2n4DRdjo3RyEATIkv0xYqr1+GImBJOwezL2ILOp9YsXOVsEsds4HW+699sSFmBB9VU3K3wuklNK1ruhCx77F75KFTv0Z+FeY9eXTN0Rvgjxd9vGhLI4A3ZXzPE9OgwBPCeD1rSceqcR8nuwtztwa6dF3yG1aUx5r6uCNnFfKzpT+gwkruUeR8BaCgrTNU5luTaX7fs22i4Q2DqqlPNBWQDy4GNxXU3Q8SnSBgY8wSz+m1LTISFNCOLiqCNw6vNk5XjJgV6ED+nem9rUgwVCX588p5LQCM7kwHvz9glYQiDAVfhFx3XNvEsoOHIT9/5vPeXVdOvJ/DlUjbYMxPKxusoShpigkZdTZvBg1R5f0WQRwGeiQeWgOx9k09czfoqaJgDv8m+wqTVXnjxgvOE+s7CPdJmFmCvpvY+9IniSjf7D7UZarfDFCF6Z38/VanYLp0pRFe8HMKWZe9cwiGFueGwJX0c7aBFwSeNAJjL5uW5n3dd29C06m6bMZdMLT3i5yc1Yv8f1BKDW0yqO64+Uc7nn3TvXU+anHUxohQxTPavpOOS7hlUuFLhYqPry0drAW+AfUdlIeO9wL7rCmYntq6/vNogtqMGyhHbd45v+9Q1MfHpWHRWQLtMk4nFqH58snZHadDrL1yBspYzGPK3q6i1/m3/A81Z8UwgNDIdAblb8qYKCmpuGvFdyxolTRE40cUFTe0hUr85f5gzrxppVCrwoonrN7kJDEtBJWOiLZvqSnPtNsfYeVNp92RsYmlM7qo78ALUsH6tt2SiKjxmZynVwKX641VNmlDriL37E8bLVtlQgcLFxOJlLlPmj3NS5H8BkQwuu7TrLI3JWrGMkUy1kuFI5E1eaVt7T+ZuDOKQzkd5wVMVM0I+2b0mfg4bqxQABH9Lm9DKKUJZkH3Oo3I1PHkf79RWxg6WeM4R8FRqV7kIdJGVq07awSJq4EUgNLMxWzbg62dgdCIm5OZAICljS+EIDbQdwUAjkRpIoSOtIn+pavSetq6Fhk3axCDS2ZZy//ICRITv582Ijos1df5Lrk6luNfXoUYhaP9g54NKW97Qtz6M0cmYTcU4hCQCUmJTXmHi4SwsAaDrxKkFNxwpAZGbC0pyE3aPrkt3bL0HMfnFqEoTkxkOgOgpWtKglTe+k0sm2Cn2bUm5fg/ZQHqwGeMNWNekj4w2KvCZcZYBYiGsbGtFsf+RfzKHBwxQkyj5uUPcfKmaFq6j8+SFpdCu3voEeWDQzWAdbEWe36vD4ZsREybffbqBMU4GXndaXOh8OrWvT3sV2XRAqXpHEGViByopTup+f0PnbYqx/HEZocnHbBfsYaYdLA4n/KZ63A9Btxhbi8hbHgptquDacmmQBcy4APYTClbI8flnvnmIN/xpB40cBgryxi3Dv2b90uBKKXaijecQW20biRWQodiRlG8R5RHVMcKdsjkY7Ll6dGW22/w2L+xYCM0q6TrfutXFCnKz0zwxGdje0GrToj+MtgFT1rCay9ageUC+AjU5Qt83TZYRQU8RzDIgbSpJFSzLaTKWnZN2zWbKXoAEl+UB1/dPD7oCsBS7idRVkMuvE2KMeNwwvjecY8+Ofg5OwEROWze/Y8x+jJWK1RGghAJXD3Yw9rJK/NPvZij7qqOEy/oMGSBr8UDtwpbw3LnTxNNv9ClqZx/dSlk7Y+Li4P4h8WaOo4a0MuzhoR2WR3RXqkP5Y99/kRCIJdkmetw/FusNXnDXJvfXbWHwdvKnBogR0VMNa8eMl2wqKH/A9Dya/eDJP/pAerZ15S/j5SSd0uw73urg2r2IAl023tXPQP3zwTZWvfbrWfnknOEwEZLh/Gv/SJ4Ai8PZtFk2FbqoHKaZXTTtvPpdjCK+wE38DKo9DEBzn0GtR4uZEyGfyY3vwCv8ffomLUz/lrlJAO43BLCqU0tXoLUzcrDTRY5h7WV3sRwcA3exYTpk4mwVmDCEsUAg2Ga4CcF8qsTdMPAYPEpLMyDAYd6Bcs8W90Ro7ptLLvONNg3alI3qkwSkKxx0Tm2/DHORjV4UdKT/o1ORCaNba95pdH7glrmwMlNIZYIZg7YznCS9cED9tJVG6+v8GyKMASfmv8fKAw4vxpWstNQ+3wcDL/DfayTHT6Q7kUaBiJwFmAioDLHdP6Hlih2aEAzkPoQK4tHTIduOjMrX1eSbgQXwDtmy3mjLqzG80z6CPWM0l5jmm/6Kg3p9tJ1vhvlARO53As3+i0WHFRgTEsSr0FY/ECaD9nNiSTaK8SCIf3ti4QGt1a3rdr91I8euv9+JTQUoaXHPJKzUII/rDh21acfI6+01rmE2HnMnhjosdmkgZ/dX9T9wxNG5y+GTdCmP1uuNrwh0K4kgHkU75w0eM2kNCsZ2jhQ43Cy26UFykMOPmjakRGFb3B7jLr12PLx/FH7vLhKdCsXuQsiIkANgACogDMnpxZ5k1byepqPExWOg25ET7DyUB6NE8hJcKfBMubOEYn0wnyCPEAcCsK1Ht8THwtiWGcvQF35f47H/MSOgC3z2Exffugw/WOkm79Vfoj+cMjYOt2sz89ZY1fI4NdDoC+eiN+gE8A7H3IjWU+RSBPHfm8ekMbme/QCWc10jhACGevHkOo7hiY+EnalZFjolCdi470PiwK4T36ipeCr8vr6supRoBVlqlK2o75OzMCsgCd8rkkPO0IiWaxJ0mcnH0aHzbtDINnRURCsVRoDDbSb5nD3OwkWAjtkiC2B/jYYdFArwwV0TtAgk1xNbMYJ+QXVxp3zUUrws/5zFxilSzalEdn/Ribi9oqveXJYwXUcSnxYDZwBOtxfDVeORgFWuZDD3+60qXcGHXhJvTukWzTeRQoNYrTtwR9kPy/oa0N028MNNmbV4D4piwRinAKJheLqPSCPf+71okfhdrI6ZMaosweDBzWRolyJbcexdnKBrIQBQ28WX1pGyPBEa0NbMEVrOElySEIdLqrYHoBHxTOoQCpkzrJXHf39OXbC922ctm1NptJkeqxOjSRhgZ9yyo7mWmF0gT5WU40bx29rhLzsIrXU/FtgmKfkiQZVq8BIrRCfAcplWnYg67JVggrK7XRULN4WiOR46Aw3kzY2I/IA731u+J1tKY/TkwAaOH82RLfTXvueirub3ho0n9b8Dr5i7+Q0i8p/9hPM8Fucw3reHXs0XuH5WklrtIxB6xKllp5frMxWUCxmyq1bsfZ42AD4WD6pmIPaj1PFeMVBvPgT3rFYhnoGXQGUCzKyRmSgxlcqT9U01D5+saQxeA2XPOMRUggi8JnUewk/AluAW9tgu6/YuxbJ6tve6PeR5hCkLELh2WXbXh6RzLCWYPljCe5M8cp8sB2dhtgcw7BYk+oZ/bhuzZ8Y9nsFVVrIWhgg1GA3TrtpMrezzPYc3WeSK6a904SjjMP5qZcT1YTuZ7s6AMUmd+nimcmhuCwgR/tY8gu5LS85FnDaZ41ODWxBlZJRo8t+Sik2FILBbED2de4GuamBYMkP8gC9I75GTZMDUE1juG4lVvFkaKfedqsGmH+dz5oM/Ddu7yESuhb9oGEl//SF9VxT1ICgtozJ6Y7pGx8FPWc56JF72c2ridBypa+RwwnxbMFmvhfpeeJFq4gK7TTM1PXLvpf/iiVkaKaMDuW5sqmraAqhxHC32G6jraueBYxyB1NdHouqqJmtvJOJMyQFlw0gkGyc1x9yc2LFSicGOnQM0+skdn+xqRNkB86l9sferYZ3f8y/DZeQEIPTNud2dC+A1NXTA/BjpGAX+QZJYOBUbnvvv9w1puJKkBXzxAckelcbz4cLGeMM/BL1iYm92cydldwJy5ocnioHilrrvkQuCvj0fQVQsHgd6/MI1+F1S8VBbdG5NjO4nfCu+cMmWBZC5gwIC3GXuTJbmKNyKdjzEkH/CEY6O2gh9V5HLMnmVZwIiuOS7tSkCfEyvnvzOGwyAAnrR2G9k/xCw1q66pgFHhFmNZE/gfTSg6BPgLviNn9xG4w8am6AGnwtrpqOVrrRsJImAGVAylbZHZNNBk03+pvd++DsR6wMm0tEyXlMT+aQtaHlDPwkaK9X/XH6jUJP7EKPMrJkaD0XRmiHQRnKreYK15dNKXPwMgX1L3dUs81X2QlEDphI1pvXyu2w67uPLixcjtVsUpxqpXHuY/TjTVUtIokEUWYY/gkJR6vaglmHgvJtK43QNWqSmq5+jkNvJE240XSnpt2n5htdWV1M9FdQoNrf9EOs71B48jmPzJaqH9uWeb/cV57Rz89Auw1yApIlthb9K60i1tdZjft+Jk1KxFV5ZAhOqLsiJvpOg12T7BiwRjZbbAY/vGRWdGHDpET1Ksjqi7E+RIvnzuRhzrxUfT1cFrM585PU+jZvCWROmdOGXndpKvRZ0boSuJr9YtfijPGygcRCtovxdRQYJc5ifXK+STWqZal7s2u53d2UTN4NbbqrMVjuGbxfhRLKwWtuQJAzJPeD0QKP1P+ggf25JkTNUEDulEDoDt0Kh7ijW5/NaxajN90KHaHxb7HMR2al5oae8LzxuLq/q35hJT92rViV6dImDEwR1BKGAGJZrdfDPrGqvA+aPopGcXpy02EAKNbOJec61V+OqdR1S8sn+XT7UZAJzJcoLkaS7Wuj403KzorZvk/0TZ0qlg5GRvqdw/I2q3Cqb23z2ZOXu3md5CfRFY5fPtBJ974G1HkT3nwbEsl/zhskqhR5tOEcOYFReIUFCIoBldIek+aVzLMTrNFCuY0wJ+9r3qYjsLGJnIceh/qibE3nvvAkat+tWd6/cJJ4CYvOelVNKwFwWcNtOIqEoTAIjQEj0vToE+4X4aPd/oTHEzfkhR5GH6fcuhBuW03qn1hipmzqDCDqFyhkc3nZv9PvrcEaKVUvTbcZSdfOZtAO8el/DErBoI1SmEc8dxG3X7lwxcnO2acM13RR3uZHBSzOyJiAo79TTeRRC82uUe4yV/XG7V+u1jdQQwLK6xp7X/qPi+JJi03AqqVNYXOd5CATa4owbuUltCDIbTXvdLmvO/i9sYOKATiMLLsdlKm2Sp/70VcyXEB3KZjuZCt+paHp9VRiqPhqZUtfsdwkQg4XsJohwmFg/m6rXkgv1gmpnGepVBQs5kfDCohxpQT0SMek6r6gBHQkPaq0LVM72xPCKtON3VYbFOgsgvnrR1wxQy/JO6AUM+FEIBSr1otCEAekp+pPEf2nW0dS6oe8KlmUlOehpSGsBOsi4uMJdxrWv+nzRGdYFt0086Vvuk2CweVGS7VU89FuFLUWOVMo+wmgwwTRGBPY4gS43wZsRZ/UmdUm84N+3bNoMUxA3A0jLRR6JfqVfdNer/3qoiULw0Ifa1gOoUwxtCMnqy75JE2R9zYKRbLTGYoZYQ7kcNTdqcrj5knVpAzJQjzYJcU6FHHT7ye5PAVuoAIKW2fxBagbNUss9xhBZSUn0GxHJcwzQG4Z0guRc+I+b+Y1JfthbKIEo5n6h6mpheBPQ4RyEDdc65GgOGMJxMOnmm9TW3BjKodtnPPq0N9/Um8dwmodmLmvGx8Jr8lVOzZbtj3MGv5thaa/xpx3v4WtVU8WPpyil2b2uVKAjLt/1IapKehjVcFRlpAA3gWocDizSbDQCzvse1n4GqNdektIa0S5lBknbWcO8PdJzin/Us5Z9/Qv+j+PKUozvPjY/9mxKIwP6TDN87KY+toV5UNCwf0fG0S5YIWWACDPNbueFPPL6FGB6ENZks1qN6Icsa3pNz0LvPZWK1lmZwVKpWLsqRq4tVqbEbf3h7S5850jjQ+nk99coYxy4dL7OK7Why6xaqGkPPsATbv5mTgJqjlVPGKoADHOzmNWqMDqYsQZWikdAD/VelzAJ37eBDd/VDg95jf+LkYOzbcHQrrxdF1uSyi6ob91KFQuZn8pzB63bR2bM1Rr1bkD3bm0R55nJqrWKKBswUYA4leXULLYOMBOo1yDsbx2HEZ2Gzu39jWmqcHyHopk0vPJ6TTFZY/ltJJyAkp2CPHEWj7g7Xec+NeaBQOUddTg6289ENChDUB8Z2AdFg+SWV9+FZ4+R4fc5d4qFpVZsKwjQU0BhDwJSi4MrDfJNxy9dDAKH5Rj7NlTZ4WPqgRzYV4MCOHJ72baX1Pn4Z66tjo221IHqtwCXItcbD06cqmUoDim8yHypia9EnGDrSIz23JyJld4qk8xNmvYANAGk6pJ1FnGXPmkTefPakjcL6TuGbVwD3eHuTl/CDwP2Nt/G4pRX1N1Ro1bYEXCTPr91NKXSmjLvWVcoHLk55P7GglP1ohmrvGGNh2Cy/szR0WnQb5w/9ojD9jka5b/FJtUOzIj4AcAhqrLQtDGGMgp3+eXD92XYYXkmXhaOHbv8mvjpBb7NBDHnXcTC0LL4gQ269s7wB02ejPdRQDVULK4DhQ9kg1A12uOhY2bDOrZcgWwVg0seHSrehXuXoidCwCw4Stsn8Gz+YApUvcb2cpdSfyind6LdGrMgeEwhMvvpakGgtasUMg/Nh6X1NGle47F8/0ExM8stMg1fgLNY9Z3Nix2tlvrSCFeFSkLaN68eNY89DmOIf889WskLyQexQQR6X3U0U6fsIluN1/klUjuiVftobK5ngHsfh8/fnMfZWBsedBlLDzyfwj09Dn46zjw8zDjjx+CLfTrfc2lO322f/5M5R5Wbg6MR6lKm5zQTwzCSp12zZsZ8fTwsDLVQrgXgtI6B1xI0JdARLOGfgTwvJIQghl39Lj1Fs4flx+BbLCVPVpiG8ZFSmiRu220yKszY2MOuQgUdTcMhn7vNplW3qxJZcn3XkBxaX3TDQCmf6ka9SOpXvzMRH8EIa28/y5vgLYz2+sxlioF3ww28IJSm3nbZP3WAXKKVDQVKqLSmvWJFgQMACh1thsX9gk2GtwYivt8xeerlcGxHGeQDH5FY/oTmyOpCM8Ji9BEP2MrIA7CWyGzDV+vQKz6AvK4BPt7jTyGCPhIsOsrAOgggPHXIVskRHsNb5YoX/zlNioPDawF8oIY7aLrn+Wx+Z2r7OUcUCHGgwKTTzDqUGwxHSsEqS8LKdrqsQcOzukeGb3WrgaePdbAEM7N1AC36d2CEsjNEfr/DK6iIIrREEr6zk0i1jRNbWpw1gYKw9DWdNW3NCSYNGInltv+bENSzYmKJsUM94i5SYla6Gc6QjDkxdLwZk1k6ZKNO87V4HF93S/shJLjmY9RFLySkQ8Kb7UTATKbOeDczBom+Sxs1TrQ6c2mmWfkPjNdhy6Z9zsvjcM6mWqwdlVzTrgRcuDeo6nGsG1kfzA2pSDqMXroULKwn17BWA4q4sEsDOhNw3/yjLzDb3fW6JEaCCqHA2YpWf2RwAOz64u9aH9jSyEc8bHpJMqE9Y9OtFAf6Mn9zfTQGlBV4VnckM8r2w4ljsraP9Q/0FMt2ZoR6aGrq2J6BSt2QtgYnXmRgNpf+yixSHrcBq3QASW36WsWUh5I+QEILjs0jF709zotZ7pv5q+o4OVPtTTY0y2lGQWrXtDbQ3w/OVtXsUaNDyxHRMQ0nTf0+xJPVy2DroFpZzPtoofJZ/xX8UNX/siNDjQWqWsvqi4FUqDMtucc4Mk633uO1y4ABRKnTGDR3qrIf10DqQIKJA2HZfVxPeu4Uzo7sTZ69zc2U/WQM6UuJYJ1efrPJVmN6E7at5WYVDUkGDeeLQ2pM2eoh2DinRTA+NQZyBWCqvC6TeeaQdb1ooSAIGhTktpPDi1Ox95LK844NNfX8l1Dk3P1pKGnVyJwOHPDdRmGHS7OI13pY3kAXsWP1hyff/uDJWqEWHNEvcQLi3sf4Ow9WHpyJfjupG4MuqO5zg1QO1PMmQloS73swxmqkbamz2HADMlLrUERbiAXel9/ois2dpAIkr360Hz2TecMA1bZzkWL6pr08o8hGwwQ+0BPRS7+TQMbBERqjhgOOV/xDFmc1JhBtSx2sVHL0ULyy5OjuYKXyjDt+ulJlLWKSgIUg9aGAmAUfU8Dv7l25tqx04q1qrSlmusfq05kJh7p3RQErjTCbWU77e3G9ZAwfRd2gwVosbs/2FmReZiv52Sajxm7fpE2OzXkZzdm+SuOFDjmnYGEKTLIStfKpNOqTOUkoKyBz/+KMWCQbCXU98RYZwm/TGD9OQHOPR5EnV4nPcKpHT0nDMX156KUAmfaRikwMhTwPGpP5MApU5/ah2VMWUeSSV8ySS6B9hH/z2s9/PRt/SEvkIN0cloW504OI0uC551Ri37HNUk3GgmUCVrkKGZEnPHY470qXB5YSWKHbZf33xvHClBgrYdqikTBLeKr4fFQfXv3Er7cOD6JOO+L9CzHaWGHq14a7wh7mcMudoipkkkSixQDoyK3VPxOwHGbOOiToG0gmr3w5XDexYme2b+KwE1rDeOJEA7CePGJN3cb6iB1mFKbYnP7zkaH+svp40r7zFRwl2UeJPR0UTykI7EzIByFAZC73Ml3XSyYwCXvwOJYUlZyIsXfvJfi1RNNqN7h4Z/fPGaDr0e9Pp8+LHX4FMEP/sqODHJBv/wKYO/W56JN8KCmjZ3TZ/L/2Y3/6OCvl4xIiHEh5wzQm7m+AZ3eWtltJBmlwQ2tgzyEECA+mnjKfi3zkLDUr6Xe3X54GBV2AoNPa8fhjz+q0MTO5aPd3niiI1s2XnxIa/+7BnrJPXimdMWCXEqOpdIdPdaYT9i43nkMq7tS9ARwWpoFCo1AnoiYTG5ow3lCJZG2+nM1iCf9Ievah04lO5OCnozZP7uSgSBliFbMrPQwTsYF82ds+vdefMwYRoVKlC0pmM1urhJESB1F5MG9XP55s613xYpwaDx3wRp3WTiw63pVs0gOoTsSkmfA+fcXF9L3SuCD28kl/6Su+rboFS/q91nV5Vx3sA14PTTwb/GV3gfTpsUnJ86jTcMTEH8t+Q3KrZBtt8U3ffO0tpXFpDAoy3EkPoJVD9HH/5m6zHcQ44krdz2o7WkpfCkCu3PMW5knsFqBx1m+TkyteffEG+BH0/tNKLHwjxImCwkpoRRN9+okpcrmW5wfUUL5SE6MqMgP+5MgscfAxN5+yA1fgFlbOJXPWeNjFRI150GoOtZrHwF6jeKAzJcngnXFJKpuDGM7ak3R20SpQQC1NnM5QnBlgrP/POQCKqQp41rpZ/CGsOQsTqMUp2G+B7lITYTVqlNBciDMYaL9v0Aczbk3e4FMJ4RAkQp3nCnDVuD73R89r/Su0ZgFWOEHdGgtlbKAqC1qvYm/3zV6VJ/JqYu64rc44jKegHCHm+Godxhbzc2bfgbjAq9HduuBVKclzJroPLMVxT/k8AHxcc6etYthTa4XCtKHIIwLgtspcr6kwXkmxJrifXgGOzt+Zj6HXHrcu6iCMFjeqyXgoKKkB5kTJTmqqGO/xQLyQzMC2V1E6oH4m2CAjg9keJerrko9MPYA7nbglobZ53G4Zz9HypjnuqSYB8jdn/RFXMVP2jL8RnWWchqTOXT/dePdtTqm0Fck/TSXDiTh4POh/CZIsXWN2gevt/amBdG4C7acqyVxIZUFYB5lcv9xP+R1x2qpopJB+Ynkc6vrs4uxVt+SArnTx980aVy+uPthbGBBnL38VL1QFdKzeqW/Lb+OtfrBO6CWzZzRxTnLq6q7ncm28qFNFehM5+F0IyK2R+PYXAQP2lakS6+DWA9IBI7OqdemBzaShfRQziuLoFl2KNu5jBLVzWTylRH94qe7rCezc1XTEcuvxNI0dC322h5IWlR3gDI6SwA+xzngEtg7F9DrupgoO3KwSq30=]=]
local src = __meno_decrypt(B64, KEY)
local fn, err = loadstring(src)
assert(fn, "[MENO] compile failed (wrong key?): " .. tostring(err))
return fn()
