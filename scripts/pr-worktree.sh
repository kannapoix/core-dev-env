# Usage: pr-worktree <pr-number>
# Environment variables:
#   CORE_DEV_ENV_DIR: Path to core-dev-env (default: $HOME/core-dev-env)
PR_NUMBER="$1"
BRANCH_NAME="pr-$PR_NUMBER"
WORKTREE_DIR="../bitcoin-$BRANCH_NAME"

# Get path to .envrc in core-dev-env
CORE_DEV_ENV_DIR="${CORE_DEV_ENV_DIR:-$HOME/core-dev-env}"
ENVRC_PATH="$CORE_DEV_ENV_DIR/.envrc"

# Check if branch exists locally, fetch if not
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  git fpr "$PR_NUMBER"
fi

git worktree add "$WORKTREE_DIR" "$BRANCH_NAME"

ln --symbolic --force "$ENVRC_PATH" "$WORKTREE_DIR/.envrc"

cd "$WORKTREE_DIR" || exit
direnv allow

echo "PR #$PR_NUMBER ready at $WORKTREE_DIR"
