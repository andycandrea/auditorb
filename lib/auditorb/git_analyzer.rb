# frozen_string_literal: true

module Auditorb
  class GitAnalyzer
    def analyze
      {
        commits: {
          master_not_develop: commit_count('develop..master'),
          develop_not_master: commit_count('master..develop')
        },
        contributors: contributor_data
      }
    end

    private def contributor_data
      contributors = `git shortlog develop -s`.split("\n")
      contributors.reduce([]) do |all, contributions|
        commit_count, contributor = contributions.strip.split("\t")
        all << { author: contributor, commit_count: commit_count.to_i }
      end
    end

    private def commit_count(branch)
      without_releases = '--invert-grep --grep="Updating app_version.yml"'
      `git rev-list --count #{branch} --no-merges #{without_releases}`.to_i
    end
  end
end
