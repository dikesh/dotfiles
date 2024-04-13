#!/usr/bin/env nu

def main [project github_repo since_date until_date] {
  # Log format
  const delim = '###'
  const log_format = [format:%at %s %H %h %an] | str join $delim
  let gh_url_prefix = $"https://github.com/($github_repo)/commit/"

  git log --reverse --pretty=($log_format) --since $since_date --until $until_date --no-merges
    | lines
    | each {split row $delim | do {
      let commit_date = $in.0 | into datetime -f "%s" | format date '%F'
      let commit_link = $"=HYPERLINK\(\"($gh_url_prefix)($in.3)\", \"($in.1)\"\)"
      [$commit_date $project $commit_link $in.2 xxx -1 $in.4] | str join "\t"
    }}
    | to text
}
