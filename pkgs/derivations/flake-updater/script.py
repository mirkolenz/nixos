import os
import re
import shlex
import subprocess
from pathlib import Path
from typing import Annotated

import typer
from github import Github

app = typer.Typer(
    add_completion=False,
    pretty_exceptions_enable=False,
)

PATTERN = re.compile(
    r'^\s*url\s*=\s*"github:(?P<owner>[^/]+)/(?P<repo>[^/]+)/(?P<ref>[^"]+)"\s*;\s*#\s*autoupdate\s*$'
)


def get_latest_release(gh: Github, owner: str, repo: str) -> str | None:
    """Fetch the latest release tag from a GitHub repository."""
    try:
        gh_repo = gh.get_repo(f"{owner}/{repo}")
        release = gh_repo.get_latest_release()
        return release.tag_name
    except Exception:
        return None


def update_line(gh: Github, line: str, dry_run: bool) -> str:
    """Update a single line if it matches the autoupdate pattern."""
    match = PATTERN.search(line)

    if not match:
        return line

    owner = match.group("owner")
    repo = match.group("repo")
    current_ref = match.group("ref")

    latest = get_latest_release(gh, owner, repo)

    if latest is None:
        typer.echo(f"{owner}/{repo}: no release found", err=True)
        return line

    if latest == current_ref:
        typer.echo(f"{owner}/{repo}: up to date ({current_ref})", err=True)
        return line

    typer.echo(f"{owner}/{repo}: {current_ref} -> {latest}", err=True)

    if dry_run:
        return line

    return line.replace(
        f"github:{owner}/{repo}/{current_ref}",
        f"github:{owner}/{repo}/{latest}",
    )


@app.command()
def run(
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
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    gh = Github(token)

    content = flake_file.read_text()
    lines = content.splitlines(keepends=True)
    updated_lines = [update_line(gh, line, dry_run) for line in lines]
    new_content = "".join(updated_lines)

    if new_content == content:
        typer.echo("No changes needed", err=True)
        return

    if dry_run:
        typer.echo("Dry run, no changes written", err=True)
        return

    flake_file.write_text(new_content)

    if commit:
        git_cmd = [
            "git",
            "commit",
            "-m",
            "chore(deps): update flake.nix",
            str(flake_file),
        ]
        typer.echo(shlex.join(git_cmd), err=True)
        subprocess.run(git_cmd)

    nix_cmd = [
        "nix",
        "flake",
        "update" if update else "lock",
        "--commit-lock-file",
    ]
    typer.echo(shlex.join(nix_cmd), err=True)
    subprocess.run(nix_cmd)


if __name__ == "__main__":
    app()
