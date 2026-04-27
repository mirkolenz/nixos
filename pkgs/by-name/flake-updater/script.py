import re
import shlex
import subprocess
from pathlib import Path
from typing import Annotated

import typer

app = typer.Typer(
    add_completion=False,
    pretty_exceptions_enable=False,
)

# Match lines with `url = "github:owner/repo/ref"; # autoupdate`
PATTERN = re.compile(
    r'url = "github:(?P<owner>\S+?)/(?P<repo>\S+?)/(?P<ref>\S+?)"; # autoupdate'
)


def get_latest_release(gh_exe: str, owner: str, repo: str) -> str | None:
    """Fetch the latest release tag via the gh CLI."""
    result = subprocess.run(
        [
            gh_exe,
            "api",
            f"repos/{owner}/{repo}/releases/latest",
            "--jq",
            ".tag_name",
        ],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        return None

    return result.stdout.strip() or None


def replace_match(gh_exe: str, match: re.Match[str]) -> str:
    owner = match.group("owner")
    repo = match.group("repo")
    current_ref = match.group("ref")

    latest = get_latest_release(gh_exe, owner, repo)

    if latest is None:
        typer.echo(f"{owner}/{repo}: no release found", err=True)
        return match.group(0)

    if latest == current_ref:
        typer.echo(f"{owner}/{repo}: up to date ({current_ref})", err=True)
        return match.group(0)

    typer.echo(f"{owner}/{repo}: {current_ref} -> {latest}", err=True)

    return match.group(0).replace(
        f"github:{owner}/{repo}/{current_ref}",
        f"github:{owner}/{repo}/{latest}",
    )


@app.command()
def run(
    gh_exe: Annotated[str, typer.Option()],
    git_exe: Annotated[str, typer.Option()],
    nix_exe: Annotated[str, typer.Option()],
    flake_file: Annotated[
        Path,
        typer.Argument(
            exists=True,
            file_okay=True,
            dir_okay=False,
            readable=True,
            writable=True,
        ),
    ] = Path("flake.nix"),
    dry_run: Annotated[bool, typer.Option("--dry-run", "-n")] = False,
    commit: Annotated[bool, typer.Option("--commit", "-c")] = False,
    update: Annotated[bool, typer.Option("--update", "-u")] = True,
):
    """Update flake.nix inputs marked with # autoupdate comment."""
    content = flake_file.read_text()
    new_content = PATTERN.sub(lambda m: replace_match(gh_exe, m), content)

    if dry_run:
        typer.echo("Dry run, no changes written", err=True)
        raise typer.Exit(0)

    if new_content == content:
        typer.echo("No changes needed", err=True)
    else:
        flake_file.write_text(new_content)

        if commit:
            git_cmd = [
                git_exe,
                "commit",
                "-m",
                "chore(deps/flake): update",
                str(flake_file),
            ]
            typer.echo(shlex.join(git_cmd), err=True)
            subprocess.run(git_cmd)

    nix_cmd = [
        nix_exe,
        "flake",
        "update" if update else "lock",
    ]

    if commit:
        nix_cmd.append("--commit-lock-file")

    typer.echo(shlex.join(nix_cmd), err=True)
    subprocess.run(nix_cmd)


if __name__ == "__main__":
    app()
