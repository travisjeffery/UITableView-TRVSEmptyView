Pod::Spec.new do |s|
  s.name         = "UITableView+TRVSEmptyView"
  s.version      = "0.0.1"
  s.summary      = "Easiest way to show an empty/placeholder view for UITableViews."

  s.description  = <<-DESC
                   Easiest way to show an empty/placeholder view for UITableViews.
                   DESC

  s.homepage     = "https://github.com/travisjeffery/UITableView+TRVSEmptyView"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Travis Jeffery" => "tj@travisjeffery.com" }
  s.social_media_url   = "http://twitter.com/Travis Jeffery"

  s.source       = { :git => "https://gitub.com/travisjeffery/UITableView+TRVSEmptyView.git", :tag => "0.0.1" }

  s.source_files  = "", "UITableView+TRVSEmptyTableView/**/*.{h,m}"
  s.exclude_files = "UITableView+TRVSEmptyTableView/Exclude"
end

