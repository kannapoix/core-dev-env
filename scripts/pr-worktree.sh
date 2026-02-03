# Usage: pr-worktree <pr-number>
PR_NUMBER="$1"
BRANCH_NAME="pr-$PR_NUMBER"
WORKTREE_DIR="../bitcoin-$BRANCH_NAME"

echo "Setting up git worktree for PR #$PR_NUMBER..."

# Check if branch exists locally, fetch if not
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  git fpr "$PR_NUMBER"
fi

git worktree add "$WORKTREE_DIR" "$BRANCH_NAME"

#TODO: Do not use fixed repository name
ln --symbolic --force ~/core-dev-env/.envrc "$WORKTREE_DIR/.envrc"

cd "$WORKTREE_DIR" || exit
direnv allow

echo "PR #$PR_NUMBER ready at $WORKTREE_DIR"
