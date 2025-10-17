Running tests

These tests are plain Lua/Luau assert-based tests. To run them:

- With Luau (recommended if you have it installed):

```bash
luau tests/test_runner.lua
```

- With Lua 5.1+ (if the code is compatible):

```bash
lua tests/test_runner.lua
```

Notes:
- The project uses Luau type annotations; running via the Luau CLI will execute the code and ignore typecheck warnings from static analysis.
- If you see typechecker warnings inside your editor, they are from static analysis. The tests are runtime checks and should indicate pass/fail when run in the chosen interpreter.
