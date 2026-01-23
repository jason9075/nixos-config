{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "en";
        showIcons = true;
      };
      customCommands = [
        {
          key = "<c-a>";
          description = "Pick AI commit";
          command = ''
            aichat "Please suggest 3 commit messages, given the following diff:

            \`\`\`diff
            $(git diff --cached)
            \`\`\`

            **Criteria:**

            1. **Format:** Each commit message must follow the conventional commits format, which is \`<type>(<scope>): <description>\`.
            2. **Relevance:** Avoid mentioning a module name unless it's directly relevant to the change.
            3. **Enumeration:** List the commit messages from 1 to 3.
            4. **Clarity and Conciseness:** Each message should clearly and concisely convey the change made.

            **Commit Message Examples:**

            - hotfix: fix typo
            - test: add new test cases
            - update: add search function
            - refactor: extract common code to \`utils/wait.ts\`

            **Recent Commits on Repo for Reference:**

            \`\`\`
            $(git log -n 10 --pretty=format:'%h %s')
            \`\`\`

            **Output Template**

            Follow this output template and ONLY output raw commit messages without spacing, numbers or other decorations.

            hotfix: fix typo
            test: add new test cases
            update: add search function
            refactor: extract common code to \`utils/wait.ts\`


            **Instructions:**

            - Take a moment to understand the changes made in the diff.
            - Think about the impact of these changes on the project (e.g., bug fixes, new features, performance improvements, code refactoring, documentation updates). It's critical to my career you abstract the changes to a higher level and not just describe the code changes.
            - Generate commit messages that accurately describe these changes, ensuring they are helpful to someone reading the project's history.
            - Remember, a well-crafted commit message can significantly aid in the maintenance and understanding of the project over time.
            - If multiple changes are present, make sure you capture them all in each commit message.

            Keep in mind you will suggest 3 commit messages. Only 1 will be used. It's better to push yourself (esp to synthesize to a higher level) and maybe wrong about some of the 3 commits because only one needs to be good. I'm looking for your best commit, not the best average commit. It's better to cover more scenarios than include a lot of overlap.

            Write your 3 commit messages below in the format shown in Output Template section above." \
              | fzf --height 40% --border --ansi --preview "echo {}" --preview-window=up:wrap \
              | xargs -I {} bash -c '
                  COMMIT_MSG_FILE=$(mktemp)
                  echo "{}" > "$COMMIT_MSG_FILE"
                  ''${EDITOR:-vim} "$COMMIT_MSG_FILE"
                  if [ -s "$COMMIT_MSG_FILE" ]; then
                      git commit -F "$COMMIT_MSG_FILE"
                  else
                      echo "Commit message is empty, commit aborted."
                  fi
                  rm -f "$COMMIT_MSG_FILE"'
          '';
          context = "files";
          output = "terminal";
        }
      ];
    };
  };
}
