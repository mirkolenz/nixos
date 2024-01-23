import shlex
import subprocess
from typing import Annotated, Optional

import typer

app = typer.Typer()


@app.command(
    context_settings={"allow_extra_args": True, "ignore_unknown_options": True}
)
def run(
    ctx: typer.Context,
    builder: str,
    operation: Annotated[str, typer.Option("--operation", "-o")] = "switch",
    flake: str = "github:mirkolenz/nixos",
    hostname: Optional[str] = None,
    pure: Annotated[bool, typer.Option("--pure/--impure")] = False,
    write_lock_file: bool = False,
):
    cmd: list[str] = [builder, operation]

    if hostname:
        cmd.extend(["--flake", f"{flake}#{hostname}"])
    else:
        cmd.extend(["--flake", flake])

    if not pure:
        cmd.append("--impure")

    if not write_lock_file:
        cmd.append("--no-write-lock-file")

    cmd.extend(ctx.args)

    typer.echo(f"Running: {shlex.join(cmd)}")
    subprocess.run(cmd)


if __name__ == "__main__":
    app()
