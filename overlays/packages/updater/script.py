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


# https://github.com/NixOS/nixpkgs/blob/master/maintainers/scripts/update.nix#L183
@app.command()
def run(
    nixpkgs: Annotated[str, typer.Option()],
    maintainer: str | None = None,
    package: str | None = None,
    predicate: str | None = None,
    path: str | None = None,
    max_workers: int | None = None,
    keep_going: bool = True,
    commit: bool = False,
    skip_prompts: bool = False,
    order: Order | None = None,
):
    specs = sum(x is not None for x in [maintainer, package, predicate, path])

    if specs > 1:
        typer.echo(
            "You can only specify one of --maintainer, --package, --predicate, or --path.",
            err=True,
        )
        raise typer.Exit(1)
    elif specs == 0:
        path = "exported-derivations"

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

    cmd: list[str] = [
        "nix-shell",
        f"{nixpkgs}/maintainers/scripts/update.nix",
    ]

    if maintainer:
        cmd += ["--argstr", "maintainer", maintainer]

    if package:
        cmd += ["--argstr", "package", package]

    if predicate:
        cmd += ["--argstr", "predicate", predicate]

    if path:
        cmd += ["--argstr", "path", path]

    if max_workers is not None:
        cmd += ["--argstr", "max-workers", str(max_workers)]

    if keep_going:
        cmd += ["--argstr", "keep-going", "true"]

    if commit:
        cmd += ["--argstr", "commit", "true"]

    if skip_prompts:
        cmd += ["--argstr", "skip-prompts", "true"]

    if order:
        cmd += ["--argstr", "order", order.value]

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

    # we don't want to show this in the output
    cmd += [
        "--arg",
        "include-overlays",
        overlays,
    ]

    subprocess.run(cmd)


if __name__ == "__main__":
    app()
