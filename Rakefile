# encoding: UTF-8
require 'rubygems'
require 'rake'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ninja-bot"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "kuadrosxx@gmail.com"
    gem.homepage = "http://github.com/kuadrosx/ninja-bot"
    gem.authors = ["Jorge H. Cuadrado"]
    gem.add_dependency "cinch", "~>1.0"
    gem.add_dependency "mongo_mapper", "~>0.8"
    gem.add_dependency "nokogiri"
    gem.add_dependency "mechanize"
    gem.add_dependency "httparty"
    gem.add_dependency "ago"
    gem.add_dependency "ideone"
    gem.add_dependency "imdb"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ninja-bot #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :environment do
  $:.unshift File.dirname(__FILE__)+"/lib"
  require 'ninja_bot'

  raw_config = File.read(File.dirname(__FILE__)+"/config/ninja-bot.yml")
  APP_CONFIG = YAML.load(raw_config)
  APP_CONFIG.each do |server, opts|
    if opts[:database]
      NinjaBot.database=opts.delete(:database)
      NinjaBot.load_models
      break
    end
  end
end

namespace :ninjabot do
  desc "Load trivia data"
  task :load_trivia => :environment do
    Question.destroy_all
    Dir.glob(File.dirname(__FILE__)+"/trivia/*.txt").each do |path|
      puts "Loading: #{path}..."
      file = File.basename(path)
      language = file.split(".").last

      File.open(path, "r") do |f|
        data = {}
        f.each_line do |line|
          line.downcase!

          category, rest = line.split("©", 2)
          author, rest = rest.split("«", 2)
          text, answer = rest.split("*", 2)

          Question.create(:language => "es",
                          :text => text.strip.sub!(/\.$/, "?"),
                          :category => category,
                          :answer => answer.strip)
        end
      end
    end
  end
end

