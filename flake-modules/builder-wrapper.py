import shlex
import subprocess
from typing import Annotated, Optional

import typer

app = typer.Typer(add_completion=False)


@app.command(
    context_settings={
        "allow_extra_args": True,
        "ignore_unknown_options": True,
        "help_option_names": ["--wrapper-help"],
    }
)
def run(
    ctx: typer.Context,
    builder: str,
    pure: Annotated[bool, typer.Option("--pure/--impure")] = False,
    operation: Annotated[
        str, typer.Option("--operation", "-o", "--mode", "-m")
    ] = "switch",
    flake: str = "github:mirkolenz/nixos",
    name: Annotated[Optional[str], typer.Option("--name", "-n")] = None,
):
    cmd: list[str] = [builder, operation]

    if name:
        cmd.extend(["--flake", f"{flake}#{name}"])
    else:
        cmd.extend(["--flake", flake])

    if not pure:
        cmd.append("--impure")

    cmd.extend(ctx.args)

    typer.echo(f"Running {shlex.join(cmd)}")
    subprocess.run(cmd)


if __name__ == "__main__":
    app()
