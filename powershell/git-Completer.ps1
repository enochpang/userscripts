
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $sections = $commandAst.CommandElements | ForEach-Object { "$_" }

    switch ($sections[1]) {
        { $_ -in "checkout", "co" -and $sections[3] -eq "--" } {
            $fileList = @(git ls-tree $sections[2] -r -t --name-only)
            return $fileList -like "$wordToComplete*"
        }
        { $_ -in "checkout", "co" } {
            $branchList = @(git branch -a --format='%(refname:short)')
            return $branchList -like "$wordToComplete*"
        }
        { $_ -eq "branch" -and $sections[2] -eq "-d" } {
            $branchList = @(git branch --format='%(refname:short)')
            return $branchList -like "$wordToComplete*"
        }
        { $_ -eq "rebase" -and $sections[2] -eq "-i" } {
            $branchList = @(git branch --format='%(refname:short)')
            return $branchList -like "$wordToComplete*"
        }
        { $_ -eq "merge" } {
            $branchList = @(git branch --format='%(refname:short)')
            return $branchList -like "$wordToComplete*"
        }
    }
}