#!/bin/sh
export APP_VER=$(mix run --eval "IO.puts(Application.spec(:kcsp_ex, :vsn))")
