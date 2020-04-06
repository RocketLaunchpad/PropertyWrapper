# vi: ft=ruby

Pod::Spec.new do |s|
  s.name = "RIWrapper"
  s.version = "1.0.0"
  s.summary = "RIWrapper Library"

  s.description = <<-DESC
  RIWrapper Library for iOS
  DESC

  s.homepage = "https://www.rocketinsights.com"

  s.author = "Paul Calnan"

  s.source = { :git => "https://github.com/RocketLaunchpad/RIWrapper.git", :tag => "#{s.version}" }
  s.license = { :type => "MIT" }

  s.platform = :ios, "11.0"
  s.swift_version = "5.0"

  s.source_files = "Sources/RIWrapper/**/*.swift"
  s.resources = "Sources/RIWrapper/**/*.{storyboard,xcassets,strings,imageset,png}"
end

