(module
  (type (;0;) (func))
  (func $write (type 0)
    (local i32)
    i32.const -3
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 1048582
      i32.add
      local.get 0
      i32.const 1048579
      i32.add
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048579))
  (global (;2;) i32 (i32.const 1048582))
  (global (;3;) i32 (i32.const 1048582))
  (export "memory" (memory 0))
  (export "write" (func $write))
  (export "WASM_MEMORY_BUFFER" (global 1))
  (export "__data_end" (global 2))
  (export "__heap_base" (global 3))
  (data (;0;) (i32.const 1048576) "abc")
  (data (;1;) (i32.const 1048579) ">>>"))
