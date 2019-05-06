#! /usr/bin/env ruby
require 'octokit'

TRAVIS_PULL_REQUEST = ENV['TRAVIS_PULL_REQUEST']

GITHUB_TOKEN = ENV['GITHUB_TOKEN']
REPO  = ENV['TRAVIS_REPO_SLUG']

LABEL = 'レビュー待ち'
PLABEL = '指摘事項あり'
RELABEL = '再レビュー待ち'


def github_client
  Octokit::Client.new(access_token: GITHUB_TOKEN)
end

def label_attach
    puts "NOTE: #{LABEL} label attached"
    github_client.add_labels_to_an_issue(REPO, TRAVIS_PULL_REQUEST,[LABEL])
end

def label_replace(labels)
  pl = false
  rl = false
  labels.each do |label|
    if label[:name] == PLABEL
      pl = true
    end
    if label[:name] == RELABEL
      rl = true
    end
  end
  if pl == true && rl == false
    puts "NOTE: #{RELABEL} replace label "
    github_client.replace_all_labels(REPO, TRAVIS_PULL_REQUEST,[RELABEL])
    exit
  end
    puts "NOTE: Label already assigned"
    exit
end

def pr_label
  pr = github_client.pull_request(REPO, TRAVIS_PULL_REQUEST, :state => 'open')
  labels = pr[:labels]
  if labels.length == 0
    label_attach
  else
    label_replace(labels)
  end
end

if TRAVIS_PULL_REQUEST
  pr_label
end

