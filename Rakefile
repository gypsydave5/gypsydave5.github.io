require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"


GITHUB_REPONAME = "gypsydave5/gypsydave5.github.io"

task default: :publish

desc "build and run locally"
task :serve => [:tags] do
  system "bundle exec jekyll serve"
end

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end

desc 'Generate tags page'
task :tags do
  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  site.tags.sort.each do |tag, posts|
    html = ''
    html << <<-HTML
---
layout: default
title: Postings tagged "#{tag}"
---
    <h2 id="#{tag}">#{tag}</h1>
    HTML

    html << '<ul class="posts">'
    posts.each do |post|
      post_data = post.to_liquid
      html << <<-HTML
        <li><a href="#{post.url}">#{post_data['title']} - #{post_data['date'].strftime('%F')}</a></li>
      HTML
    end
    html << '</ul>'

    File.open("tags/#{tag.delete(' ')}.html", 'w+') do |file|
      file.puts html
    end

  end
  puts 'Done.'
end

desc "Generate and publish blog to GitHub Pages"
task :publish => [:generate, :tags] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.inspect}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin master --force"

    Dir.chdir pwd
  end
end