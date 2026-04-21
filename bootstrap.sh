#!/bin/bash
#
# Clones the sibling repositories that the dissertation \input's from.
# Run once after cloning this repo; the parent directory will contain
# this repo plus three siblings.
#
# USAGE:
#   ./bootstrap.sh

set -e

cd "$(dirname "$0")/.."

clone_if_missing() {
  local repo=$1
  if [ -d "$repo" ]; then
    echo "skip $repo (already exists)"
  else
    echo "cloning $repo"
    git clone "https://github.com/andyreagan/$repo.git"
  fi
}

clone_if_missing sentiment-analysis-comparison-paper
clone_if_missing core-stories-code
clone_if_missing philanthropy-distributions-reorganized

# The sentiment paper's dissertation .tex files embed absolute
# /Users/andyreagan/... figure paths. Rewrite them to resolve from
# the dissertation directory (one level up) so pdflatex finds them.
for suffix in combined supplementary; do
  f="sentiment-analysis-comparison-paper/dissertation/sentiment-comparison-paper-dissertation-$suffix.tex"
  if [ -f "$f" ] && grep -q "/Users/andyreagan/projects/2015/03-sentiment-comparison/paper/dissertation/" "$f"; then
    sed -i.bak 's|/Users/andyreagan/projects/2015/03-sentiment-comparison/paper/dissertation/|../sentiment-analysis-comparison-paper/dissertation/|g' "$f"
    rm -f "$f.bak"
    echo "rewrote absolute paths in $f"
  fi
done

echo
echo "Siblings ready. From the dissertation directory, run: bash make-dissertation.sh"
