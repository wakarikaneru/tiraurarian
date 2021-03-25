namespace :tiramon_set_factor do
  desc "tiramon_set_factor"
  task tiramon_set_factor: :environment do
    Tiramon.find_each do |t|
      t.generate_factor
      t.factor_name = Tiramon.get_factor_name(t.getFactor.to_a)
      t.save!
    end
  end
end
