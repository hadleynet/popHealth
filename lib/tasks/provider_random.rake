require 'mongo'
require 'json'
require 'factory_girl'

db_name = ENV['DB_NAME'] || 'test'

namespace :provider do

  desc 'Generate n (default 10) random provider records and save them in the database'
  task :random, :n do |t, args|
    
    FactoryGirl.find_definitions
    
    n = args.n.to_i>0 ? args.n.to_i : 10
    
    n.times do
      Factory(:provider)
    end
    
    providers = Provider.all
    
    Record.all.each do |record|
      if (record.provider_performances.empty?)
        provider_performance = Factory.build(:provider_performance, provider_id: Provider.all.sample.id) if record.provider_performances.empty?
        record.provider_performances << provider_performance
      end
    end
  end

  desc 'Dump all providers and provider performance information'
  task :destroy_all do |t, args|
    
    Record.all.each do |record|
      record.provider_performances = [] unless record.provider_performances.empty?
      record.save!
    end
    
    Provider.all.each { |pr| pr.destroy }
    
  end
    
end