# frozen_string_literal: true

require 'bundler/audit/scanner'
require 'bundler/cli/outdated'
require 'auditorb/stdout_suppressor'

module Auditorb
  class GemfileAnalyzer
    def analyze
      all_gems.map do |gem_spec|
        gem_info = { name: gem_spec.name }
        check_versions(gem_spec, gem_info)
        check_vulnerabilities(gem_info)
        gem_info
      end.sort_by { |gem_info| gem_info[:name] }
    end

    private def check_versions(gem_spec, gem_info)
      outdated_specs = outdated_gems.find do |spec|
        latest_version = spec[:active_spec]
        latest_version.name == gem_spec.name &&
          latest_version.version != gem_spec.version
      end
      if outdated_specs
        latest_version = outdated_specs[:active_spec]
      else
        latest_version = gem_spec
      end

      gem_info.merge!(
        installed_version: gem_spec.version.to_s,
        latest_version: latest_version.version.to_s,
        installed_version_release: gem_spec.date.to_date,
        latest_version_release: latest_version.date.to_date
      )
    end

    private def check_vulnerabilities(gem_info)
      gem_info[:vulnerability] = vulnerabilities.any? do |vulnerability|
        vulnerability.gem.name == gem_info[:name]
      end
    end

    private def outdated_gems
      return @outdated_gems if @outdated_gems

      outdated = Bundler::CLI::Outdated.new({}, [])
      begin
        Auditorb::StdoutSuppressor.suppress { outdated.run }
      rescue SystemExit => e
        # The outdated command raises a SystemExit when it finishes, so we need
        # to catch it to continue our work
      end
      @outdated_gems = outdated.outdated_gems
    end

    private def vulnerabilities
      @vulnerabilities ||= Auditorb::StdoutSuppressor.suppress do
        Bundler::Audit::Scanner.new.report.results
      end
    end

    private def all_gems
      @all_gems ||= Auditorb::StdoutSuppressor.suppress do
        Bundler.definition.specs
      end
    end
  end
end
