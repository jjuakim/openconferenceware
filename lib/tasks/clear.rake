desc "Clear everything"
task :clear => ["tmp:clear", "clear:cache"]

desc "Clear cache"
task "clear:cache" => :environment do
  CacheWatcher.expire
  SharedFragmentWatcher.render
  Dir["#{RAILS_ROOT}/public/javascripts/cache/*"].each { |filename| rm filename }
end
