import json
import shlex
import subprocess
from typing import Annotated

import typer

EXPERIMENTAL_FLAGS = ["--extra-experimental-features", "nix-command flakes"]

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


def subprocess_returncode(cmd: list[str]) -> int:
    result = subprocess.run(
        cmd,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )

    return result.returncode


def discover_packages(nix_exe: str, flake: str, attribute: str) -> dict[str, str]:
    """Return a mapping of package names to store paths exported by *flake* for *attribute*."""

    expr = f"{flake}#{attribute}"
    raw = subprocess_stdout(
        [
            nix_exe,
            *EXPERIMENTAL_FLAGS,
            "eval",
            "--json",
            expr,
        ]
    )
    entries = json.loads(raw or "{}")

    if not isinstance(entries, dict) and not all(
        isinstance(key, str)
        and isinstance(value, str)
        and value.startswith("/nix/store/")
        for key, value in entries.items()
    ):
        typer.echo(
            f"{expr} did not evaluate to an attrset of package store paths", err=True
        )
        raise typer.Exit(1)

    return entries


def is_cached(nix_exe: str, cache: str, store_path: str) -> bool:
    """Return True when *store_path* exists in the remote cache."""

    status = subprocess_returncode([nix_exe, "path-info", "--store", cache, store_path])

    return status == 0


@app.command(
    context_settings={
        "allow_extra_args": True,
        "ignore_unknown_options": True,
    }
)
def run(
    ctx: typer.Context,
    nix_exe: Annotated[str, typer.Option()],
    flake: Annotated[str, typer.Option()],
    cache: str = "https://mirkolenz.cachix.org",
    attribute: str = "drvsCi",
):
    """Build packages that cannot be substituted from *cache*."""

    packages = discover_packages(nix_exe, flake, attribute)

    if not packages:
        typer.echo("No packages exported by the flake.")
        raise typer.Exit(0)

    missing: list[str] = []

    for name, store_path in packages.items():
        if not is_cached(nix_exe, cache, store_path):
            missing.append(f"{flake}#{name}")

    if not missing:
        typer.echo("All packages are already cached.")
        raise typer.Exit(0)

    cmd: list[str] = [
        nix_exe,
        *EXPERIMENTAL_FLAGS,
        "build",
        *missing,
        *ctx.args,
    ]

    typer.echo(
        shlex.join([cmd[0].split("/")[-1], *cmd[1:]]),
        err=True,
    )

    subprocess.run(cmd)


if __name__ == "__main__":
    app()
