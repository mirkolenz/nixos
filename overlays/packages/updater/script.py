import shlex
import subprocess
from enum import StrEnum
from typing import Annotated

import typer

app = typer.Typer(
    add_completion=False,
    pretty_exceptions_enable=False,
)


class Order(StrEnum):
    TOPOLOGICAL = "topological"
    REVERSE_TOPOLOGICAL = "reverse-topological"


def cmd_arg(key: str, value: str | bool, raw: bool = False) -> list[str]:
    """Convert an argument to a list of strings for Nix."""

    if isinstance(value, bool):
        value = "true" if value else "false"

    return ["--arg" if raw else "--argstr", key, value]


# https://github.com/NixOS/nixpkgs/blob/master/maintainers/scripts/update.nix#L183
@app.command()
def run(
    nixpkgs: Annotated[str, typer.Option()],
    nix_shell: Annotated[str, typer.Option()] = "nix-shell",
    maintainer: Annotated[str | None, typer.Option("--maintainer", "-m")] = None,
    package: Annotated[str | None, typer.Option("--package", "-p")] = None,
    function: Annotated[str | None, typer.Option("--function", "-f")] = None,
    attrset: Annotated[str | None, typer.Option("--attrset", "-a")] = None,
    max_workers: Annotated[int | None, typer.Option()] = None,
    keep_going: Annotated[bool, typer.Option()] = True,
    commit: Annotated[bool, typer.Option()] = False,
    skip_prompt: Annotated[bool, typer.Option()] = True,
    order: Annotated[Order | None, typer.Option()] = None,
):
    specs = sum(x is not None for x in [maintainer, package, function, attrset])

    if specs > 1:
        typer.echo(
            "You can only specify one of maintainer, package, function, or attrset.",
            err=True,
        )
        raise typer.Exit(1)
    elif specs == 0:
        attrset = "custom-packages"

    cmd: list[str] = [
        nix_shell,
        f"{nixpkgs}/maintainers/scripts/update.nix",
    ]

    if maintainer is not None:
        cmd += cmd_arg("maintainer", maintainer)

    if package is not None:
        cmd += cmd_arg("package", package)

    if function is not None:
        cmd += cmd_arg("predicate", function, raw=True)

    if attrset is not None:
        cmd += cmd_arg("path", attrset)

    if max_workers is not None:
        cmd += cmd_arg("max-workers", str(max_workers))

    if keep_going:
        cmd += cmd_arg("keep-going", keep_going)

    if commit:
        cmd += cmd_arg("commit", commit)

    if skip_prompt:
        cmd += cmd_arg("skip-prompt", skip_prompt)

    if order is not None:
        cmd += cmd_arg("order", order.value)

    typer.echo(
        shlex.join(
            [
                cmd[0].split("/")[-1],
                cmd[1].split("/")[-1],
                *cmd[2:],
            ],
        ),
        err=True,
    )

    overlays = """
        let
            flake = builtins.getFlake (\"git+file://\" + toString ./.);
            overlay = import ./overlays {
                inherit (flake) inputs;
                self = flake;
                lib' = flake.lib;
            };
        in
        [ overlay ]
    """

    # we don't want to show this in the output
    cmd += cmd_arg("include-overlays", overlays, raw=True)

    subprocess.run(cmd)


if __name__ == "__main__":
    app()
