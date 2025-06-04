import json
import subprocess
from typing import Annotated

import typer

app = typer.Typer(
    add_completion=False,
    pretty_exceptions_enable=False,
)


def subprocess_stdout(cmd: list[str]) -> str:
    result = subprocess.run(cmd, capture_output=True, text=True)

    try:
        result.check_returncode()
    except subprocess.CalledProcessError as e:
        typer.echo(e.stderr, err=True)
        exit(1)

    return result.stdout.strip()


@app.command(
    context_settings={
        "allow_extra_args": True,
        "ignore_unknown_options": True,
        "help_option_names": ["--wrapper-help"],
    }
)
def run(
    ctx: typer.Context,
    nix_exe: Annotated[str, typer.Option()] = "nix",
    darwin_builder: Annotated[str, typer.Option()] = "darwin-rebuild",
    linux_builder: Annotated[str, typer.Option()] = "nixos-rebuild",
    home_builder: Annotated[str, typer.Option()] = "home-manager",
    operation: Annotated[
        str, typer.Option("--operation", "-o", "--mode", "-m")
    ] = "switch",
    flake: str = "github:mirkolenz/nixos",
    name: Annotated[str | None, typer.Option("--name", "-n")] = None,
):
    node = subprocess_stdout(["uname", "-n"]).lower()
    kernel = subprocess_stdout(["uname", "-s"]).lower()
    user = subprocess_stdout(["whoami"]).lower()
    is_home = user != "root"

    if not name:
        name = f"{user}@{node}" if is_home else node

    if is_home:
        builder = home_builder
    elif kernel == "darwin":
        builder = darwin_builder
    else:
        builder = linux_builder

    if is_home:
        flake_attribute = "homeConfigurations"
    elif kernel == "darwin":
        flake_attribute = "darwinConfigurations"
    else:
        flake_attribute = "nixosConfigurations"

    is_impure: bool = json.loads(
        subprocess_stdout(
            [
                nix_exe,
                "eval",
                "--json",
                f'{flake}#{flake_attribute}."{name}".config.custom.impureRebuild',
            ]
        )
    )

    cmd: list[str] = [builder, operation, "--flake", f"{flake}#{name}"]

    if is_impure:
        cmd.append("--impure")

    cmd.extend(ctx.args)

    # typer.echo(f"Running {shlex.join(cmd)}")
    subprocess.run(cmd)


if __name__ == "__main__":
    app()
