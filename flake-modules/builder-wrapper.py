import json
import shlex
import subprocess
from typing import Annotated

import typer

app = typer.Typer(add_completion=False)


def subprocess_stdout(cmd: list[str]) -> str:
    return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()


@app.command(
    context_settings={
        "allow_extra_args": True,
        "ignore_unknown_options": True,
        "help_option_names": ["--wrapper-help"],
    }
)
def run(
    ctx: typer.Context,
    nix_exe: Annotated[str, typer.Option()],
    darwin_builder: Annotated[str, typer.Option()],
    linux_builder: Annotated[str, typer.Option()],
    home_builder: Annotated[str, typer.Option()],
    operation: Annotated[
        str, typer.Option("--operation", "-o", "--mode", "-m")
    ] = "switch",
    flake: str = "github:mirkolenz/nixos",
    name: Annotated[str | None, typer.Option("--name", "-n")] = None,
    use_home: Annotated[bool, typer.Option("--home/--system")] = False,
):
    os = subprocess_stdout(["uname", "-s"]).lower()

    if not name:
        name = subprocess_stdout(["uname", "-n"]).lower()

        if use_home:
            user = subprocess_stdout(["whoami"])
            name = f"{user}@{name}"

    if use_home:
        builder = home_builder
    elif os == "darwin":
        builder = darwin_builder
    elif os == "linux":
        builder = linux_builder
    else:
        raise ValueError("Unknown target")

    if use_home:
        flake_attribute = "homeConfigurations"
    elif os == "darwin":
        flake_attribute = "darwinConfigurations"
    elif os == "linux":
        flake_attribute = "nixosConfigurations"
    else:
        raise ValueError("Unknown target")

    is_impure: bool = json.loads(
        subprocess_stdout(
            [
                nix_exe,
                "eval",
                "--json",
                f'{flake}#{flake_attribute}."{name}".config.custom.impure_rebuild',
            ]
        )
    )

    cmd: list[str] = [builder, operation, "--flake", f'{flake}#"{name}"']

    if is_impure:
        cmd.append("--impure")

    cmd.extend(ctx.args)

    typer.echo(f"Running {shlex.join(cmd)}")
    subprocess.run(cmd)


if __name__ == "__main__":
    app()
