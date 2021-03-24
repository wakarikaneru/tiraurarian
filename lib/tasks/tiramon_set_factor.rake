namespace :tiramon_set_factor do
  desc "tiramon_set_factor"
  task tiramon_set_factor: :environment do
    Tiramon.find_each do |t|
        t.factor = Tiramon.generate_factor
        t.factor_name = Tiramon.get_factor_name
        t.save!
    end
  end
end
