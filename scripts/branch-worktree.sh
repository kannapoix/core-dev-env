# Usage: branch-worktree <path> [branch-name]
# If no branch name is provided, uses the current branch

if [ -z "$1" ]; then
  echo "Usage: branch-worktree <path> [branch-name]"
  echo "  <path>: Directory path for the worktree"
  echo "  [branch-name]: Optional branch name (defaults to current branch)"
  exit 1
fi

WORKTREE_DIR="$1"

if [ -n "$2" ]; then
  BRANCH_NAME="$2"
else
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
fi

echo "Setting up git worktree for branch '$BRANCH_NAME' at $WORKTREE_DIR..."

# Check if branch exists
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  echo "Error: Branch '$BRANCH_NAME' does not exist"
  exit 1
fi

git worktree add "$WORKTREE_DIR" "$BRANCH_NAME"

#TODO: Do not use fixed repository name
ln --symbolic --force ~/core-dev-env/.envrc "$WORKTREE_DIR/.envrc"

cd "$WORKTREE_DIR" || exit
direnv allow

echo "Branch '$BRANCH_NAME' ready at $WORKTREE_DIR"
