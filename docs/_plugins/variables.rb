require 'json'
require 'yaml'

module Variables
  class Generator < Jekyll::Generator
    safe true

    def generate(site)

      # indicate to use min or development assets
      baseurl = site.config['baseurl']
      minified = true
      if baseurl.eql? ''
        minified = false
      end

      # minified = true # debug minified
      site.data['minified'] = minified

      metadata_files = {
        'bower' => '../bower.json',
        'package' => '../package.json',
        'bower_jquery' => '../bower_components/jquery/bower.json',
        'bower_tether' => '../bower_components/tether/bower.json'
      }

      metadata_files.each do |metadata, path|
        contents = JSON.parse(File.read(File.join(site.source, path)))
        site.data[metadata] = contents
      end

      # some quick access to common variables (instead of diving into package and bower)
      name = site.data['package']['name']
      version = site.data['package']['version']
      bootstrap_version = site.data['bower']['dependencies']['bootstrap']
      tether_version = site.data['bower_tether']['version']
      jquery_version = site.data['bower_jquery']['version']

      site.data['name'] = name
      site.data['version'] = version
      site.data['bootstrap_version'] = bootstrap_version
      site.data['tether_version'] = tether_version
      site.data['jquery_version'] = jquery_version


      # fabricate the archive and release links based on the site.repo and version
      repo = site.config['repo']
      site.data['download'] = {
        'source' => "#{repo}/archive/v#{version}.zip",
        'dist' => "#{repo}/releases/download/v#{version}/#{name}-#{version}-dist.zip"
      }

      site.data['cdn'] = {
        'jquery' => site.config['cdn']['jquery'].gsub(/VERSION/, jquery_version),
        'bootstrap' => site.config['cdn']['bootstrap'].gsub(/VERSION/, bootstrap_version),
        'tether' => site.config['cdn']['tether'].gsub(/VERSION/, tether_version)
      }

      #
      # puts "\n---------------------"
      # puts "site.config: #{site.config.to_yaml}"
      # puts "baseurl: #{baseurl}"
      # puts "minified: #{site.data['minified']}"

      # puts "site: #{site.to_yaml}"
      # puts site.data[:package]['version']
      # puts site.data.to_yaml
      # puts repo
      # puts version
    end
  end
end