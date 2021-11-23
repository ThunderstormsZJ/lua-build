local lm = require "luamake"

lm.arch = "x86"
lm.runtime_platform = "win32-ia32"
lm.defines = "_WIN32_WINNT=0x0601"
lm.builddir = ("build/%s/%s"):format(lm.runtime_platform, lm.mode)
lm.EXE_DIR = "publish/bin/windows"
lm.EXE_NAME = "lua-build"
lm.EXE_RESOURCE = "../../compile/windows/lua-debug.rc"

require "compile.common.runtime"

if lm.platform == "win32-x64" then
    lm:build "x86_64" {
        "$luamake",
        "-C", lm.workdir,
        "-f", "compile/common/runtime.lua",
        "-builddir", "build/win32-x64/"..lm.mode,
        "-arch", "x86_64",
        "-runtime_platform", "win32-x64",
        pool = "console",
    }
end

lm:import "3rd/bee.lua/make.lua"

lm:default {
    "runtime",
    lm.platform == "win32-x64" and "x86_64",
}
