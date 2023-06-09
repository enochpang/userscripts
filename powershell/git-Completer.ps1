$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    $sections = $commandAst.CommandElements | ForEach-Object { "$_" }

    if ($sections[1] -in "checkout", "co") {
        if ($sections[3] -eq "--") {

            $fileList = @(git ls-tree $sections[2] -r -t --name-only)
            $fileList -like "$wordToComplete*" 
        }

        $branchList = @(git branch --format='%(refname:short)')
        $branchList -like "$wordToComplete*" 
    }
}

Register-ArgumentCompleter -Native -CommandName git -ScriptBlock $scriptblock
