#ifndef wasm3_call_h
#define wasm3_call_h

#include "wasm3.h"
#include "m3_code.h"
#include "m3_exec.h"
#include "m3_compile.h"

M3Result  wasm3_CallWithArgs(
        IM3Function i_function,
        uint32_t i_argc,
        const char * const * i_argv,
        size_t *o_size,
        void *o_ret
);

#endif /* wasm3_call_h */