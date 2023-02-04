require_relative("lib/hlockey-cli/version")

Gem::Specification.new do |s|
  s.name = "hlockey-cli"
  s.version = HlockeyCLI::VERSION
  s.summary = "Enjoy Hlockey from your terminal."
  s.description = "Hlockey console application."
  s.authors = ["Lavender Perry"]
  s.email = "endie2@protonmail.com"
  s.license = "LicenseRef-LICENSE.md"
  s.homepage = "https://github.com/Hlockey/cli"
  s.metadata = {"source_code_uri" => s.homepage}
  s.files = Dir["lib/**/*"]
  s.executables = "hlockey"

  s.add_dependency("hlockey", "3")
end
