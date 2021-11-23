local lm = require "luamake"

if lm.platform == "darwin-arm64" then
    lm.target = "arm64-apple-macos11"
else
    lm.target = "x86_64-apple-macos10.12"
end

lm.builddir = ("build/%s/%s"):format(lm.platform, lm.mode)
lm.EXE_DIR = "publish/bin/macos"
lm.EXE_NAME = "lua-build"
lm:import "3rd/bee.lua/make.lua"

lm.runtime_platform = lm.platform
require "compile.common.runtime"

if lm.platform == "darwin-arm64" then
    lm:build "x86_64" {
        "$luamake",
        "-C", lm.workdir,
        "-f", "compile/common/runtime.lua",
        "-builddir", "build/darwin-x64/"..lm.mode,
        "-target", "x86_64-apple-macos10.12",
        "-runtime_platform", "darwin-x64",
        pool = "console",
    }
end

lm:default {
    "runtime",
    lm.platform == "darwin-arm64" and "x86_64"
}
