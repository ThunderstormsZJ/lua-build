local lm = require "luamake"
require "compile.common.detect_platform"

if lm.os == "windows" then
    require "compile.windows.make"
    return
elseif lm.os == "macos" then
    require "compile.macos.make"
    return
end

lm.builddir = ("build/%s/%s"):format(lm.platform, lm.mode)
lm.EXE_DIR = "publish/bin/"..lm.os
lm.EXE_NAME = "lua-build"
lm:import "3rd/bee.lua/make.lua"

lm.runtime_platform = lm.platform
require "compile.common.runtime"

lm:default {
    "runtime",
}
