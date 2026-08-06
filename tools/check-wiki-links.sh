#!/bin/sh
#
# check-wiki-links.sh - verify that every wiki link into this repository resolves.
#
# The wiki hardcodes github.com/modelint/elevator/{blob,tree}/<branch>/<path>
# URLs. Any folder move here breaks them silently: nothing on either side
# validates them, and readers arrive through the wiki. Run this after
# reorganizing anything, and after bringing the linked branch forward.
#
# Links are checked against a *branch*, not your working tree, because that is
# what a reader following the link will get. A file you have moved but not yet
# pushed will correctly report as broken.
#
# Every link is validated against the branch you name, whichever branch its URL
# points at. So before fast-forwarding main you can preview the outcome with:
#
#   tools/check-wiki-links.sh working/elevator.wiki refine
#
# Usage:
#   tools/check-wiki-links.sh [wiki-dir] [branch]
#
# Defaults: wiki-dir = working/elevator.wiki, branch = main
# Exits 0 if every link resolves, 1 if any is broken, 2 on setup error.

set -u

repo=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "error: not inside the elevator git repository" >&2
    exit 2
}

wiki=${1:-$repo/working/elevator.wiki}
branch=${2:-main}

[ -d "$wiki" ] || {
    echo "error: no wiki directory at $wiki" >&2
    echo "       the wiki is a separate clone, normally symlinked as working/elevator.wiki" >&2
    exit 2
}
git -C "$repo" rev-parse --verify --quiet "$branch" >/dev/null || {
    echo "error: no such branch: $branch" >&2
    exit 2
}

links=$(mktemp) || exit 2
trap 'rm -f "$links"' EXIT

# Pull out the path portion of every link into this repo, whichever branch the
# URL happens to name; all of them get validated against $branch. That way you
# can ask "will these links work once main catches up?" by passing the branch
# that is ahead.
#
# find -L because the wiki is normally reached through a symlink, and BSD
# grep -r will not traverse one.
find -L "$wiki" -type f -name '*.md' -exec \
    grep -hoE "https://github\.com/modelint/elevator/(blob|tree)/[^/]+/[^)\"'> ]*" {} + 2>/dev/null |
    sed -E 's#.*/(blob|tree)/[^/]+/##' |
    sed -E 's/[.,;:]+$//' |
    sort -u > "$links"

total=0
broken=0
while IFS= read -r path; do
    [ -n "$path" ] || continue
    # Percent-decode, so paths containing spaces (methods/bank level) resolve.
    decoded=$(printf '%b' "$(printf '%s' "$path" | sed 's/%/\\x/g')")
    total=$((total + 1))
    if git -C "$repo" cat-file -e "$branch:$decoded" 2>/dev/null; then
        continue    # a file
    fi
    if [ -n "$(git -C "$repo" ls-tree -d --name-only "$branch:$decoded" 2>/dev/null)" ]; then
        continue    # a directory
    fi
    echo "BROKEN  $decoded"
    broken=$((broken + 1))
done < "$links"

# Their paths were validated above, but a link whose URL names a branch other
# than the one you are checking is worth surfacing: a link left pointing at a
# feature branch breaks for readers once that branch is deleted.
others=$(find -L "$wiki" -type f -name '*.md' -exec \
    grep -hoE "https://github\.com/modelint/elevator/(blob|tree)/[^/]+/" {} + 2>/dev/null |
    sed -E 's#.*/(blob|tree)/([^/]+)/#\2#' | sort -u | grep -v "^$branch$")
if [ -n "$others" ]; then
    echo
    echo "note: link URLs also name these other branches (paths still checked above):"
    echo "$others" | sed 's/^/  /'
fi

echo
if [ "$broken" -eq 0 ]; then
    echo "$total link(s) checked against '$branch': all resolve"
    exit 0
fi
echo "$total link(s) checked against '$branch': $broken broken"
exit 1