import pynvim
import time
from pathlib import Path
import os
import subprocess
from jupyter_client import BlockingKernelClient
from jupyter_core.paths import jupyter_runtime_dir


@pynvim.plugin
class JupyterKernel:
    def __init__(self, vim):
        self.vim: pynvim.Nvim = vim
        self.client: BlockingKernelClient | None = None
        self.console = None
        self.kerneldir = Path(jupyter_runtime_dir())
        self.kernel_name = self.kerneldir / "kernel-qtconsole.json"

    @pynvim.command("JupyterAttach")
    def attach(self):
        vim_cfg_dir = os.path.dirname(os.environ["MYVIMRC"])
        qt_console_script = os.path.join(vim_cfg_dir, "scripts", "run_qtconsole.py")
        # kernel-qtconsole.json -> set in  ~/.jupyter/jupyter_qtconsole_config.py
        kernel = self.kerneldir / "kernel-qtconsole.json"

        if not os.path.exists(qt_console_script):
            self.vim.api.notify(
                f"JupyterAttach: QtConsole launcher not found: {qt_console_script}",
                0,
                {},
            )
            return

        if self.kernel_name.exists():
            if subprocess.run(["pgrep", "-f", qt_console_script]) != 0:
                # Dangling kernel file (remove before starting new script)
                self.kernel_name.unlink(missing_ok=True)
            else:
                self.vim.api.notify(
                    "JupyterAttach: already attached",
                    0,
                    {},
                )
                return

        self.console = subprocess.Popen(
            ["python", qt_console_script, "--style", "monokai"]
        )
        time.sleep(2.0)

        self.console.poll()

        if not kernel.exists():
            self.vim.api.notify(
                "JupyterAttach: QtConsole failed or kernel not exists"
                f" {self.kernel_name}",
                0,
                {},
            )
            return

        if self.client is not None:
            self.client.stop_channels()

        self.client = BlockingKernelClient()
        self.client.load_connection_file(kernel)
        self.client.start_channels()

        time.sleep(0.2)
        jupyter_boilerplate = """
%matplotlib inline
import pandas as pd
import numpy as np
        """
        self.execute((jupyter_boilerplate,))

        self.vim.api.notify("JupyterAttach: attached successfully", 0, {})

    @pynvim.command("JupyterClose")
    def detach(self):
        if self.client is not None:
            self.client.stop_channels()
            self.client = None
        if self.console:
            self.console.terminate()
            self.console = None

    @pynvim.function("JupyterExecute", sync=True)
    def execute(self, args):
        if self.client is None:
            return "JupyterExecute: not attached, call :JupyterAttach"

        code = args[0]

        try:
            self.client.execute(code, silent=False)
            return "ok"
        except Exception as e:
            return f"JupyterExecute: error {repr(e)}"

    @pynvim.command("JupyterInterrupt")
    def interrupt_kernel(self):
        if self.client is not None:
            try:
                msg = self.client.session.msg("interrupt_request", {})
                self.client.control_channel.send(msg)
                self.vim.api.notify("JupyterInterrupt: sent", 0, {})
            except Exception as e:
                self.vim.api.notify(f"JupyterInterrupt: error {repr(e)}", 0, {})
        else:
            self.vim.api.notify("JupyterInterrupt: not attached", 0, {})

    @pynvim.command("JupyterRestart")
    def restart_kernel(self):
        if self.client is not None:
            try:
                msg = self.client.session.msg("shutdown_request", {"restart": True})
                self.client.control_channel.send(msg)
                self.vim.api.notify("JupyterRestart: sent", 0, {})
            except Exception as e:
                self.vim.api.notify(f"JupyterRestart: error {repr(e)}", 0, {})
        else:
            self.vim.api.notify("JupyterRestart: not attached", 0, {})
