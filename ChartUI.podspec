Pod::Spec.new do |spec|

  spec.name         = "ChartUI"
  spec.version      = "0.1.6"
  spec.summary      = "📈 A SwiftUI chart library"
  spec.homepage     = "https://github.com/theo-brlle/chart-ui"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Théo Brouillé" => "theo.brouille3@gmail.com" }
  spec.social_media_url   = "https://twitter.com/theo_brlle"

  spec.platform     = :ios, "15.0"
  spec.swift_versions     = "5.5"
  spec.source       = { :git => "https://github.com/theo-brlle/chart-ui.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*"
  spec.resource_bundle = { "ChartUI" => ["Sources/ChartUI/Resources/*.lproj/*.strings"] }

end
