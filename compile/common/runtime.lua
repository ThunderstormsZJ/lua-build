local lm = require "luamake"
local runtimes = {}

local bindir = "publish/runtime/"..lm.runtime_platform

lm:source_set 'onelua' {
    includes = "3rd/bee.lua/3rd/lua",
    linux = {
        flags = "-fPIC"
    }
}

for _, luaver in ipairs {"lua51","lua52","lua53","lua54","lua-latest"} do
    runtimes[#runtimes+1] = luaver.."/lua"

    if lm.os == "windows" then
        runtimes[#runtimes+1] = luaver.."/"..luaver
        lm:shared_library (luaver..'/'..luaver) {
            rootdir = '3rd/lua/'..luaver,
            bindir = bindir,
            includes = {
                '..',
            },
            sources = {
                "*.c",
                "!lua.c",
                "!luac.c",
            },
            defines = {
                "LUA_BUILD_AS_DLL",
                luaver == "lua51" and "_CRT_SECURE_NO_WARNINGS",
                luaver == "lua52" and "_CRT_SECURE_NO_WARNINGS",
            }
        }

        lm:executable (luaver..'/lua') {
            rootdir = '3rd/lua/'..luaver,
            bindir = bindir,
            output = "lua",
            deps = luaver..'/'..luaver,
            includes = {
                '..',
            },
            sources = {
                "lua.c",
                "../../../compile/windows/lua-debug.rc",
            },
            defines = {
                luaver == "lua51" and "_CRT_SECURE_NO_WARNINGS",
                luaver == "lua52" and "_CRT_SECURE_NO_WARNINGS",
            }
        }
    else
        lm:executable (luaver..'/lua') {
            rootdir = '3rd/lua/'..luaver,
            bindir = bindir,
            includes = {
                '.',
                '..',
            },
            sources = {
                "*.c",
                "!luac.c",
            },
            defines = {
                luaver == "lua51" and "_XOPEN_SOURCE=600",
                luaver == "lua52" and "_XOPEN_SOURCE=600",
            },
            visibility = "default",
            links = { "m", "dl", },
            linux = {
                defines = "LUA_USE_LINUX",
                links = "pthread",
                ldflags = "-Wl,-E",
            },
            android = {
                defines = "LUA_USE_LINUX",
            },
            macos = {
                defines = {
                    "LUA_USE_MACOSX",
                    luaver == "lua51" and "LUA_USE_DLOPEN",
                }
            }
        }
    end

    local lua_version_num
    if luaver == "lua-latest" then
        lua_version_num = 504
    else
        lua_version_num = 100 * math.tointeger(luaver:sub(4,4)) + math.tointeger(luaver:sub(5,5))
    end
end

lm:phony "runtime" {
    input = runtimes
}
