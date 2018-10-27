# frozen_string_literal: true

begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails", ref: "bd53f35"
  gem "sqlite3"
  gem "minitest"
end

require "active_record"
require "minitest/autorun"
require "logger"

# # This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :captains, force: true do |t|
  end

  create_table :ships, force: true do |t|
    t.integer :captain_id
  end

  create_table :sails, force: true do |t|
    t.integer :ship_id
    t.string :color
  end

  create_table :anchors, force: true do |t|
    t.integer :ship_id
  end
end

class Captain < ActiveRecord::Base
  has_many :ships
  has_many :sails, ->{ where(color: :red) }, through: :ships
  has_many :anchors, through: :ships
end

class Ship < ActiveRecord::Base
  belongs_to :captain
  has_many :sails
  has_many :anchors
end

class Sail < ActiveRecord::Base
  belongs_to :ship
end

class Anchor < ActiveRecord::Base
  belongs_to :ship
end

class BugTest < Minitest::Test
  def test_association_stuff
    sql = Captain.eager_load(:ships, :sails, :anchors).to_sql
    puts sql
    assert_equal 1, sql.scan(/LEFT OUTER JOIN "ships"/).length
    assert_equal 1, 1
  end
end