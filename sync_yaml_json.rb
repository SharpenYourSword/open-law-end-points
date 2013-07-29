#!/usr/bin/env ruby
require 'yaml'
require 'json'

class Syncronizr
  def initialize
    Dir.chdir(File.dirname(__FILE__))
    is_repo_clean?
  end

  def is_repo_clean?
    status = `git status -s --untracked-files=all`.each_line.map{|l| l.split(' ').last}
    status.empty? ? find_origin_master : dirty_yamls_and_dirty_jasons(status)
  end

  def find_origin_master
    @origin = `git log --pretty=format:'%h -%d' | grep 'origin/master'`.split(' ').first
    #in case others are pedantic like me
    unless @origin then @origin = `git log --pretty=format:'%h -%d' | grep 'github/master'`.split(' ').first end
    unless @origin then @origin = `git log --pretty=format:'%h -%d' | grep 'original/master'`.split(' ').first end
    if @origin then find_commits_after_origin_master(@origin) end
  end

  def find_commits_after_origin_master
    commits_to_parse = `git log --pretty=format:'%h' --reverse #{@origin}...HEAD`.each_line.map{|l| l.rstrip}
    if commits_to_parse then make_dirty_list(commits_to_parse) end
  end

  def make_dirty_list(commits)
    files = commits.map do |commit|
      `git diff-tree --name-only #{commit}`.split("\n")[1..-1]
    end
    dirty_yamls_and_dirty_jasons(files)
  end

  def dirty_yamls_and_dirty_jasons(files)
    to_change = files.reduce({:yaml=>[],:json=>[]}) do |hash, file|
      hash[:yaml] << file if File.extname(file) == ".yaml"
      hash[:json] << file if File.extname(file) == ".json"
      hash
    end
    unless @origin then find_origin_master end
    make_dirty_yamls_into_clean_jasons(to_change[:yaml].compact.uniq)
    make_dirty_jasons_into_clean_yamls(to_change[:json].compact.uniq)
  end

  def make_dirty_yamls_into_clean_jasons(files)
    unless files.empty?
      files.each do |yaml_file|
        data = YAML.load(IO.read(yaml_file))
        organize_the_data_set(data)
        json_file = File.join(File.dirname(yaml_file), File.basename(yaml_file, ".yaml") + ".json")
        IO.write(json_file, JSON.dump(data))
      end
    end
  end

  def make_dirty_jasons_into_clean_yamls(files)
    unless files.empty?
      files.each do |json_file|
        data = JSON.load(IO.read(json_file))
        data = organize_the_data_set(data)
        yaml_file = File.join(File.dirname(json_file), File.basename(json_file, ".json") + ".yaml")
        IO.write(yaml_file, YAML.dump(data))
      end
    end
  end

  def organize_the_data_set(data)
    ordered_data = data.keys.map{|k| k}.sort
    ordered_data.reduce({}){ | hash, key | hash[key] = begin; data[key]; rescue; ''; end; hash }
  end
end