# Global Agent Instructions

## Looking at code

- Prefer local checkouts over API calls when inspecting code. Do not overwrite unstaged changes when updating a checkout.
- Pull the latest changes before working. Stash local changes first and restore them after the pull.
- Always create draft merge requests. Never create a non-draft merge request directly.
- Force-push with lease only when a merge request is still a draft and has no reviewer comments. Otherwise, add a new commit.
- Do not add comments that repeat what the code says. Use clear names and small functions or modules.
- Respect the single-responsibility principle.
- Add comments only when the approach has no clear precedent.
- Prefer concise, readable code.

## Communication

- Use ASD-STE100.
- Explain the plan before running commands.
- Treat questions as requests for information only. Do not make changes or run side-effecting commands unless the user gives a clear imperative request.

## Data manipulation

- Prefer shell tools for ad hoc data manipulation and structured-data queries.
- If code is necessary, use Python or TypeScript. Do not use Perl or Ruby.
