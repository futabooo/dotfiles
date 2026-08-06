#!/usr/bin/env python3
"""PreToolUse(ExitPlanMode) hook: open the plan-mode markdown in mo.

https://github.com/k1LoW/mo
"""

import json
import os
import shutil
import subprocess
import sys
import tempfile
import time


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    mo = shutil.which("mo") or "/opt/homebrew/bin/mo"
    if not os.access(mo, os.X_OK):
        return 0

    tool_input = payload.get("tool_input") or {}
    plan_file = tool_input.get("planFilePath") or ""
    plan_body = tool_input.get("plan") or ""

    # The plan file may still be getting written when this hook fires.
    for _ in range(20):
        if plan_file and os.path.isfile(plan_file):
            break
        time.sleep(0.05)
    else:
        if not plan_body:
            return 0
        fd, plan_file = tempfile.mkstemp(prefix="claude-plan-", suffix=".md")
        with os.fdopen(fd, "w") as f:
            f.write(plan_body)

    cwd = payload.get("cwd") or os.getcwd()
    target = "plan-" + (os.path.basename(cwd.rstrip("/")) or "default")

    try:
        subprocess.run(
            [mo, plan_file, "--target", target, "--open"],
            # mo rejects positional args when stdin is a pipe, and the hook
            # payload arrives on stdin.
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=15,
            check=False,
        )
    except Exception:
        pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
